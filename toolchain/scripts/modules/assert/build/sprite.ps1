function Assert-BuildSprite {
  if (-Not(Test-Path -Path out)) {
    Write-Host "Error : out directory not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $Config.project.buildPath)) {
    Write-Host "Error : $($Config.project.buildPath) not found" -ForegroundColor Red
    exit 1
  }
}