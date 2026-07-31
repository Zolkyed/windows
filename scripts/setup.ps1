#Requires -RunAsAdministrator

# Adapted from:
# https://github.com/AlexNabokikh/windows-playbook/blob/8be81399018d151e5f4f5ea08034fc4bd0ad30da/setup.ps1

$ErrorActionPreference = 'Stop'

# Set PowerShell execution policy to RemoteSigned for the current user.
$executionPolicy = Get-ExecutionPolicy -Scope CurrentUser
if ($executionPolicy -eq 'RemoteSigned') {
    Write-Verbose 'Execution policy is already RemoteSigned; skipping.'
}
else {
    Write-Verbose 'Setting execution policy to RemoteSigned.'
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
}

# Install Chocolatey.
if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
    Write-Verbose 'Chocolatey is already installed; skipping.'
}
else {
    Write-Verbose 'Installing Chocolatey.'
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
    $installScript = Invoke-RestMethod `
        -Uri 'https://community.chocolatey.org/install.ps1'
    Invoke-Expression $installScript
}

# Install OpenSSH Server.
if (Get-Service -Name sshd -ErrorAction SilentlyContinue) {
    Write-Verbose 'OpenSSH Server is already installed; skipping.'
}
else {
    Write-Verbose 'Installing OpenSSH Server.'
    $openSshPackage = Get-WindowsCapability -Online |
        Where-Object Name -Like 'OpenSSH.Server*' |
        Select-Object -First 1 -ExpandProperty Name

    if (-not $openSshPackage) {
        throw 'The OpenSSH Server Windows capability was not found.'
    }

    Add-WindowsCapability -Online -Name $openSshPackage | Out-Null
}

Write-Verbose 'Starting OpenSSH Server.'
Set-Service -Name sshd -StartupType Automatic
Start-Service -Name sshd

$firewallRule = Get-NetFirewallRule `
    -Name 'OpenSSH-Server-In-TCP' `
    -ErrorAction SilentlyContinue
if (-not $firewallRule) {
    Write-Verbose 'Creating the OpenSSH Server firewall rule.'
    New-NetFirewallRule `
        -Name 'OpenSSH-Server-In-TCP' `
        -DisplayName 'OpenSSH Server (sshd)' `
        -Enabled True `
        -Profile Any `
        -Direction Inbound `
        -Protocol TCP `
        -Action Allow `
        -LocalPort 22 | Out-Null
}
else {
    Write-Verbose 'The OpenSSH Server firewall rule already exists.'
    Set-NetFirewallRule `
        -Name 'OpenSSH-Server-In-TCP' `
        -Enabled True `
        -Profile Any
}

# Deploy authorized keys for administrators, so key-based auth works on the
# very first connection (Windows OpenSSH ignores ~/.ssh/authorized_keys for
# accounts in the local Administrators group; it requires this file instead).
Write-Verbose 'Deploying administrators_authorized_keys.'
$authorizedKeysPath = Join-Path $env:ProgramData 'ssh\administrators_authorized_keys'
Invoke-RestMethod -Uri 'https://github.com/zolkyed.keys' -OutFile $authorizedKeysPath

icacls.exe $authorizedKeysPath /inheritance:r | Out-Null
icacls.exe $authorizedKeysPath /grant 'SYSTEM:F' | Out-Null
icacls.exe $authorizedKeysPath /grant 'Administrators:F' | Out-Null
