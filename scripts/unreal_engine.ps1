$ErrorActionPreference = 'Stop'

try {
  Write-Host "Installing AWS CLI"

  choco install awscli
  RefreshEnv.cmd

  Set-Location -Path "C:\"
  mkdir Unreal
  mkdir Unreal\$env:UNREAL_ENGINE_VERSION

  Write-Host "Pulling down Unreal Engine version $env:UNREAL_ENGINE_VERSION from S3"
  Write-Host "aws s3 sync s3://$env:BUCKET/$env:UNREAL_ENGINE_VERSION C:\Unreal\"
  aws s3 ls s3://$env:BUCKET/$env:UNREAL_ENGINE_VERSION
  aws s3 sync s3://$env:BUCKET/$env:UNREAL_ENGINE_VERSION C:\Unreal\$env:UNREAL_ENGINE_VERSION

  Get-ChildItem -Path C:\Unreal\ -Name
}

catch {
  Write-Error "Failed to pull Unreal Engine from S3"
  exit 1
}