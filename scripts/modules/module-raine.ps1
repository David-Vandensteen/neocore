Import-Module "..\..\scripts\modules\module-install-component.ps1"

function Update-Raine {
  param (
    [Parameter(Mandatory=$true)][String] $Path
  )
  Write-Host "Configure Raine"
  $content = [System.IO.File]::ReadAllText("$Path\config\raine32_sdl.cfg").Replace("/*neocd_bios*/","neocd_bios = $Path\roms\NEOCD.BIN")
  [System.IO.File]::WriteAllText("$Path\config\raine32_sdl.cfg", $content)
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
    Install-Component -URL "http://azertyvortex.free.fr/download/neobuild-raine.zip" -PathDownload "$env:TEMP\neocore" -PathInstall "$env:APPDATA\neocore"
    Update-Raine -Path $PathRaine
  }
  Write-Host "lauching raine $File" -ForegroundColor Yellow
  & "$PathRaine\raine32.exe" $File
}