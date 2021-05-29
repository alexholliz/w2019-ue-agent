$ErrorActionPreference = 'Stop'

try {
  Write-Host "Importing AWSPowerShell Module"

  # Install AWS CLI
  msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi /passive

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