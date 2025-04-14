Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\mame.ps1"

function Start-Mame {
  $exeName = [System.IO.Path]::GetFileName($Config.project.emulator.mame.exeFile)
  $mamePath = Split-Path $Config.project.emulator.mame.exeFile

  # TODO : remove at v3

  if ($Rule -eq "serve:mame") {
    Mame `
      -ExeName $exeName `
      -GameName $Config.project.name `
      -PathMame $mamePath `
      -XMLArgsFile "$($Config.project.buildPath)\mame-args.xml"
  }

  if ($Rule -eq "only:run:mame" -or $Rule -eq "run:mame" -and -Not($Config.project.emulator.mame.profile)) {
    Mame `
    -ExeName $exeName `
    -GameName $Config.project.name `
    -PathMame $mamePath `
    -XMLArgsFile "$($Config.project.buildPath)\mame-args.xml"
  } else {
    if ($Rule -like "run:mame*") {
      Mame-WithProfile `
      -ExeName $exeName `
      -GameName $Config.project.name `
      -PathMame $mamePath
    }
  }
}
