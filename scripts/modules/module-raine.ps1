Import-Module "..\..\scripts\modules\module-download.ps1"

function Install-Raine {
  param (
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $PathDonwload,
    [Parameter(Mandatory=$true)][String] $PathInstall
  )
  Download -URL $URL -Path $PathDonwload
  Expand-Archive -Path "$PathDonwload\neobuild-raine.zip" -DestinationPath $PathInstall
  Remove-Item -Path "$PathDonwload\neobuild-raine.zip" -Force

  Write-Host "Configure Raine"
  $content = [System.IO.File]::ReadAllText("$PathInstall\raine\config\raine32_sdl.cfg").Replace("/*neocd_bios*/","neocd_bios = $PathInstall\raine\roms\NEOCD.BIN")
  [System.IO.File]::WriteAllText("$PathInstall\raine\config\raine32_sdl.cfg", $content)
}

function Raine {
  param (
    [Parameter(Mandatory=$true)][String] $File,
    [Parameter(Mandatory=$true)][String] $PathRaine
  )
  if ((Test-Path -Path $File) -eq $false) {
    Write-Host "error - $File not found" -ForegroundColor Red
  }
  if ((Test-Path -Path $PathRaine) -eq $false) {
    Install-Raine -URL "http://azertyvortex.free.fr/download/neobuild-raine.zip" -PathDonwload "$env:TEMP\neocore" -PathInstall "$env:APPDATA\neocore"
  }
  Write-Host "lauching raine $File" -ForegroundColor Yellow
  & "$PathRaine\raine32.exe" $File
}