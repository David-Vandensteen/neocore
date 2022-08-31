param (
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [String] $Rule = "default"
)

Import-Module "..\..\scripts\modules\module-mak.ps1"

function Main {
  param (
    [Parameter(Mandatory=$true)][String] $MakeFile,
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $PathHash,
    [Parameter(Mandatory=$true)][String] $PathNeoDevBin,
    [Parameter(Mandatory=$true)][String] $PathNeocoreBin,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [String] $Rule,
    [Parameter(Mandatory=$true)][String] $XMLFile
  )

  Write-Host "makefile : $MakeFile"
  Write-Host "projectName : $ProjectName"
  Write-Host "pathHash : $PathHash"
  Write-Host "pathNeodevBin : $PathNeoDevBin"
  Write-Host "pathNeocoreBin : $PathNeocoreBin"
  Write-Host "pathNeodev : $PathNeoDev"
  Write-Host "PRGFile : $PRGFILE"
  Write-Host "Rule : $Rule"
  Write-Host "XMLFile : $XMLFILE"

  Set-EnvPath -PathNeoDevBin $PathNeoDevBin -PathNeocoreBin $PathNeocoreBin
  if ($Rule -eq "clean") { Remove-Project -ProjectName $ProjectName }
  if ($Rule -eq "sprite") { Write-Sprite -PathHash $PathHash -XMLFile $XMLFile }
  if (($Rule -eq "make") -or ($Rule -eq "") -or (!$Rule) -or ($Rule -eq "default") ) { 
    Write-Sprite -PathHash $PathHash -XMLFile $XMLFile
    Write-Program -ProjectName $ProjectName -PathNeoDev $PathNeoDev -MakeFile $MakeFile -PRGFile $PRGFile
  } 
  if ($Rule -eq "cue") {
    Write-Sprite -PathHash $PathHash -XMLFile $XMLFile
    Write-Program -ProjectName $ProjectName -PathNeoDev $PathNeoDev -MakeFile $MakeFile -PRGFile $PRGFile
    Write-ISO
  }
}

Main `
  -MakeFile "..\Makefile" `
  -ProjectName $ProjectName `
  -PathHash "$env:temp\neocore\$ProjectName\hash" `
  -PathNeoDevBin "$env:appdata\neocore\neodev-sdk\m68k\bin" `
  -PathNeocoreBin "$env:appdata\neocore\bin" `
  -PathNeoDev "$env:appdata\neocore\neodev-sdk" `
  -PRGFile "$env:temp\neocore\$ProjectName\$ProjectName.prg" `
  -Rule $Rule `
  -XMLFile "chardata.xml"
