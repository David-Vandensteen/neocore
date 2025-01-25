Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\iso.ps1"

function Build-ISO {
  Write-Cache `
    -PRGFile $buildConfig.PRGFile `
    -SpriteFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).cd" `
    -PathISOBuildFolder "$($buildConfig.pathBuild)\iso" `
    -PathCDTemplate "$($buildConfig.pathNeocore)\cd_template" `

  if ($config.project.sound.sfx.pcm) {
    Write-SFX `
    -PathISOBuildFolder "$($buildConfig.pathBuild)\iso" `
    -PCMFile "$($config.project.sound.sfx.pcm)"
  }

  if ($config.project.sound.sfx.z80) {
    Write-SFX `
      -PathISOBuildFolder "$($buildConfig.pathBuild)\iso" `
      -Z80File "$($config.project.sound.sfx.z80)"
  }

  Write-ISO `
    -PRGFile $buildConfig.PRGFile `
    -SpriteFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).cd" `
    -OutputFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).iso" `
    -PathISOBuildFolder "$($buildConfig.pathBuild)\iso" `
    -PathCDTemplate "$($buildConfig.pathNeocore)\cd_template" `

  $configCDDA = $null

  if ($Config.project.sound.cdda.tracks.track) { $configCDDA = $config.project.sound.cdda }

  Write-CUE `
    -Rule $buildConfig.rule `
    -OutputFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).cue" `
    -ISOName "$($buildConfig.projectName).iso" `
    -Config $configCDDA
}
