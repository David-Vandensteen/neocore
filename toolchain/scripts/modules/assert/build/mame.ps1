function Assert-BuildMame {
  Write-Host "Assert build mame" -ForegroundColor Cyan
  if (-Not(Test-Path -Path $cueFile)) {
    Write-Host "Error : $cueFile not found" -ForegroundColor Red
    exit 1
  }
}