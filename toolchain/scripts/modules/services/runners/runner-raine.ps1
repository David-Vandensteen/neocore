Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-raine.ps1"

function RunnerRaine {
  $exeName = [System.IO.Path]::GetFileName($Config.project.emulator.raine.exeFile)

  $rainePath = Split-Path $Config.project.emulator.raine.exeFile

  Raine `
    -FileName "$($buildConfig.projectName).cue" `
    -PathRaine $rainePath `
    -PathISO $buildConfig.pathBuild `
    -ExeName $exeName
}
