function Build-Mame {
  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $mamePath = Split-Path $Config.project.emulator.mame.exeFile
  $mamePath = Get-TemplatePath -Path $mamePath
  $name = $Config.project.name
  $cueFile = "$projectBuildPath\$name\$name.cue"

  Write-Host "Build mame" -ForegroundColor Cyan
  Assert-BuildMame

  Write-Mame `
    -ProjectName $name `
    -PathMame $mamePath `
    -CUEFile $cueFile `
    -OutputFile "$mamePath\roms\neocdz\$name.chd"
}
