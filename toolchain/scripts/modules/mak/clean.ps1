# TODO : remove out
function MakClean {
  $buildPathProject = "$($Config.project.buildPath)\$($Config.project.name)"
  Write-Host "cleaning $buildPathProject" -ForegroundColor Yellow

  if (Test-Path -Path $buildPathProject) {
    Write-Host "Removing files in $buildPathProject" -ForegroundColor Yellow
    try {
      Get-ChildItem -Path $buildPathProject -Recurse -ErrorAction Stop | Remove-Item -Force -Recurse -ErrorAction Stop
    } catch {
      Write-Host "Failed to remove items: $_" -ForegroundColor Red
    }
  }
}
