$ErrorActionPreference = 'Stop'

try {

  # Download and prep agentdir
  Invoke-WebRequest -Uri https://vstsagentpackage.azureedge.net/agent/2.187.1/vsts-agent-win-x64-2.187.1.zip -OutFile ~/Downloads/vsts-agent-win-x64-2.187.1.zip
  Set-Location - Path "C:\"
  mkdir agent ; Set-Location -Path "C:\agent"
  Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$HOME\Downloads\vsts-agent-win-x64-2.187.1.zip", "$PWD")

  # Install agent non-interactively
  .\config --unattended --url $env:URL --auth pat --token $env:PAT --pool $env:POOL --agent $env:NAME --replace --runAsService
}

catch {
  Write-Error "Failed to disable UAC"
  exit 1
}