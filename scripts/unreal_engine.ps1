$ErrorActionPreference = 'Stop'

try {
  Write-Host "Pulling down Unreal Engine version $env:UNREAL_ENGINE_VERSION from S3"
  Write-Host "Command to run: aws s3 sync $env:S3_BUCKET/$env:UNREAL_ENGINE_VERSION C:\Unreal\"
  aws s3 sync $env:S3_BUCKET/$env:UNREAL_ENGINE_VERSION "C:\Unreal\"
  Get-ChildItem -Path C:\Unreal\ -Name
}

catch {
  Write-Error "Failed to pull Unreal Engine from S3"
  exit 1
}