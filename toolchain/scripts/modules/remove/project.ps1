function Remove-Project {
  Write-Host "clean $($buildConfig.pathBuild)" -ForegroundColor Yellow
  if (Test-Path -Path $buildConfig.pathBuild) {
    Get-ChildItem -Path $buildConfig.pathBuild -Recurse -ErrorAction SilentlyContinue | Remove-Item -force -Recurse -ErrorAction SilentlyContinue
  }
  if (Test-Path -Path $buildConfig.pathBuild) { Remove-Item $buildConfig.pathBuild -Force -ErrorAction SilentlyContinue }
}
