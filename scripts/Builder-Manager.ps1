param (
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [String] $Rule = "default"
)

Import-Module "..\..\scripts\modules\module-mak.ps1"

function Main {
  param (
    [Parameter(Mandatory=$true)][String] $MakeFile,
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $PathNeoDevBin,
    [Parameter(Mandatory=$true)][String] $PathNeocoreBin,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [String] $Rule,
    [String] $RaineBin,
    [String] $MameBin,
    [Parameter(Mandatory=$true)][String] $XMLFile
  )

  Write-Host "makefile : $MakeFile"
  Write-Host "projectName : $ProjectName"
  Write-Host "pathNeodevBin : $PathNeoDevBin"
  Write-Host "pathNeocoreBin : $PathNeocoreBin"
  Write-Host "pathNeodev : $PathNeoDev"
  Write-Host "PRGFile : $PRGFILE"
  Write-Host "Rule : $Rule"
  Write-Host "XMLFile : $XMLFILE"

  if ($RaineBin) { Write-Host "Raine : $RaineBin" }
  if ($MameBin) { Write-Host "Mame : $MameBin" }

  if ((Test-Path -Path "$env:TEMP\neocore\$ProjectName") -eq $false) { mkdir "$env:TEMP\neocore\$ProjectName" }

  function BuilderProgram { Write-Program -ProjectName $ProjectName -PathNeoDev $PathNeoDev -MakeFile $MakeFile -PRGFile $PRGFile }

  function BuilderSprite {
    Write-Sprite -XMLFile $XMLFile -Format "cd" -OutputFile "$env:TEMP\neocore\$ProjectName\$ProjectName"
  }

  function BuilderISO {
    Write-Iso `
      -PRGFile $PRGFile `
      -SpriteFile "$env:TEMP\neocore\$ProjectName\$ProjectName.cd" `
      -OutputFile "$env:TEMP\neocore\$ProjectName\$ProjectName.iso" `
      -PathISOBuildFolder "$env:TEMP\neocore\$ProjectName\iso" `
      -PathCDTemplate "$env:APPDATA\neocore\cd_template"
  }

  function BuilderZip {
    Write-Zip `
      -Path "$env:TEMP\neocore\$ProjectName\iso" `
      -OutputFile "$env:TEMP\neocore\$ProjectName\$ProjectName.zip" `
      -ISOFile "$env:TEMP\neocore\$ProjectName\$ProjectName.iso"
  }

  Set-EnvPath -PathNeoDevBin $PathNeoDevBin -PathNeocoreBin $PathNeocoreBin
  if ($Rule -eq "clean") { Remove-Project -ProjectName $ProjectName }
  if ($Rule -eq "sprite") { BuilderSprite }
  if (($Rule -eq "make") -or ($Rule -eq "") -or (!$Rule) -or ($Rule -eq "default") ) { 
    BuilderSprite
    BuilderProgram
  } 
  if ($Rule -eq "iso") {
    BuilderSprite
    BuilderProgram
    BuilderISO
  }
  if ($Rule -eq "cue") {
    BuilderSprite
    BuilderProgram
    BuilderISO
  }
  if ($Rule -eq "zip") {
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderZip
  }
  if ($Rule -eq "run:raine") {
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderZip
    & $RaineBin "$env:TEMP\neocore\$ProjectName\$ProjectName.zip"
  }
}

Main `
  -MakeFile "..\Makefile" `
  -ProjectName $ProjectName `
  -PathNeoDevBin "$env:appdata\neocore\neodev-sdk\m68k\bin" `
  -PathNeocoreBin "$env:appdata\neocore\bin" `
  -PathNeoDev "$env:appdata\neocore\neodev-sdk" `
  -PRGFile "$env:temp\neocore\$ProjectName\$ProjectName.prg" `
  -Rule $Rule `
  -XMLFile "chardata.xml" `
  -RaineBin "$env:APPDATA\neocore\raine\raine32.exe"
