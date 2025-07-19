function MakDistISO {
  Write-Host "Mak dist iso" -ForegroundColor Cyan
  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $projectDistPath = Get-TemplatePath -Path $Config.project.distPath
  $ISOFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).iso"
  $CUEFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).cue"
  $pathDestination = "$projectDistPath\$($Config.project.name)\$($Config.project.name)-$($Config.project.version)"
  if ((Test-Path -Path $Config.project.distPath) -eq $false) { New-Item -Path $Config.project.distPath -ItemType Directory -Force }
  Build-ISO
  Write-Dist `
    -ProjectName $Config.project.name `
    -PathDestination $pathDestination `
    -ISOFile $ISOFile `
    -CUEFile $CUEFile
}