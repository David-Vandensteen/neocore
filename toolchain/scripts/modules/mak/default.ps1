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

  Write-Host "Calling Build-Program..." -ForegroundColor Cyan
  $buildOutput = Build-Program
  $buildResult = $buildOutput[-1]  # The last line is the return value
  Write-Host "Build-Program returned: $buildResult" -ForegroundColor Cyan
  if (-Not($buildResult)) {
    Write-Host "Build-Program failed" -ForegroundColor Red
    return $false
  }

  Write-Host "Default build completed successfully" -ForegroundColor Green
  return $true
}