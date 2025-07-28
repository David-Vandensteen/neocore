function MakClean {
  $projectBuildPath = Resolve-TemplatePath -Path $Config.project.buildPath
  $buildPathProject = "$projectBuildPath\$($Config.project.name)"
  Write-Host "cleaning $buildPathProject" -ForegroundColor Yellow

  $success = $true

  if (Test-Path -Path $buildPathProject) {
    Write-Host "Removing files in $buildPathProject" -ForegroundColor Yellow
    try {
      Get-ChildItem -Path $buildPathProject -Recurse -ErrorAction Stop | Remove-Item -Force -Recurse -ErrorAction Stop
    } catch {
      Write-Host "Failed to remove items: $_" -ForegroundColor Red
      $success = $false
    }
  }

  $outPath = "out"
  if (Test-Path -Path $outPath) {
    Write-Host "Removing files in $outPath" -ForegroundColor Yellow
    try {
      Get-ChildItem -Path $outPath -Recurse -ErrorAction Stop | Remove-Item -Force -Recurse -ErrorAction Stop
    } catch {
      Write-Host "Failed to remove items from out directory: $_" -ForegroundColor Red
      $success = $false
    }
  }

  return $success
}
