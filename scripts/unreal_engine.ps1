$ErrorActionPreference = 'Stop'

try {
  Write-Host "Importing AWSPowerShell Module"

  # Install AWS CLI
  Import-Module AWSPowerShell

  Set-Location -Path "C:\"
  mkdir Unreal

  Write-Host "Pulling down Unreal Engine version $env:UNREAL_ENGINE_VERSION from S3"
  Write-Host "Command to run: aws s3 sync $env:BUCKET/$env:UNREAL_ENGINE_VERSION C:\Unreal\"
  # aws s3 ls s3://$env:BUCKET/$env:UNREAL_ENGINE_VERSION
  Get-S3Object -BucketName $env:BUCKET $env:UNREAL_ENGINE_VERSION

  # aws s3 sync s3://$env:BUCKET/$env:UNREAL_ENGINE_VERSION "C:\Unreal\"
  Read-S3Object -BucketName $env:BUCKET -KeyPrefix $env:UNREAL_ENGINE_VERSION 'C:\Unreal\$env:UNREAL_ENGINE_VERSION'

  Get-ChildItem -Path C:\Unreal\ -Name
}

catch {
  Write-Error "Failed to pull Unreal Engine from S3"
  exit 1
}