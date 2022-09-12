# TODO : critical hot reload with mame
# TODO : critical update readme for hot reloading only with mame
# TODO : critical scafolding
# TODO : critical update mak.bat in all project
# TODO : critical build & run all project script
# TODO : critical remove useless scripts
# TODO : test on win10-x64 stock (make a branch with readme update)
# TODO : test on win11 stock (make a branch with readme update)
# TODO : mame with params
# TODO : update readme, explain Makefile overload

param (
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [String] $Rule = "default"
)

Import-Module "..\..\scripts\modules\module-mak.ps1"
Import-Module "..\..\scripts\modules\module-emulators.ps1"
Import-Module "..\..\scripts\modules\module-mame.ps1"

function Main {
  param (
    [Parameter(Mandatory=$true)][String] $MakeFile,
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $PathNeoDevBin,
    [Parameter(Mandatory=$true)][String] $PathNeocoreBin,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $XMLFile,
    [Parameter(Mandatory=$true)][String] $PathMame,
    [Parameter(Mandatory=$true)][String] $Rule,
    [Parameter(Mandatory=$true)][String] $RaineBin
  )
  Write-Host "informations" -ForegroundColor Yellow
  Write-Host "project name : $ProjectName"
  Write-Host "makefile : $MakeFile"
  Write-Host "path neodev bin : $PathNeoDevBin"
  Write-Host "path neocore bin : $PathNeocoreBin"
  Write-Host "path neodev : $PathNeoDev"
  Write-Host "program file : $PRGFILE"
  Write-Host "required rule : $Rule"
  Write-Host "graphic data XML file for DATLib : $XMLFILE"
  Write-Host "mame folder : $PathMame"
  Write-Host "raine exe : $RaineBin"
  Write-Host "--------------------------------------------"
  Write-Host ""

  Stop-Emulators

  function BuilderClean {
    param (
      [Parameter(Mandatory=$true)][String] $ProjectName
    )
    Remove-Project -ProjectName $ProjectName
  }
  if ($Rule -notmatch "^only:") { BuilderClean -ProjectName $ProjectName }
  if ((Test-Path -Path "$env:TEMP\neocore\$ProjectName") -eq $false) { mkdir -Path "$env:TEMP\neocore\$ProjectName" | Out-Null }

  function BuilderProgram { Write-Program -ProjectName $ProjectName -PathNeoDev $PathNeoDev -MakeFile $MakeFile -PRGFile $PRGFile }

  function BuilderSprite {
    Write-Sprite -XMLFile $XMLFile -Format "cd" -OutputFile "$env:TEMP\neocore\$ProjectName\$ProjectName"
  }

  function BuilderISO {
    Write-ISO `
      -PRGFile $PRGFile `
      -SpriteFile "$env:TEMP\neocore\$ProjectName\$ProjectName.cd" `
      -OutputFile "$env:TEMP\neocore\$ProjectName\$ProjectName.iso" `
      -PathISOBuildFolder "$env:TEMP\neocore\$ProjectName\iso" `
      -PathCDTemplate "$env:APPDATA\neocore\cd_template"

    Write-CUE -OutputFile "$env:TEMP\neocore\$ProjectName\$ProjectName.cue" -ISOName "$ProjectName.iso"
  }

  function BuilderMame {
    Write-Mame `
      -ProjectName $ProjectName `
      -PathMame $PathMame `
      -CUEFile "$env:TEMP\neocore\$ProjectName\$ProjectName.cue" `
      -OutputFile "$PathMame\roms\neocdz\$ProjectName.chd"
  }

  function BuilderZIP {
    Write-ZIP `
      -Path "$env:TEMP\neocore\$ProjectName\iso" `
      -OutputFile "$env:TEMP\neocore\$ProjectName\$ProjectName.zip" `
      -ISOFile "$env:TEMP\neocore\$ProjectName\$ProjectName.iso"
  }

  Set-EnvPath -PathNeoDevBin $PathNeoDevBin -PathNeocoreBin $PathNeocoreBin
  if ($Rule -eq "clean") { exit 0 }
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
  if ($Rule -eq "zip") {
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderZIP
  }
  if ($Rule -eq "run") {
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderZIP
    & $RaineBin "$env:TEMP\neocore\$ProjectName\$ProjectName.zip"
  }
  if ($Rule -eq "run:raine") {
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderZIP
    & $RaineBin "$env:TEMP\neocore\$ProjectName\$ProjectName.zip"
  }
  if ($Rule -eq "run:mame") {
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderZIP
    BuilderMame
    Mame -GameName $ProjectName -PathMame $PathMame
  }
  if ($Rule -eq "only:sprite") { BuilderSprite }
  if ($Rule -eq "only:program") { BuilderProgram }
  if ($Rule -eq "only:iso") { BuilderISO }
  if ($Rule -eq "only:zip") { BuilderZIP }
  if ($Rule -eq "only:mame") { BuilderMame }
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
  -RaineBin "$env:APPDATA\neocore\raine\raine32.exe" `
  -PathMame "$env:APPDATA\neocore\mame"
