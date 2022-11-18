Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-install-component.ps1"

function Update-Raine {
  param (
    [Parameter(Mandatory=$true)][String] $Path
  )
  Write-Host "Configure Raine"
  $pathAbs = (Resolve-Path -Path $Path).Path
  $content = [System.IO.File]::ReadAllText("$Path\config\raine32_sdl.cfg").Replace("/*neocd_bios*/","neocd_bios = $pathAbs\roms\NEOCD.BIN")
  [System.IO.File]::WriteAllText("$Path\config\raine32_sdl.cfg", $content)
}

function Raine {
  param (
    [Parameter(Mandatory=$true)][String] $FileName,
    [Parameter(Mandatory=$true)][String] $PathISO,
    [Parameter(Mandatory=$true)][String] $PathRaine
  )
  if ((Test-Path -Path "$PathISO\$FileName") -eq $false) { Logger-Error -Message "$FileName not found" }
  if ((Test-Path -Path $PathRaine) -eq $false) {
    Install-Component -URL "$($buildConfig.baseURL)/neobuild-raine.zip" -PathDownload $buildConfig.pathSpool -PathInstall $buildConfig.pathNeocore
    Update-Raine -Path $PathRaine
  }
  Logger-Step -Message "launching raine $FileName"
  $pathRaineAbs = (Resolve-Path -Path $PathRaine).Path
  Push-Location -Path $PathISO
  & "$pathRaineAbs\raine32.exe" $FileName
  Pop-Location
}