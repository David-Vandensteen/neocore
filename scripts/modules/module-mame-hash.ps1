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


# TODO : cleaning this dead code when debug is complete
<#
Param(
  [String] $programName,
  [String] $programPath,
  [String] $xmlfile
)
$chdman = "$env:APPDATA\neocore\bin\chdman.exe"

function getSHA1([String] $file) {
  $r = (& $chdman info  -i $file) | Select-Object -Index 11
  $r = $r.Split(":")[1].trim()
  return $r
}

function writeFile([String] $file, [String] $programName, [String] $sha1) {
  Set-Content -Path $file -Value '<?xml version="1.0"?>'
  Add-Content -Path $file -Value '<!-- THIS FILE IS GENERATED JUST IN TIME BY NEOCORE -->'
  Add-Content -Path $file -Value '<!DOCTYPE softwarelist SYSTEM "softwarelist.dtd">'
  Add-Content -Path $file -Value '<softwarelist name="neocd" description="SNK NeoGeo CD CD-ROMs">'
  Add-Content -Path $file -Value "<software name=`"$programName`">"
  Add-Content -Path $file -Value "<description>$programName</description>"
  Add-Content -Path $file -Value '<year>1995</year>'
  Add-Content -Path $file -Value "<publisher>$programName</publisher>"
  Add-Content -Path $file -Value "<info name=`"alt_title`" value=`"$programName`" />"
  Add-Content -Path $file -Value '<info name="serial" value="NGCD-583 (JPN)" />'
  Add-Content -Path $file -Value '<info name="release" value="59950502 (JPN)" />'
  Add-Content -Path $file -Value '<part name="cdrom" interface="neocd_cdrom">'
  Add-Content -Path $file -Value '<diskarea name="cdrom">'
  Add-Content -Path $file -Value "<disk name=`"$programName`" sha1=`"$sha1`"/>"
  Add-Content -Path $file -Value '</diskarea>'
  Add-Content -Path $file -Value '</part>'
  Add-Content -Path $file -Value '</software>'
  Add-Content -Path $file -Value '</softwarelist>'
}

function _main {
  $sha1 = getSHA1($programPath)
  writeFile $xmlfile $programName $sha1
}

_main
#>