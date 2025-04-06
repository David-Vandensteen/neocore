function Install-RaineConfig {
  param (
    [Parameter(Mandatory=$true)][String] $Path
  )
  Write-Host "Installing Raine config" -ForegroundColor Yellow
  $pathAbs = (Resolve-Path -Path $Path).Path
  $content = [System.IO.File]::ReadAllText("$Path\config\raine32_sdl.cfg").Replace("/*neocd_bios*/","neocd_bios = $pathAbs\roms\NEOCD.BIN")
  [System.IO.File]::WriteAllText("$Path\config\raine32_sdl.cfg", $content)
  Copy-Item $Path\config\raine32_sdl.cfg $Path\config\default.cfg -Force

  Copy-Item $Path\config\raine32_sdl.cfg $Path\config\fullscreen.cfg -Force
  $content = [System.IO.File]::ReadAllText("$Path\config\fullscreen.cfg").Replace("fullscreen = 0","fullscreen = 1")
  [System.IO.File]::WriteAllText("$Path\config\fullscreen.cfg", $content)

  Copy-Item $Path\config\raine32_sdl.cfg $Path\config\yuv.cfg -Force
  $content = [System.IO.File]::ReadAllText("$Path\config\yuv.cfg").Replace("prefered_yuv_format = 0","prefered_yuv_format = 1").Replace("video_mode = 0", "video_mode = 2")
  [System.IO.File]::WriteAllText("$Path\config\yuv.cfg", $content)
}
