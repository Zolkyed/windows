#!/usr/bin/env bash
# Provisions a freshly installed WSL Fedora distribution: creates the target
# user, installs Ansible and its dependencies, and hands off to
# `ansible-playbook wsl.yml` running locally inside WSL.
#
# Runs as root (invoked as `wsl.exe -d FedoraLinux-44 -u root -- bash
# bootstrap.sh`) because a freshly installed distribution has no non-root
# user yet.
set -Eeuo pipefail

WSL_USER="${WSL_USER:-charl}"
WINDOWS_REPO="${WINDOWS_REPO:-https://github.com/Zolkyed/windows.git}"
WINDOWS_REPO_BRANCH="${WINDOWS_REPO_BRANCH:-main}"
readonly WSL_USER WINDOWS_REPO WINDOWS_REPO_BRANCH

readonly -a PACKAGES=(git ansible-core age curl ca-certificates)

die() {
    echo "ERROR: $*" >&2
    exit 1
}

as_user() {
    runuser -u "$WSL_USER" -- bash -c "$1"
}

require_root() {
    [[ "${EUID}" -eq 0 ]] || die "run this script as root (wsl.exe -u root)"
}

create_user() {
    if id -u "$WSL_USER" &>/dev/null; then
        echo "==> User ${WSL_USER} already exists; skipping."
        return
    fi

    echo "==> Creating user ${WSL_USER}"
    useradd --create-home --shell /bin/bash "$WSL_USER"
}

configure_passwordless_sudo() {
    local sudoers_file temporary

    sudoers_file="/etc/sudoers.d/99-ansible-${WSL_USER}"
    [[ ! -f "$sudoers_file" ]] || {
        echo "==> Passwordless sudo already configured for ${WSL_USER}."
        return
    }

    temporary="$(mktemp)"
    printf '%s ALL=(ALL:ALL) NOPASSWD: ALL\n' "$WSL_USER" >"$temporary"
    visudo -cf "$temporary" >/dev/null
    install -o root -g root -m 0440 "$temporary" "$sudoers_file"
    rm -f "$temporary"

    echo "==> Passwordless sudo configured for ${WSL_USER}"
}

configure_wsl_conf() {
    echo "==> Writing /etc/wsl.conf"
    cat >/etc/wsl.conf <<EOF
[boot]
systemd=true

[user]
default=${WSL_USER}
EOF
}

install_packages() {
    echo "==> Upgrading dnf packages"
    dnf upgrade -y

    echo "==> Installing bootstrap packages"
    dnf install -y "${PACKAGES[@]}"
}

install_age_identity() {
    local key_file="/home/${WSL_USER}/.config/sops/age/keys.txt"

    as_user "[[ -f '$key_file' ]]" \
        || die "age identity missing at ${key_file} — copy it from your password manager first"
    as_user "grep -q '^AGE-SECRET-KEY-' '$key_file'" \
        || die "existing file is not an age identity: ${key_file}"

    echo "==> Existing age identity retained at ${key_file}"
}

clone_windows_repo() {
    local repo_dir="/home/${WSL_USER}/windows"

    if as_user "[[ -d '${repo_dir}/.git' ]]"; then
        echo "==> ${repo_dir} already cloned; skipping."
        return
    fi

    echo "==> Cloning ${WINDOWS_REPO}"
    as_user "git clone --branch '$WINDOWS_REPO_BRANCH' '$WINDOWS_REPO' '$repo_dir'"
}

install_collections() {
    echo "==> Installing Ansible collections"
    as_user "cd /home/${WSL_USER}/windows/ansible && \
        ansible-galaxy collection install --requirements-file requirements.yml"
}

run_wsl_playbook() {
    echo "==> Running wsl.yml"
    as_user "cd /home/${WSL_USER}/windows/ansible && \
        ansible-playbook -i inventory/wsl.ini playbooks/wsl.yml"
}

main() {
    require_root
    create_user
    configure_passwordless_sudo
    configure_wsl_conf
    install_packages
    clone_windows_repo
    install_age_identity
    install_collections
    run_wsl_playbook

    echo "==> WSL bootstrap complete"
}

main "$@"
