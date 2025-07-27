function MakDistISO {
  Write-Host "Mak dist iso" -ForegroundColor Cyan
  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $projectDistPath = Get-TemplatePath -Path $Config.project.distPath
  $ISOFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).iso"
  $CUEFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).cue"
  $pathDestination = "$projectDistPath\$($Config.project.name)\$($Config.project.name)-$($Config.project.version)"
  $projectDistPath = Get-TemplatePath -Path $Config.project.distPath
  if ((Test-Path -Path $projectDistPath) -eq $false) { New-Item -Path $projectDistPath -ItemType Directory -Force }

  if (-Not(Build-ISO)) {
    Write-Host "ISO build failed" -ForegroundColor Red
    return $false
  }

  if (-Not(Write-Dist `
    -ProjectName $Config.project.name `
    -PathDestination $pathDestination `
    -ISOFile $ISOFile `
    -CUEFile $CUEFile)) {
    Write-Host "ISO distribution failed" -ForegroundColor Red
    return $false
  }

  return $true
}