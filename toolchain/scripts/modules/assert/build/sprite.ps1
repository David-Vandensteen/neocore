function Assert-BuildSprite {
  if (-Not(Test-Path -Path $Config.project.buildPath)) {
    Write-Host "error : $($Config.project.buildPath) not found" -ForegroundColor Red
    exit 1
  }
}