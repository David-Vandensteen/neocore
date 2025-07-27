function Assert-RaineConfig {
  Write-Host "Assert Raine config" -ForegroundColor Yellow
  if (-Not(Resolve-TemplatePath -Path "$($Config.project.buildPath)\raine\config\raine32_sdl.cfg")) {
    Write-Host "$($Config.project.buildPath)\raine\config\raine32_sdl.cfg not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Resolve-TemplatePath -Path "$($Config.project.buildPath)\raine\config\default.cfg")) {
    Write-Host "$($Config.project.buildPath)\raine\config\default.cfg not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Resolve-TemplatePath -Path "$($Config.project.buildPath)\raine\config\fullscreen.cfg")) {
    Write-Host "$($Config.project.buildPath)\raine\config\fullscreen.cfg not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Resolve-TemplatePath -Path "$($Config.project.buildPath)\raine\config\yuv.cfg")) {
    Write-Host "$($Config.project.buildPath)\raine\config\yuv.cfg not found" -ForegroundColor Red
    return $false
  }
  return $true
}