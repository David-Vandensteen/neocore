function Assert-BuildSprite {
  Write-Host "Assert build sprite" -ForegroundColor Yellow
  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  if (-Not(Test-Path -Path out)) {
    Write-Host "Error : out directory not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Test-Path -Path $projectBuildPath)) {
    Write-Host "Error : $projectBuildPath not found" -ForegroundColor Red
    return $false
  }

  Write-Host "Build sprite requirements validated" -ForegroundColor Green
  return $true
}