function Build-Mame {
  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  if ($Config.project.emulator.mame.exeFile) {
    $mamePath = Split-Path (Get-TemplatePath -Path $Config.project.emulator.mame.exeFile)
    $exeName = [System.IO.Path]::GetFileName($Config.project.emulator.mame.exeFile)
  } else {
    throw "No valid MAME emulator exeFile found in project.xml"
  }
  $name = $Config.project.name
  $cueFile = "$projectBuildPath\$name\$name.cue"

  Write-Host "Build mame" -ForegroundColor Cyan
  if (-Not(Assert-BuildMame)) {
    Write-Host "MAME build assertion failed" -ForegroundColor Red
    return $false
  }

  if (-not (Write-Mame `
    -ProjectName $name `
    -PathMame $mamePath `
    -CUEFile $cueFile `
    -OutputFile (Join-Path $mamePath "roms\neocdz\$name.chd"))) {
    Write-Host "MAME build failed" -ForegroundColor Red
    return $false
  }
  
  return $true
}
