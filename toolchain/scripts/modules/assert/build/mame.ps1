function Assert-BuildMame {
  if (-Not(Test-Path -Path $cueFile)) {
    Write-Host "error : $cueFile not found" -ForegroundColor Red
    exit 1
  }
}