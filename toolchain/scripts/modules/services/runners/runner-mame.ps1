function RunnerMame {
  $exeName = [System.IO.Path]::GetFileName($Config.project.emulator.mame.exeFile)
  $mamePath = Split-Path $Config.project.emulator.mame.exeFile

  Mame `
    -ExeName $exeName `
    -GameName $buildConfig.projectName `
    -PathMame $mamePath `
    -XMLArgsFile "$($buildConfig.pathNeocore)\mame-args.xml"
}
