function MakDefault {
  Write-Host "Mak default" -ForegroundColor Cyan
  $projectBuildPath = Resolve-TemplatePath -Path $Config.project.buildPath
  $projectName = $Config.project.name
  $file = "$projectBuildPath\$projectName\$projectName.cd"
  if (-not(Test-Path -Path $file)) {
    Write-Host "No $file found" -ForegroundColor Red
    Write-Host "Run 'mak sprite' to generate it" -ForegroundColor Yellow
    exit 1
  }
  Build-Program
}