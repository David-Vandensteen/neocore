function Assert-BuildProgram {
  Write-Host "Assert build program" -ForegroundColor Yellow
  $projectBuildPath = Resolve-TemplatePath -Path $Config.project.buildPath

  if (-Not(Test-Path -Path $projectBuildPath)) {
    Write-Host "Error : $projectBuildPath not found" -ForegroundColor Red
    return $false
  }
  Write-Host "Build program requirements validated" -ForegroundColor Green
  return $true
}