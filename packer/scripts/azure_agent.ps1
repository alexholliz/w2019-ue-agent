$ErrorActionPreference = 'Stop'

try {

  # Download and prep agentdir
  Write-Host "Downloading Azure Agent"
  Invoke-WebRequest -Uri https://vstsagentpackage.azureedge.net/agent/2.187.1/vsts-agent-win-x64-2.187.1.zip -OutFile ~/Downloads/vsts-agent-win-x64-2.187.1.zip

  Write-Host "Making directory C:\agent"
  mkdir C:\agent

  Write-Host "Switching to C:\agent"
  Set-Location -Path "C:\agent"

  Write-Host "Unzipping Azure Agent to $PWD"
  Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$HOME\Downloads\vsts-agent-win-x64-2.187.1.zip", "$PWD")

  # Install agent non-interactively
  Write-Host "Installing Azure Agent non-interactively"
  .\config --unattended --url $env:URL --auth pat --token $env:PAT --pool $env:POOL --agent $env:NAME --replace --runAsService
}

catch {
  Write-Error "Failed to Install Azure Agent"
  exit 1
}