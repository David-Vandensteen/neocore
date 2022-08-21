param (
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $Rule
)

Import-Module "..\..\scripts\module-mak.ps1"

function Main {
  param (
      [Parameter(Mandatory=$true)][String] $ProjectName,
      [Parameter(Mandatory=$true)][String] $Rule
  )
  Set-EnvPath -PathNeoDevBin "$env:appdata\neocore\neodev-sdk\m68k\bin" -PathNeocoreBin "$env:appdata\neocore\bin"
  if ($Rule -eq "clean") { Make-Clean -ProjectName $ProjectName }
  if ($Rule -eq "sprite") { Make-Sprite -HashPath "$env:temp\neocore\$ProjectName" -XMLFile "chardata.xml" }
  if (($Rule -eq "make") -or ($Rule -eq "") ) { 
    Make-Sprite -HashPath "$env:temp\neocore\$ProjectName" -XMLFile "chardata.xml"
    Make-Program -ProjectName $ProjectName -PathBuild "$env:temp\neocore\$ProjectName" -PathNeoDev "$env:temp\neocore\neodev-sdk"
  } 
  if ($Rule -eq "cue") {
    Make-Sprite -HashPath "$env:temp\neocore\$ProjectName" -XMLFile "chardata.xml"
    Make-Program -ProjectName $ProjectName -PathBuild "$env:temp\neocore\$ProjectName" -PathNeoDev "$env:temp\neocore\neodev-sdk"
    Make-ISO
  }
}

Main -ProjectName $ProjectName -Rule $Rule
