Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\build\iso.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\iso.ps1"

function Build-ISO {
  $prgFile = "$($Config.project.buildPath)\$($Config.project.name)\$($Config.project.name).prg"
  $spriteFile = "$($Config.project.buildPath)\$($Config.project.name)\$($Config.project.name).cd"
  $pathISOBuildFolder = "$($Config.project.buildPath)\$($Config.project.name)\iso"
  $pathCDTemplate = "$($Config.project.buildPath)\cd_template"
  $outputISOFile = "$($Config.project.buildPath)\$($Config.project.name)\$($Config.project.name).iso"
  $outputCUEFile = "$($Config.project.buildPath)\$($Config.project.name)\$($Config.project.name).cue"

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
