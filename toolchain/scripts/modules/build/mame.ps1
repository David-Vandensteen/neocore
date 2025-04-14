Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\build\mame.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\mame.ps1"

function Build-Mame {
  $mamePath = Split-Path $Config.project.emulator.mame.exeFile
  $name = $Config.project.name
  $cueFile = "$($Config.project.buildPath)\$name\$name.cue"

  Assert-BuildMame

  Write-Mame `
    -ProjectName $name `
    -PathMame $mamePath `
    -CUEFile $cueFile `
    -OutputFile "$mamePath\roms\neocdz\$name.chd"
}
