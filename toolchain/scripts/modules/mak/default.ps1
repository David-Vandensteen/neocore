function MakDefault {
  Write-Host "Mak default" -ForegroundColor Cyan
  if (-not(Test-Path -Path "out\char.bin")) {
    Write-Host "No out\char.bin found" -ForegroundColor Red
    Write-Host "Run 'mak sprite' to generate it" -ForegroundColor Yellow
    exit 1
  }
  Build-Program
}