function MakISO {
  if (-Not(Build-Program)) {
    Write-Host "Program build failed in MakISO" -ForegroundColor Red
    return $false
  }
  if (-Not(Build-ISO)) {
    Write-Host "ISO build failed in MakISO" -ForegroundColor Red
    return $false
  }
  return $true
}