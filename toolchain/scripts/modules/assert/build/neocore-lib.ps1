function Assert-BuildNeocoreLib {
  if (-Not(Test-Path -Path $buildPath)) {
    Write-Host "error : $buildPath not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Test-Path -Path $srcLibPath)) {
    Write-Host "error : $srcLibPath not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Test-Path -Path "$($buildPath)\gcc\gcc-2.95.2")) {
    Write-Host "error : $($buildPath)\gcc\gcc-2.95.2 not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Test-Path -Path "$($buildPath)\lib")) {
    Write-Host "error : $($buildPath)\lib not found" -ForegroundColor Red
    return $false
  }
  return $true
}