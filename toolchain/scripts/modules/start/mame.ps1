Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\mame.ps1"

function Start-Mame {
  $exeName = [System.IO.Path]::GetFileName($Config.project.emulator.mame.exeFile)
  $mamePath = Split-Path $Config.project.emulator.mame.exeFile

  # TODO : remove at v3
  if ($Rule -eq "only:run:mame" -or $Rule -eq "run:mame" -and -Not($Config.project.emulator.mame.profile)) {
    Mame `
    -ExeName $exeName `
    -GameName $buildConfig.projectName `
    -PathMame $mamePath `
    -XMLArgsFile "$($buildConfig.pathNeocore)\mame-args.xml"
  } else {
    if ($Rule -like "run:mame*") {
      Mame-WithProfile `
      -ExeName $exeName `
      -GameName $buildConfig.projectName `
      -PathMame $mamePath
    }
  }
}
