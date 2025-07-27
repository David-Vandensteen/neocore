function Start-Mame {
  $exeName = [System.IO.Path]::GetFileName($Config.project.emulator.mame.exeFile)
  $mamePath = Split-Path $Config.project.emulator.mame.exeFile
  $mamePath = Get-TemplatePath -Path $mamePath

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
