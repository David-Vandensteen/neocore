function Build-Mame {
  $mamePath = Split-Path $Config.project.emulator.mame.exeFile
  $mamePath = Get-TemplatePath -Path $mamePath
  $name = $Config.project.name
  $cueFile = "$($Config.project.buildPath)\$name\$name.cue"

  Assert-BuildMame

  Write-Mame `
    -ProjectName $name `
    -PathMame $mamePath `
    -CUEFile $cueFile `
    -OutputFile "$mamePath\roms\neocdz\$name.chd"
}
