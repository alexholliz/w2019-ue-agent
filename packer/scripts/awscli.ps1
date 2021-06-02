$ErrorActionPreference = 'Stop'

try {
  choco install awscli
}

catch {
  Write-Error "Failed to install awscli"
  exit 1
}