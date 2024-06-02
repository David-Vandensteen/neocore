function BuilderMame {
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\writers\mame.ps1"

  $mamePath = Split-Path $Config.project.emulator.mame.exeFile
  $name = $Config.project.name
  Write-Mame `
    -ProjectName $name `
    -PathMame $mamePath `
    -CUEFile "$($buildConfig.pathBuild)\$name.cue" `
    -OutputFile "$mamePath\roms\neocdz\$name.chd"
}
