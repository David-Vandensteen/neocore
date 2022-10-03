Param(
  [String] $neobuildData
)
[String] $neobuildTemp = "$env:TEMP\neocore"
[String] $toolsHost = "http://azertyvortex.free.fr/download"

function Install-CDTemplate {
  Write-Host "SetUp cd_template"
  Download -URL $toolsHost/neobuild-cd_template.zip -Path $neobuildTemp\neobuild-cd_template.zip
  Expand-Archive -Path $neobuildTemp\neobuild-cd_template.zip -DestinationPath $neobuildData
  Start-Sleep 5
}

function Install-Raine {
  Write-Host "SetUp Raine emulator"
  Download -URL $toolsHost/neobuild-raine.zip -Path $neobuildTemp\neobuild-raine.zip
  Expand-Archive -Path $neobuildTemp\neobuild-raine.zip -DestinationPath $neobuildData
  Start-Sleep 5
}

function Install-Mame {
  Write-Host "SetUp Mame emulator"
  Download -URL $toolsHost/neocore-mame.zip -Path $neobuildTemp\neocore-mame.zip
  Expand-Archive -Path $neobuildTemp\neocore-mame.zip -DestinationPath $neobuildData
  Start-Sleep 5
}

function Update-RaineConfig {
  Write-Host "Configure Raine"
  $content = [System.IO.File]::ReadAllText("$neobuildData\raine\config\raine32_sdl.cfg").Replace("/*neocd_bios*/","neocd_bios = $env:appdata\neocore\raine\roms\NEOCD.BIN")
  [System.IO.File]::WriteAllText("$neobuildData\raine\config\raine32_sdl.cfg", $content)
}

function Install-Bin {
  Write-Host "SetUp bin"
  Download -URL $toolsHost/neocore-bin.zip -Path $neobuildTemp\neocore-bin.zip
  Expand-Archive -Path $neobuildTemp\neocore-bin.zip -DestinationPath $neobuildData
  Start-Sleep 5
}

function Install-SDK {
  Write-Host "SetUp sdk"
  Download -URL $toolsHost/neodev-sdk.zip -Path $neobuildTemp\neodev-sdk.zip
  Expand-Archive -Path $neobuildTemp\neodev-sdk.zip -DestinationPath $neobuildData
  Start-Sleep 5
}

function Test-PsVersion {
  param (
    [Parameter(Mandatory=$true)][String] $MinVersion
  )
  if ($psversiontable.psversion.major -lt $MinVersion) {
    Write-Host "Error ... update WMF"
    break 0
  }
}

function Download {
  param (
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $Path
  )
  Write-Host "Download - $URL $Path"
  Import-Module BitsTransfer

  $start_time = Get-Date
  Start-BitsTransfer -Source $URL -Destination $Path
  Write-Output "Time taken - $((Get-Date).Subtract($start_time).Seconds) second(s)"
}

function Main {
  Test-PsVersion -MinVersion 5
  if (Test-Path -Path $neobuildData) { Remove-Item -Force -Recurse $neobuildData }
  if (Test-Path -Path $neobuildTemp) { Remove-Item -Force -Recurse $neobuildTemp }
  New-Item -ItemType Directory -Force -Path $neobuildData
  New-Item -ItemType Directory -Force -Path $neobuildTemp
  Install-SDK
  Install-CDTemplate
  Install-Raine
  Update-RaineConfig
  #Install-Mame
  Install-Bin
}

Main
