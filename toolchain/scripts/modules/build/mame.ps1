Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\mame.ps1"

function Build-Mame {
  $mamePath = Split-Path $Config.project.emulator.mame.exeFile
  $name = $Config.project.name
  Write-Mame `
    -ProjectName $name `
    -PathMame $mamePath `
    -CUEFile "$($buildConfig.pathBuild)\$name.cue" `
    -OutputFile "$mamePath\roms\neocdz\$name.chd"
}
