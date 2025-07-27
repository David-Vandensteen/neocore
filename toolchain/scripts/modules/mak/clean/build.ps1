function MakCleanBuild {
  $projectBuildPath = Resolve-TemplatePath -Path $Config.project.buildPath
  if (-Not(Test-Path -Path $projectBuildPath)) {
    Write-Host "Build folder $projectBuildPath not found" -ForegroundColor Red
    return $false
  }
  $buildPath = Resolve-TemplatePath -Path $Config.project.buildPath
  $confirmation = Read-Host "Are you sure you want to remove the build folder $buildPath ? (y/n)"
  if ($confirmation -eq "y") {
    Write-Host "Removing build folder $buildPath" -ForegroundColor Yellow
    if ((Test-Path -Path $buildPath) -eq $true) { Remove-Item -Path $buildPath -Recurse -Force }
  } else {
    Write-Host "Build folder not removed" -ForegroundColor Yellow
  }
  exit 0
}