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
    [Parameter(Mandatory=$true)][String] $XMLFile,
    [String] $Rule,
    [String] $RaineBin,
    [String] $MameBin
  )
  Write-Host "project informations" -ForegroundColor Yellow
  Write-Host "projectName : $ProjectName"
  Write-Host "makefile : $MakeFile"
  Write-Host "pathNeodevBin : $PathNeoDevBin"
  Write-Host "pathNeocoreBin : $PathNeocoreBin"
  Write-Host "pathNeodev : $PathNeoDev"
  Write-Host "PRGFile : $PRGFILE"
  Write-Host "Rule : $Rule"
  Write-Host "XMLFile : $XMLFILE"

  if ($RaineBin) { Write-Host "Raine : $RaineBin" }
  if ($MameBin) { Write-Host "Mame : $MameBin" }
  Write-Host "--------------------------------------------"
  Write-Host ""

  if ((Test-Path -Path "$env:TEMP\neocore\$ProjectName") -eq $false) { mkdir "$env:TEMP\neocore\$ProjectName" | Out-Null }

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

  function BuilderZIP {
    Write-ZIP `
      -Path "$env:TEMP\neocore\$ProjectName\iso" `
      -OutputFile "$env:TEMP\neocore\$ProjectName\$ProjectName.zip" `
      -ISOFile "$env:TEMP\neocore\$ProjectName\$ProjectName.iso"
  }

  Set-EnvPath -PathNeoDevBin $PathNeoDevBin -PathNeocoreBin $PathNeocoreBin
  if ($Rule -eq "clean") { Remove-Project -ProjectName $ProjectName }
  if ($Rule -eq "sprite") { BuilderSprite }
  if (($Rule -eq "make") -or ($Rule -eq "") -or (!$Rule) -or ($Rule -eq "default") ) {
    # TODO : BuilderClean
    Remove-Project -ProjectName $ProjectName
    mkdir -Path "$env:TEMP\neocore\$ProjectName"
    BuilderSprite
    BuilderProgram
  } 
  if ($Rule -eq "iso") {
    Remove-Project -ProjectName $ProjectName
    mkdir -Path "$env:TEMP\neocore\$ProjectName"
    BuilderSprite
    BuilderProgram
    BuilderISO
  }
  if ($Rule -eq "zip") {
    Remove-Project -ProjectName $ProjectName
    mkdir -Path "$env:TEMP\neocore\$ProjectName"
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderZIP
  }
  if ($Rule -eq "run") {
    Remove-Project -ProjectName $ProjectName
    mkdir -Path "$env:TEMP\neocore\$ProjectName"
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderZIP
    & $RaineBin "$env:TEMP\neocore\$ProjectName\$ProjectName.zip"
  }
  if ($Rule -eq "run:raine") {
    Remove-Project -ProjectName $ProjectName
    mkdir -Path "$env:TEMP\neocore\$ProjectName"
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderZIP
    & $RaineBin "$env:TEMP\neocore\$ProjectName\$ProjectName.zip"
  }
  if ($Rule -eq "run:mame") {
    Remove-Project -ProjectName $ProjectName
    mkdir -Path "$env:TEMP\neocore\$ProjectName"
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderZIP
    BuilderCUE
    <#
    %CHDMAN% createcd -i %FILECUE% -o %FILECHD% --force > nul
    powershell -ExecutionPolicy Bypass -File ..\..\scripts\mame-hash-writer.ps1 %PROJECT% %FILECHD% %MAMEHASH%
    #>
    <#
    :mame-start-process
      echo starting mame ...
      start cmd /c "%MAMEFOLDER%\mame64.exe %MAME_ARGS% -rompath %MAMEFOLDER%\roms -hashpath %MAMEFOLDER%\hash -cfg_directory %temp% -nvram_directory %temp% -skip_gameinfo neocdz %PROJECT%"
    #>
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
  -RaineBin "$env:APPDATA\neocore\raine\raine32.exe" `
  -MameBin "$env:APPDATA\neocore\mame\mame64.exe"
