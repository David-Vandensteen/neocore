function Assert-ProjectGfxDat {
  Write-Host "Assert project gfx dat" -ForegroundColor Yellow

  if (-Not($Config.project.gfx.DAT.chardata)) {
    Write-Host "error : project.gfx.DAT.chardata not found" -ForegroundColor Red
    return $false
  }

  if (-Not($Config.project.gfx.DAT.fixdata)) {
    Write-Host "error : project.gfx.DAT.fixdata not found" -ForegroundColor Red
    return $false
  }

  Write-Host "Project GFX DAT configuration is valid" -ForegroundColor Green
  return $true
}