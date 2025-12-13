function Install-RaineConfig {
  param (
    [Parameter(Mandatory=$true)][String] $Path
  )
  Write-Host "Installing Raine config" -ForegroundColor Yellow
  $pathAbs = (Resolve-Path -Path $Path).Path
  $content = [System.IO.File]::ReadAllText("$Path\config\raine32_sdl.cfg").Replace("/*raine*/", $pathAbs)
  [System.IO.File]::WriteAllText("$Path\config\raine32_sdl.cfg", $content)
  Copy-Item $Path\config\raine32_sdl.cfg $Path\config\default.cfg -Force

  Copy-Item $Path\config\raine32_sdl.cfg $Path\config\fullscreen.cfg -Force
  $content = [System.IO.File]::ReadAllText("$Path\config\fullscreen.cfg").Replace("fullscreen = 0","fullscreen = 1")
  [System.IO.File]::WriteAllText("$Path\config\fullscreen.cfg", $content)
}
