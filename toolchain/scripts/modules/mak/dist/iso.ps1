function MakDistISO {
  $ISOFile = "$($Config.project.buildPath)\$($Config.project.name)\$($Config.project.name).iso"
  $CUEFile = "$($Config.project.buildPath)\$($Config.project.name)\$($Config.project.name).cue"
  $pathDestination = "$($Config.project.distPath)\$($Config.project.name)\$($Config.project.name)-$($Config.project.version)"
  if ((Test-Path -Path $Config.project.distPath) -eq $false) { New-Item -Path $Config.project.distPath -ItemType Directory -Force }
  Build-Sprite
  Build-Program
  Build-ISO
  Write-Dist `
    -ProjectName $Config.project.name `
    -PathDestination $pathDestination `
    -ISOFile $ISOFile `
    -CUEFile $CUEFile
}