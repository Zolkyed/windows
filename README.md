<p align="center">
  <img src="./assets/banner.png" alt="Windows Ansible configuration banner">
</p>

<h1 align="center">Windows</h1>

<p align="center">
  <a href="https://github.com/Zolkyed/windows/stargazers"><img src="https://img.shields.io/github/stars/Zolkyed/windows?style=for-the-badge&logo=windows11&color=89b4fa&logoColor=89b4fa&labelColor=11111b" alt="GitHub stars"></a>
  <a href="https://github.com/Zolkyed/windows/forks"><img src="https://img.shields.io/github/forks/Zolkyed/windows?style=for-the-badge&logo=ansible&logoColor=a6e3a1&label=Forks&labelColor=11111b&color=a6e3a1" alt="GitHub forks"></a>
  <a href="https://github.com/Zolkyed/windows/commits/main/"><img src="https://img.shields.io/github/last-commit/Zolkyed/windows?style=for-the-badge&logo=github&logoColor=cba6f7&label=Last%20Commit&labelColor=11111b&color=cba6f7" alt="Last commit"></a>
</p>

---

## 🖥️ System Setup

The Windows customization roles are adapted from
[oxivanisher/collection-windows_desktop](https://github.com/oxivanisher/collection-windows_desktop/tree/main).
The repository keeps role names aligned with the
[Linux configuration](https://github.com/Zolkyed/linux) where both platforms
manage the same concern.

| Role | Configuration |
| --- | --- |
| `system/hostname` | Computer hostname |
| `system/debloater` | Unwanted AppX packages |
| `system/mouse` | Mouse acceleration |
| `system/cursor` | Windows black cursor scheme |
| `system/keyboard` | United States (Programmers) custom keyboard layout |
| `system/desktop` | Desktop shortcuts |
| `system/wallpaper` | Desktop wallpaper |
| `system/explorer` | File extensions, This PC, navigation pane, and classic context menu |
| `system/start_menu` | Suggestions and welcome content |
| `system/sounds` | Windows sound scheme |
| `system/notifications` | Toast notifications and Notification Center |
| `system/taskbar` | Search, Task View, and widgets |
| `system/execution_policy` | PowerShell profile execution |
| `system/fonts` | Fira Code, JetBrains Mono, Meslo, and Nerd Fonts symbols |
| `system/wsl` | WSL optional features and the Fedora Linux distribution |

---

## 📦 Applications

| Role | Packages and configuration |
| --- | --- |
| `apps/browser` | Brave and managed browser policies |
| `apps/downloader` | gallery-dl, HexChat, JDownloader, qBittorrent, and yt-dlp |
| `apps/google_drive` | Google Drive for desktop |
| `apps/emulation` | Azahar, Dolphin, and PCSX2 |
| `apps/media` | mpv, OBS Studio, and Spotify |
| `apps/dev` | Burp Suite, Fiddler, Git tooling, Node.js, PowerShell, Python, uv, and 7-Zip |
| `apps/ai` | Codex and Claude Code |
| `apps/vscode` | Visual Studio Code and extensions |

---

## 👤 User Setup

The user roles follow the same structure as the Linux repository.

| Role | Configuration |
| --- | --- |
| `user/ssh` | SSH directory and GitHub authorized keys |
| `user/gpg` | Gpg4win and `GNUPGHOME` |
| `user/shell` | PowerShell profile and oh-my-posh |
| `user/bin` | AutoHotkey scripts and supporting files in the user Startup folder |
| `user/dotfiles` | Chezmoi-managed Git, SSH, GPG, VS Code, mpv, and shell files |

---

## 🐧 WSL

`setup.yml` installs WSL and the Fedora Linux distribution
(`system/wsl`), then finishes by launching `wsl/bootstrap`, which creates the
WSL user, installs Ansible inside WSL, and runs `wsl.yml` locally against
itself — the same self-hosting pattern used by the
[Linux configuration](https://github.com/Zolkyed/linux)'s
`scripts/bootstrap-ansible.sh` and `inventory/local.ini`.

WSL uses Fedora, not Ubuntu, specifically because `dnf` packages the whole
modern CLI toolchain (`starship`, `zoxide`, `atuin`, `fzf`, `chezmoi`, `gh`,
`mise`'s dependencies) directly — no third-party apt repos or binary-rename
workarounds needed. Dotfiles are shared with the
[Linux configuration](https://github.com/Zolkyed/linux)'s chezmoi source
(cloned fresh, same as on native Arch machines), kept portable between the
two distros via a small path-detection helper in `plugins.zsh`.

| Role | Configuration |
| --- | --- |
| `wsl/bootstrap` | Creates the WSL user, installs Ansible, and runs `wsl.yml` |
| `wsl/base` | `wsl.conf` and passwordless sudo |
| `wsl/packages` | Base dnf packages (build tools, chezmoi, curl, jq, neovim, ripgrep, openssh-clients) |
| `wsl/git` | Git, git-lfs, and the GitHub CLI |
| `wsl/gpg` | GnuPG and the signing key |
| `wsl/shell` | zsh, fzf, zoxide, atuin, and Starship (Starship via its official installer; nothing else has a Fedora package) |
| `wsl/mise` | mise-managed Node.js, Rust, and Go |
| `wsl/dotfiles` | Chezmoi-managed dotfiles, shared with the Linux repository |

Re-run `wsl.yml` from inside WSL once bootstrapped:

```shell
cd ansible
ansible-playbook -i inventory/wsl.ini playbooks/wsl.yml --tags dotfiles
```

---

## 🚀 Installation

### Windows host

Open PowerShell as Administrator in the repository directory:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
.\scripts\setup.ps1 -Verbose
```

The script installs Chocolatey and OpenSSH Server, opens port 22, and enables
PowerShell profile execution.

### Ansible control node

Install the required packages:

```shell
sudo apt update
sudo apt install ansible sshpass
```

Clone the repository and install the Ansible collections:

```shell
git clone https://github.com/Zolkyed/windows.git
cd windows/ansible
ansible-galaxy collection install -r requirements.yml
```

Create `inventory/ssh.ini`:

```ini
[all]
desktop ansible_host=192.168.1.10

[all:vars]
ansible_connection=ssh
ansible_shell_type=cmd
ansible_user="desktop\\User"
```

Run the playbook:

```shell
ansible-playbook playbooks/setup.yml
```

---

## 🚀 Usage

Run selected roles by tag:

```shell
ansible-playbook playbooks/setup.yml --tags dev
ansible-playbook playbooks/setup.yml --tags wallpaper
ansible-playbook playbooks/setup.yml --tags ssh,gpg,shell,bin,dotfiles
```

---

## 📚 Resources

- [Zolkyed's Linux configuration](https://github.com/Zolkyed/linux)
- [AlexNabokikh's Windows playbook (pinned source)](https://github.com/AlexNabokikh/windows-playbook/tree/8be81399018d151e5f4f5ea08034fc4bd0ad30da)
- [Windows Desktop collection](https://github.com/oxivanisher/collection-windows_desktop)
- [brave-origin policy example](https://github.com/flyingPenguinW/brave-origin/blob/main/policies.json)
