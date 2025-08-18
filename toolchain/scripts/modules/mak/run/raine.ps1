function MakRunRaine {
  Write-Host "Mak run raine" -ForegroundColor Cyan
  if (-not (Build-ISO)) { return $false }
  if (-not (Start-Raine)) { return $false }
  return $true
}