$ErrorActionPreference = 'Stop'

try {
  # Install Visual Studio 2019 Community
  choco install visualstudio2019community

  #Install Game Development for C++ Workload for Visual Studio 2019
  choco install visualstudio2019-workload-nativegame

  choco install awscli
}

catch {
  Write-Error "Failed to install packages"
  exit 1
}