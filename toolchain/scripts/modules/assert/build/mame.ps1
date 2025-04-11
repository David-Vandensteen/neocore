function Assert-BuildMame {
  if (-Not(Test-Path -Path $mamePath)) {
    Write-Host "error : $mamePath not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $cueFile)) {
    Write-Host "error : $cueFile not found" -ForegroundColor Red
    exit 1
  }
}