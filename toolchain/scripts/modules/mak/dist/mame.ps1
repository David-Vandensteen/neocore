function MakDistMame {
  Write-Host "Mak Dist Mame" -ForegroundColor Cyan
  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $projectDistPath = Get-TemplatePath -Path $Config.project.distPath
  $pathDestination = "$projectDistPath\$($Config.project.name)\$($Config.project.name)-$($Config.project.version)"
  $CHDFile = "$projectBuildPath\mame\roms\neocdz\$($Config.project.name).chd"
  $hashFile = "$projectBuildPath\mame\hash\neocd.xml"
  if ((Test-Path -Path $projectBuildPath) -eq $false) { New-Item -Path $projectBuildPath -ItemType Directory -Force }

  if (-Not(Build-ISO)) {
    Write-Host "ISO build failed" -ForegroundColor Red
    return $false
  }

  if (-Not(Build-Mame)) {
    Write-Host "MAME build failed" -ForegroundColor Red
    return $false
  }

  if (-Not(Write-Dist `
    -ProjectName $Config.project.name `
    -PathDestination $pathDestination `
    -CHDFile  $CHDFile `
    -HashFile $hashFile)) {
    Write-Host "MAME distribution failed" -ForegroundColor Red
    return $false
  }

  return $true
}