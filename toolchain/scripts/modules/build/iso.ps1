function Build-ISO {
  $projectBuildPath = Resolve-TemplatePath -Path $Config.project.buildPath
  $prgFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).prg"
  $spriteFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).cd"
  $pathISOBuildFolder = "$projectBuildPath\$($Config.project.name)\iso"
  $pathCDTemplate = "$projectBuildPath\cd_template"
  $outputISOFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).iso"
  $outputCUEFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).cue"

  Write-Host "Build ISO" -ForegroundColor Cyan
  Assert-BuildISO

  Write-Cache `
    -PRGFile $prgFile `
    -SpriteFile $spriteFile `
    -PathISOBuildFolder $pathISOBuildFolder `
    -PathCDTemplate $pathCDTemplate

  if ($config.project.sound.sfx.pcm) {
    Write-SFX `
    -PathISOBuildFolder $pathISOBuildFolder `
    -PCMFile "$($Config.project.sound.sfx.pcm)"
  }

  if ($config.project.sound.sfx.z80) {
    Write-SFX `
      -PathISOBuildFolder $pathISOBuildFolder `
      -Z80File "$($Config.project.sound.sfx.z80)"
  }

  Write-ISO `
    -PRGFile $prgFile `
    -SpriteFile $spriteFile `
    -OutputFile $outputISOFile `
    -PathISOBuildFolder $pathISOBuildFolder `
    -PathCDTemplate $pathCDTemplate

  $configCDDA = $null

  if ($Config.project.sound.cdda.tracks.track) { $configCDDA = $Config.project.sound.cdda }

  Write-CUE `
    -Rule $Rule `
    -OutputFile $outputCUEFile `
    -ISOName "$($Config.project.name).iso" `
    -Config $configCDDA
}
