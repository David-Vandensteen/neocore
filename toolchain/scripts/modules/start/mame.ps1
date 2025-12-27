function Start-Mame {
  # Support both <path>/<exe> and <exeFile> in <mame>
  if ($Config.project.emulator.mame.path -and $Config.project.emulator.mame.exe) {
    $mamePath = Get-TemplatePath -Path $Config.project.emulator.mame.path
    $exeName = $Config.project.emulator.mame.exe
  } elseif ($Config.project.emulator.mame.exeFile) {
    $mamePath = Split-Path (Get-TemplatePath -Path $Config.project.emulator.mame.exeFile)
    $exeName = [System.IO.Path]::GetFileName($Config.project.emulator.mame.exeFile)
  } else {
    throw "No valid MAME emulator path/exe or exeFile found in project.xml"
  }

  if ($Rule -eq "serve:mame") {
    Mame `
      -ExeName $exeName `
      -GameName $Config.project.name `
      -PathMame $mamePath `
      -XMLArgsFile "$($Config.project.buildPath)\mame-args.xml"
    return $true
  }

  if ($Rule -eq "only:run:mame" -or ($Rule -eq "run:mame" -and -Not($Config.project.emulator.mame.profile))) {
    Mame `
      -ExeName $exeName `
      -GameName $Config.project.name `
      -PathMame $mamePath `
      -XMLArgsFile "$($Config.project.buildPath)\mame-args.xml"
    return $true
  }

  if ($Rule -like "run:mame*") {
    Mame-WithProfile `
      -ExeName $exeName `
      -GameName $Config.project.name `
      -PathMame $mamePath
    return $true
  }

  # Default case - MAME launched successfully but rule not recognized
  return $true
}
