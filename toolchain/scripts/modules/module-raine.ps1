Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-install-component.ps1"

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
  if ((Test-Path -Path $File) -eq $false) { Logger-Error -Message "$File not found" }
  if ((Test-Path -Path $PathRaine) -eq $false) {
    Install-Component -URL "$BASE_URL/neobuild-raine.zip" -PathDownload $PATH_SPOOL -PathInstall $PATH_NEOCORE
    Update-Raine -Path $PathRaine
  }
  Logger-Step -Message "lauching raine $File"
  & "$PathRaine\raine32.exe" $File
}