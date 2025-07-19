function Build-Sprite {
  if (-Not(Test-Path -Path out)) {
    Write-Host "Creating out directory" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path out | Out-Null
  }

  Assert-BuildSprite

  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $outputFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name)"
  $fixDataFile = "$projectBuildPath\$($Config.project.name)\fixdata.xml"
  $charDataFile = "$projectBuildPath\$($Config.project.name)\chardata.xml"

  Write-FixdataXML -InputFile $ConfigFile -OutputFile $fixDataFile
  Write-Fix -XMLFile $fixDataFile

  Write-ChardataXML -InputFile $ConfigFile -OutputFile $charDataFile
  Write-Sprite -XMLFile $charDataFile -Format "cd" -OutputFile $outputFile
}
