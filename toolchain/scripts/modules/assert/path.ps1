function Assert-Path {
  if ((Test-Path -Path $Config.project.makefile) -eq $false) {
    Write-Host "error : $($Config.project.makefile) not found" -ForegroundColor Red
    return $false
  }
  if ((Test-Path -Path $Config.project.neocorePath) -eq $false) {
    Write-Host "error : $($Config.project.neocorePath) not found" -ForegroundColor Red
    return $false
  }

  Write-Host "path is compliant" -ForegroundColor Green
  return $true
}
