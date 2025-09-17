function Build-Sprite {
  if (-Not(Test-Path -Path out)) {
    Write-Host "Creating out directory" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path out | Out-Null
  }

  if (-Not(Assert-BuildSprite)) {
    Write-Host "Sprite build assertion failed" -ForegroundColor Red
    return $false
  }

  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $outputFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name)"
  $fixDataFile = "$projectBuildPath\$($Config.project.name)\fixdata.xml"
  $charDataFile = "$projectBuildPath\$($Config.project.name)\chardata.xml"

  if (-not (Write-FixdataXML -InputFile $ConfigFile -OutputFile $fixDataFile)) {
    return $false
  }

  Write-Host "Checking fixdata files existence..." -ForegroundColor Yellow

  # Verify the function exists
  if (-not (Get-Command "Assert-ProjectGfxDatFixdataChardataFiles" -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Assert-ProjectGfxDatFixdataChardataFiles function not found!" -ForegroundColor Red
    Write-Host "This function should be imported from modules/assert/project/gfx/dat/fixdata/chardata/files.ps1" -ForegroundColor Yellow
    return $false
  }

  Write-Host "Function found, executing assertion..." -ForegroundColor Cyan
  if (-not (Assert-ProjectGfxDatFixdataChardataFiles -ProjectConfig $Config)) {
    Write-Host "Fix data files assertion failed" -ForegroundColor Red
    return $false
  }
  Write-Host "Fixdata files assertion completed successfully" -ForegroundColor Green

  if (-not (Write-Fix -XMLFile $fixDataFile)) {
    return $false
  }

  if (-not (Write-ChardataXML -InputFile $ConfigFile -OutputFile $charDataFile)) {
    return $false
  }
  if (-not (Write-Sprite -XMLFile $charDataFile -Format "cd" -OutputFile $outputFile)) {
    return $false
  }

  return $true
}
