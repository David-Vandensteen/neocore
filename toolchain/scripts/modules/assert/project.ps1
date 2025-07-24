function Assert-Project {
  param ([Parameter(Mandatory=$true)][xml] $Config)

  Write-Host "Assert project" -ForegroundColor Yellow
  if (-Not(Assert-Path)) {
    Write-Host "Path assertion failed" -ForegroundColor Red
    return $false
  }
  Assert-ProjectName -Name $($Config.project.name)

  if (-Not($Config.project.name)) {
    Write-Host "error : project.name not found" -ForegroundColor Red
    return $false
  }
  if (-Not($Config.project.version)) {
    Write-Host "error : project.version not found" -ForegroundColor Red
    return $false
  }
  if (-Not($Config.project.makefile)) {
    Write-Host "error : project.makefile not found" -ForegroundColor Red
    return $false
  }
  if (-Not($Config.project.neocorePath)) {
    Write-Host "error : project.neocorePath not found" -ForegroundColor Red
    return $false
  }
  if (-Not($Config.project.buildPath)) {
    Write-Host "error : project.buildPath not found" -ForegroundColor Red
    return $false
  }
  if (-Not($Config.project.distPath)) {
    Write-Host "error : project.distPath not found" -ForegroundColor Red
    return $false
  }
  if (-Not($Config.project.gfx)) {
    Write-Host "error : project.gfx not found" -ForegroundColor Red
    return $false
  } else {
    Assert-ProjectGfxDat
  }
  if (-Not($Config.project.emulator)) {
    Write-Host "error : project.emulator not found" -ForegroundColor Red
    return $false
  }
  if (-Not($Config.project.compiler)) {
    Write-Host "error : project.compiler not found" -ForegroundColor Red
    return $false
  }
  if (-Not($Config.project.compiler.path)) {
    Write-Host "error : project.compiler.path not found" -ForegroundColor Red
    return $false
  }
  if (-Not($Config.project.compiler.includePath)) {
    Write-Host "error : project.compiler.includePath not found" -ForegroundColor Red
    return $false
  }
  if (-Not($Config.project.compiler.libraryPath)) {
    Write-Host "error : project.compiler.libraryPath not found" -ForegroundColor Red
    return $false
  }
  if (-Not($Config.project.compiler.systemFile)) {
    Write-Host "error : project.compiler.systemFile not found" -ForegroundColor Red
    return $false
  }

  if ($Config.project.sound) {
    if ($Config.project.sound.cdda) {
      if (-Not($Config.project.sound.cdda.dist.iso.format)) {
        Write-Host "error : project.sound.cdda.dist.iso.format not found" -ForegroundColor Red
        return $false
      }
      if (-Not($Config.project.sound.cdda.tracks)) {
        Write-Host "error : project.sound.cdda.tracks not found" -ForegroundColor Red
        return $false
      }
    }
  }

  Write-Host "project config is compliant" -ForegroundColor Green
  return $true
}
