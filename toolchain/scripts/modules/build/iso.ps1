function Build-ISO {
  $projectBuildPath = Resolve-TemplatePath -Path $Config.project.buildPath
  $prgFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).prg"
  $spriteFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).cd"
  $pathISOBuildFolder = "$projectBuildPath\$($Config.project.name)\iso"
  $pathCDTemplate = "$projectBuildPath\cd_template"
  $outputISOFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).iso"
  $outputCUEFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).cue"

  Write-Host "Build ISO" -ForegroundColor Cyan
  if (-Not(Assert-BuildISO)) {
    Write-Host "ISO build assertion failed" -ForegroundColor Red
    return $false
  }

  if (-not (Write-Cache `
    -PRGFile $prgFile `
    -SpriteFile $spriteFile `
    -PathISOBuildFolder $pathISOBuildFolder `
    -PathCDTemplate $pathCDTemplate)) {
    return $false
  }

  if ($config.project.sound.cd.sfx.pcm) {
    if (-not (Write-SFX `
    -PathISOBuildFolder $pathISOBuildFolder `
    -PCMFile "$($Config.project.sound.cd.sfx.pcm)")) {
      return $false
    }
  }

  if ($config.project.sound.cd.sfx.z80) {
    if (-not (Write-SFX `
      -PathISOBuildFolder $pathISOBuildFolder `
      -Z80File "$($Config.project.sound.cd.sfx.z80)")) {
      return $false
    }
  }

  if (-not (Write-ISO `
    -PRGFile $prgFile `
    -SpriteFile $spriteFile `
    -OutputFile $outputISOFile `
    -PathISOBuildFolder $pathISOBuildFolder `
    -PathCDTemplate $pathCDTemplate)) {
    return $false
  }

  # Always generate CUE file, with or without CDDA tracks
  $cddaConfig = $null
  if ($Config.project.sound.cd.cdda.tracks.track) {
    $cddaConfig = $Config.project.sound.cd.cdda
  }

  if (-not (Write-CUE `
    -Rule $Rule `
    -OutputFile $outputCUEFile `
    -ISOName "$($Config.project.name).iso" `
    -ConfigCDDA $cddaConfig)) {
    return $false
  }

  return $true
}
