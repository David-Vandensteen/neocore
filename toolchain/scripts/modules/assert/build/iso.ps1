function Assert-BuildISO {
  if (-Not(Test-Path -Path $prgFile)) {
    Write-Host "error : $prgFile not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -path $spriteFile)) {
    Write-Host "error : $spriteFile not found" -ForegroundColor Red
    exit 1
  }
}