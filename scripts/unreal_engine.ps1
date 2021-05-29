$ErrorActionPreference = 'Stop'

try {
  Write-Host "Importing AWSPowerShell Module"
  #PowerShellGet requirest NuGet installation.
  Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

  # Install AWS CLI
  Import-Module AWSPowerShell

  Set-Location -Path "C:\"
  mkdir Unreal

  Write-Host "Pulling down Unreal Engine version $env:UNREAL_ENGINE_VERSION from S3"
  Write-Host "Command to run: aws s3 sync $env:BUCKET/$env:UNREAL_ENGINE_VERSION C:\Unreal\"
  aws s3 ls $env:BUCKET/$env:UNREAL_ENGINE_VERSION
  aws s3 sync $env:BUCKET/$env:UNREAL_ENGINE_VERSION "C:\Unreal\"
  Get-ChildItem -Path C:\Unreal\ -Name
}

catch {
  Write-Error "Failed to pull Unreal Engine from S3"
  exit 1
}