function Remove-Project {
  Write-Host "cleaning $($buildConfig.pathBuild)" -ForegroundColor Yellow

  if (Test-Path -Path $buildConfig.pathBuild) {
    try {
      Get-ChildItem -Path $buildConfig.pathBuild -Recurse -ErrorAction Stop | Remove-Item -Force -Recurse -ErrorAction Stop
    } catch {
      Write-Host "Failed to remove items: $_" -ForegroundColor Red
    }
  }
}
