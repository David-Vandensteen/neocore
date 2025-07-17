function Build-Sprite {
  Assert-BuildSprite

  $outputFile = "$($Config.project.buildPath)\$($Config.project.name)\$($Config.project.name)"
  $fixDataFile = "$($Config.project.buildPath)\$($Config.project.name)\fixdata.xml"
  $charDataFile = "$($Config.project.buildPath)\$($Config.project.name)\chardata.xml"

  if ($Config.project.gfx.DAT.fixdata) {
    Write-FixdataXML -InputFile $ConfigFile -OutputFile $fixDataFile
    Write-Fix -XMLFile $fixDataFile
  }

  Write-ChardataXML -InputFile $ConfigFile -OutputFile $charDataFile
  Write-Sprite -XMLFile $charDataFile -Format "cd" -OutputFile $outputFile
}
