$ErrorActionPreference = 'Stop'

try {

  Write-Host “Disabling UAC…”
  New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLUA -PropertyType DWord -Value 0 -Force
  New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -PropertyType DWord -Value 0 -Force
}

catch {
  Write-Error "🔥🔥🔥 Failed to disable UAC"
  exit 1
}