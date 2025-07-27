function Assert-BuildEXE {
  if (-Not(Test-Path -Path $mamePath)) {
    Write-Host "error : $mamePath not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Test-Path -Path $NSIFile)) {
    Write-Host "error : $NSIFile not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Test-Path -Path $makeNSISexe)) {
    Write-Host "error : $makeNSISexe not found" -ForegroundColor Red
    return $false
  }
  return $true
}
