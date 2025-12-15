function Install-RaineConfig {
  param (
    [Parameter(Mandatory=$true)][String] $Path
  )
  Write-Host "Installing Raine config" -ForegroundColor Yellow
  
  # Get the template path
  $templatePath = "$PSScriptRoot\raine32_sdl-template.cfg"
  
  # Ensure config directory exists
  if (-Not(Test-Path -Path "$Path\config")) {
    New-Item -ItemType Directory -Path "$Path\config" -Force | Out-Null
  }
  
  # Resolve the raine path
  $pathAbs = (Resolve-Path -Path $Path).Path
  
  # Read template and replace placeholder
  $content = [System.IO.File]::ReadAllText($templatePath).Replace("/*raine*/", $pathAbs)
  
  # Write default config
  [System.IO.File]::WriteAllText("$Path\config\raine32_sdl.cfg", $content)
  Copy-Item "$Path\config\raine32_sdl.cfg" "$Path\config\default.cfg" -Force

  # Create fullscreen config
  Copy-Item "$Path\config\raine32_sdl.cfg" "$Path\config\fullscreen.cfg" -Force
  $content = [System.IO.File]::ReadAllText("$Path\config\fullscreen.cfg").Replace("fullscreen = 0","fullscreen = 1")
  [System.IO.File]::WriteAllText("$Path\config\fullscreen.cfg", $content)
}
