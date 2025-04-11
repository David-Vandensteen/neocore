Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\build\sprite.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\sprite.ps1"

function Build-Sprite {
  Assert-BuildSprite

  $outputFile = "$($Config.project.buildPath)\$($Config.project.name)\$($Config.project.name)"
  $charDataFile = "$($Config.project.buildPath)\$($Config.project.name)\chardata.xml"

  Write-DATXML -InputFile $ConfigFile -OutputFile $charDataFile
  Write-Sprite -XMLFile $charDataFile -Format "cd" -OutputFile $outputFile
}
