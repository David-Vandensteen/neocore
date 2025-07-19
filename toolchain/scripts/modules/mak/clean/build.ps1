function MakCleanBuild {
  if (-Not(Test-Path -Path $Config.project.buildPath)) {
    Write-Host "Build folder $($Config.project.buildPath) not found" -ForegroundColor Yellow
    exit 1
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