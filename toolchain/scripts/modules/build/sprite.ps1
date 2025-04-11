Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\sprite.ps1"

function Build-Sprite {
  $outputFile = "$($Config.project.buildPath)\$($Config.project.name)\$($Config.project.name)"
  $charDataFile = "$($Config.project.buildPath)\$($Config.project.name)\chardata.xml"

  Write-DATXML -InputFile $ConfigFile -OutputFile $charDataFile
  Write-Sprite -XMLFile $charDataFile -Format "cd" -OutputFile $outputFile
}
