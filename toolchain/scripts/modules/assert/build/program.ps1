function Assert-BuildProgram {
  Write-Host "Assert build program" -ForegroundColor Yellow
  $projectBuildPath = Resolve-TemplatePath -Path $Config.project.buildPath

  if (-Not(Test-Path -Path $projectBuildPath)) {
    Write-Host "Error : $projectBuildPath not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path "$projectBuildPath\neodev-sdk")) {
    Write-Host "Error : $projectBuildPath\neodev-sdk not found" -ForegroundColor Red
    exit 1
  }
}