function MakDefault {
  Write-Host "Mak default" -ForegroundColor Cyan
  $projectBuildPath = Resolve-TemplatePath -Path $Config.project.buildPath
  $projectName = $Config.project.name
  $file = "$projectBuildPath\$projectName\$projectName.cd"
  if (-not(Test-Path -Path $file)) {
    Write-Host "No $file found" -ForegroundColor Red
    Write-Host "Run 'mak sprite' to generate it" -ForegroundColor Yellow
    return $false
  }
  if (-Not(Build-Program)) {
    Write-Host "Build-Program failed" -ForegroundColor Red
    return $false
  }

  Write-Host "Default build completed successfully" -ForegroundColor Green
  return $true
}