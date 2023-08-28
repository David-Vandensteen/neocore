Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-install-component.ps1"

function Write-MameHash {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $CHDFile,
    [Parameter(Mandatory=$true)][String] $XMLFile
  )
  function Get-CHDSHA1 {
    param (
      [Parameter(Mandatory=$true)][String] $File
    )
    $r = (& chdman.exe info  -i $file) | Select-Object -Index 11
    $r = $r.Split(":")[1].trim()
    return $r
  }
  function Write-MameHashFile {
    param (
      [Parameter(Mandatory=$true)][String] $ProjectName,
      [Parameter(Mandatory=$true)][String] $XMLFile,
      [Parameter(Mandatory=$true)][String] $SHA1
    )
    if (Test-Path -Path $XMLFile) { Remove-Item -Path $XMLFile -Force }
    Set-Content -Path $XMLFile -Value '<?xml version="1.0"?>'
    Add-Content -Path $XMLFile -Value '<!-- THIS FILE IS GENERATED JUST IN TIME BY NEOCORE -->'
    Add-Content -Path $XMLFile -Value '<!DOCTYPE softwarelist SYSTEM "softwarelist.dtd">'
    Add-Content -Path $XMLFile -Value '<softwarelist name="neocd" description="SNK NeoGeo CD CD-ROMs">'
    Add-Content -Path $XMLFile -Value "<software name=`"$ProjectName`">"
    Add-Content -Path $XMLFile -Value "<description>$ProjectName</description>"
    Add-Content -Path $XMLFile -Value '<year>1995</year>'
    Add-Content -Path $XMLFile -Value "<publisher>$ProjectName</publisher>"
    Add-Content -Path $XMLFile -Value "<info name=`"alt_title`" value=`"$ProjectName`" />"
    Add-Content -Path $XMLFile -Value '<info name="serial" value="NGCD-583 (JPN)" />'
    Add-Content -Path $XMLFile -Value '<info name="release" value="59950502 (JPN)" />'
    Add-Content -Path $XMLFile -Value '<part name="cdrom" interface="neocd_cdrom">'
    Add-Content -Path $XMLFile -Value '<diskarea name="cdrom">'
    Add-Content -Path $XMLFile -Value "<disk name=`"$ProjectName`" sha1=`"$SHA1`"/>"
    Add-Content -Path $XMLFile -Value '</diskarea>'
    Add-Content -Path $XMLFile -Value '</part>'
    Add-Content -Path $XMLFile -Value '</software>'
    Add-Content -Path $XMLFile -Value '</softwarelist>'
  }

  $SHA1 = Get-CHDSHA1 -File $CHDFile
  Write-MameHashFile -ProjectName $ProjectName -XMLFile $XMLFile -SHA1 $SHA1
}

function Write-Mame {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $PathMame,
    [Parameter(Mandatory=$true)][String] $CUEFile,
    [Parameter(Mandatory=$true)][String] $OutputFile
  )
  if ((Test-Path -Path $PathMame) -eq $false) {
    Install-Component -URL "$($buildConfig.baseURL)/neocore-mame.zip" -PathDownload $buildConfig.pathSpool -PathInstall $buildConfig.pathNeocore
  }
  if ((Test-Path -Path $PathMame) -eq $false) { Write-Host "error - $PathMame not found" -ForegroundColor Red; exit 1 }
  if ((Test-Path -Path $CUEFile) -eq $false) { Write-Host "error - $CUEFile not found" -ForegroundColor Red; exit 1 }
  if ((Test-Path -Path "$PathMame\mame64.exe") -eq $false) { Write-Host "error - mame64.exe is not found in $PathMame" -ForegroundColor Red; exit 1 }

  Logger-Step -Message "compiling CHD"
  #& chdman.exe createcd -i $CUEFile -o $OutputFile --force
  Start-Process -NoNewWindow -FilePath "chdman.exe" -ArgumentList "createcd -i $CUEFile -o $OutputFile --force" -Wait
  if ((Test-Path -Path $OutputFile) -eq $false) {
    Logger-Error -Message "$OutputFile was not generated"
  } else {
    Logger-Success -Message "builded CHD is available to $OutputFile"
    Write-Host ""
  }
  Write-MameHash -ProjectName $ProjectName -CHDFile $OutputFile -XMLFile (Resolve-Path -Path "$PathMame\hash\neocd.xml")
}

function Mame {
  param (
    [Parameter(Mandatory=$true)][String] $ExeName,
    [Parameter(Mandatory=$true)][String] $GameName,
    [Parameter(Mandatory=$true)][String] $PathMame,
    [Parameter(Mandatory=$true)][String] $XMLArgsFile
  )
  Write-Host "DEBUG : pathMame $PathMame"
  $defaultMameArgs = "-rompath `"$PathMame\roms`" -hashpath `"$PathMame\hash`" -cfg_directory $env:TEMP -nvram_directory $env:TEMP -skip_gameinfo neocdz $GameName"

  $mameArgs = "-window"
  if (Test-Path -Path $XMLArgsFile) { $mameArgs = (Select-Xml -Path $XMLArgsFile -XPath '/mame/args').Node.InnerXML }

  if ((Test-Path -Path $PathMame) -eq $false) { Logger-Error -Message "$PathMame not found" }
  if ((Test-Path -Path "$PathMame\$ExeName") -eq $false) { Write-Host ("error - {0}\ not found" -f $PathMame) -ForegroundColor Red; exit 1 }
  Logger-Step -Message "launching mame $GameName"
  Write-Host "$PathMame\$ExeName $mameArgs $defaultMameArgs"
  Start-Process -NoNewWindow -FilePath "$PathMame\$ExeName" -ArgumentList "$mameArgs $defaultMameArgs"
}
