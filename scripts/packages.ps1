#PowerShellGet requirest NuGet installation.
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install AWS CLI
Import-Module AWSPowerShell

# Install Chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Globally Auto confirm every action
choco feature enable -n allowGlobalConfirmation