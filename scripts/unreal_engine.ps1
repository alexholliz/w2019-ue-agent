$ErrorActionPreference = 'Stop'

try {
  Set-Location -Path "C:\"
  mkdir Unreal
  mkdir Unreal\$env:UNREAL_ENGINE_VERSION

  aws --version
  aws s3 ls

  Write-Host "Pulling down Unreal Engine version $env:UNREAL_ENGINE_VERSION from S3"
  Write-Host "aws s3 sync s3://$env:BUCKET/$env:UNREAL_ENGINE_VERSION C:\Unreal\$env:UNREAL_ENGINE_VERSION --only-show-errors"

  aws s3 sync s3://$env:BUCKET/$env:UNREAL_ENGINE_VERSION C:\Unreal\$env:UNREAL_ENGINE_VERSION --only-show-errors

  Get-ChildItem -Path C:\Unreal\ -Name
}

catch {
  Write-Error "Failed to pull Unreal Engine from S3"
  exit 1
}