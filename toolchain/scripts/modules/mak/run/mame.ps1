function MakRunMame {
  Write-Host "Mak run mame" -ForegroundColor Cyan
  Build-ISO
  Build-Mame
  Start-Mame
}