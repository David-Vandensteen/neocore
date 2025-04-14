function MakDistMame {
  $pathDestination = "$($Config.project.distPath)\$($Config.project.name)\$($Config.project.name)-$($Config.project.version)"
  $CHDFile = "$($Config.project.buildPath)\mame\roms\neocdz\$($Config.project.name).chd"
  $hashFile = "$($Config.project.buildPath)\mame\hash\neocd.xml"
  if ((Test-Path -Path $Config.project.distPath) -eq $false) { New-Item -Path $Config.project.distPath -ItemType Directory -Force }
  Build-Sprite
  Build-Program
  Build-ISO
  Build-Mame
  Write-Dist `
    -ProjectName $Config.project.name `
    -PathDestination $pathDestination `
    -CHDFile  $CHDFile `
    -HashFile $hashFile
}