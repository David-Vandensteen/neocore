function MakRunMame {
  Write-Host "Mak run mame" -ForegroundColor Cyan
  if (-not (Build-ISO)) { return $false }
  if (-not (Build-Mame)) { return $false }
  if (-not (Start-Mame)) { return $false }
  return $true
}