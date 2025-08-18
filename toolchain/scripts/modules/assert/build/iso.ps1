function Assert-BuildISO {
  Write-Host "Assert build ISO" -ForegroundColor Yellow
  if (-Not(Test-Path -Path $prgFile)) {
    Write-Host "error : $prgFile not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Test-Path -path $spriteFile)) {
    Write-Host "error : $spriteFile not found" -ForegroundColor Red
    return $false
  }
  return $true
}