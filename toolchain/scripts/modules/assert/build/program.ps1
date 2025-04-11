function Assert-BuildProgram {
  if (-Not(Test-Path -Path $Config.project.buildPath)) {
    Write-Host "error : $($Config.project.buildPath) not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path "$($Config.project.buildPath)\neodev-sdk")) {
    Write-Host "error : $($Config.project.buildPath)\neodev-sdk not found" -ForegroundColor Red
    exit 1
  }
}