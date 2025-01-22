Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\install\component.ps1"

function Install-RaineConfig {
  param (
    [Parameter(Mandatory=$true)][String] $Path
  )
  Write-Host "Configure Raine"
  $pathAbs = (Resolve-Path -Path $Path).Path
  $content = [System.IO.File]::ReadAllText("$Path\config\raine32_sdl.cfg").Replace("/*neocd_bios*/","neocd_bios = $pathAbs\roms\NEOCD.BIN")
  [System.IO.File]::WriteAllText("$Path\config\raine32_sdl.cfg", $content)
}

function Invoke-Raine {
  param (
    [Parameter(Mandatory=$true)][String] $FileName,
    [Parameter(Mandatory=$true)][String] $PathISO,
    [Parameter(Mandatory=$true)][String] $PathRaine,
    [Parameter(Mandatory=$true)][String] $ExeName
  )
  if ((Test-Path -Path "$PathISO\$FileName") -eq $false) { Logger-Error -Message "$FileName not found" }
  if ((Test-Path -Path $PathRaine) -eq $false) {
    Install-Component -URL "$($buildConfig.baseURL)/neobuild-raine.zip" -PathDownload $buildConfig.pathSpool -PathInstall $buildConfig.pathNeocore
    Install-RaineConfig -Path $PathRaine
  }
  Logger-Step -Message "launching raine $FileName"
  $pathRaineAbs = (Resolve-Path -Path $PathRaine).Path
  Push-Location -Path $PathISO
  & "$pathRaineAbs\$ExeName" $FileName
  Pop-Location
}

function Start-Raine {
  $exeName = [System.IO.Path]::GetFileName($Config.project.emulator.raine.exeFile)
  $rainePath = Split-Path $Config.project.emulator.raine.exeFile

  Invoke-Raine `
    -FileName "$($buildConfig.projectName).cue" `
    -PathRaine $rainePath `
    -PathISO $buildConfig.pathBuild `
    -ExeName $exeName
}
