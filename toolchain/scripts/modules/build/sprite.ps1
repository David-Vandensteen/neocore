function Build-Sprite {
  if (-Not(Test-Path -Path out)) {
    Write-Host "Creating out directory" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path out | Out-Null
  }

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
