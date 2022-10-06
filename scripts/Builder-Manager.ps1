# TODO : expand archive -force in modules
# TODO : change BuilderZIP
param (
  #[Parameter(Mandatory=$true)][String] $ProjectName,
  [Parameter(Mandatory=$true)][String] $ConfigFile,
  [String] $Rule = "default"
)

Import-Module "..\..\scripts\modules\module-sdk.ps1"
Import-Module "..\..\scripts\modules\module-mak.ps1"
Import-Module "..\..\scripts\modules\module-emulators.ps1"
Import-Module "..\..\scripts\modules\module-mame.ps1"
Import-Module "..\..\scripts\modules\module-raine.ps1"
Import-Module "..\..\scripts\modules\module-iso.ps1"

function Main {
  param (
    [Parameter(Mandatory=$true)][String] $MakeFile,
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $PathNeoDevBin,
    [Parameter(Mandatory=$true)][String] $PathNeocoreBin,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $XMLDATFile,
    [Parameter(Mandatory=$true)][String] $PathMame,
    [Parameter(Mandatory=$true)][String] $Rule,
    [Parameter(Mandatory=$true)][String] $RaineBin, # TODO : useless
    [Parameter(Mandatory=$true)][String] $PathRaine,
    [Parameter(Mandatory=$true)][xml] $Config
  )
  Write-Host "project name : $ProjectName"
  Write-Host "makefile : $MakeFile"
  Write-Host "path neodev bin : $PathNeoDevBin"
  Write-Host "path neocore bin : $PathNeocoreBin"
  Write-Host "path neodev : $PathNeoDev"
  Write-Host "program file : $PRGFILE"
  Write-Host "required rule : $Rule"
  Write-Host "project setting file : $XMLProjectSettingFile"
  Write-Host "graphic data XML file for DATLib : $XMLDATFile"
  Write-Host "mame folder : $PathMame"
  Write-Host "raine folder : $PathRaine"
  Write-Host "--------------------------------------------"
  Write-Host ""

  Stop-Emulators

  if ((Test-Path -Path $PathNeoDevBin) -eq $false) { Install-SDK }
  if ((Test-Path -Path $PathNeocoreBin) -eq $false) { Install-SDK }
  if ((Test-Path -Path $PathNeoDev) -eq $false) { Install-SDK }
  if ((Test-Path -Path "$PathNeoDev\m68k\include\neocore.h") -eq $false) { Install-SDK }
  if ((Test-Path -Path "$PathNeoDev\m68k\lib\libneocore.a") -eq $false) { Install-SDK }

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
    Write-Sprite -XMLFile $XMLDATFile -Format "cd" -OutputFile "$env:TEMP\neocore\$ProjectName\$ProjectName"
  }

  function BuilderISO {
    Write-ISO `
      -PRGFile $PRGFile `
      -SpriteFile "$env:TEMP\neocore\$ProjectName\$ProjectName.cd" `
      -OutputFile "$env:TEMP\neocore\$ProjectName\$ProjectName.iso" `
      -PathISOBuildFolder "$env:TEMP\neocore\$ProjectName\iso" `
      -PathCDTemplate "$env:APPDATA\neocore\cd_template"

    $configCDDA = $null

    if ($Config.project.sound.cdda.tracks.track) { $configCDDA = $config.project.sound.cdda }

    Write-CUE `
      -OutputFile "$env:TEMP\neocore\$ProjectName\$ProjectName.cue" `
      -ISOName "$ProjectName.iso" `
      -Config $configCDDA

    Robocopy /MIR assets "$env:TEMP\neocore\$ProjectName\assets"
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

  function RunnerMame {
    Mame -GameName $ProjectName -PathMame $PathMame -XMLArgsFile "$env:APPDATA\neocore\mame-args.xml"
  }

  function RunnerRaine {
    Raine -File "$env:TEMP\neocore\$ProjectName\$ProjectName.cue" -PathRaine $PathRaine
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
    # TODO : change zip rule
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderZIP
  }
  if ($Rule -eq "run") {
    BuilderSprite
    BuilderProgram
    BuilderISO
    #BuilderZIP
    BuilderMame
    RunnerMame
  }
  if ($Rule -eq "run:raine") {
    BuilderSprite
    BuilderProgram
    BuilderISO
    #BuilderZIP
    RunnerRaine
  }
  if ($Rule -eq "run:mame") {
    BuilderSprite
    BuilderProgram
    BuilderISO
    #BuilderZIP
    BuilderMame
    RunnerMame
  }
  if ($Rule -eq "serve") {
    While ($true) {
      BuilderSprite
      BuilderProgram
      BuilderISO
      BuilderMame
      RunnerMame
      Watch-Folder -Path "."
      Stop-Emulators
    }
  }
  if ($Rule -eq "only:sprite") { BuilderSprite }
  if ($Rule -eq "only:program") { BuilderProgram }
  if ($Rule -eq "only:iso") { BuilderISO }
  if ($Rule -eq "only:zip") { BuilderZIP }
  if ($Rule -eq "only:mame") { BuilderMame }
  if ($Rule -eq "only:run") { RunnerMame }
  if ($Rule -eq "only:run:mame") { RunnerMame }
  if ($Rule -eq "only:run:raine") { RunnerRaine }
}


if ((Test-Path -Path $ConfigFile) -eq $false) {
  Write-Host "Config $ConfigFile not found" -ForegroundColor Red
  exit 1
}

Write-Host "informations" -ForegroundColor Yellow

# TODO : Config to ConfigSound or ConfigCDDA ...
# TODO : refactor entry point

Write-Host "Config file : $ConfigFile"
[xml]$config = (Get-Content -Path $ConfigFile)
$projectName = $config.project.name
$makefile = $config.project.makefile
$XMLDATFile = $config.project.XMLDATFile

# TODO : useless RaineBin
Main `
  -MakeFile $makefile `
  -ProjectName $projectName `
  -PathNeoDevBin "$env:appdata\neocore\neodev-sdk\m68k\bin" `
  -PathNeocoreBin "$env:appdata\neocore\bin" `
  -PathNeoDev "$env:appdata\neocore\neodev-sdk" `
  -PRGFile "$env:temp\neocore\$ProjectName\$ProjectName.prg" `
  -Rule $Rule `
  -XMLDATFile $XMLDATFile `
  -Config  $config `
  -RaineBin "$env:APPDATA\neocore\raine\raine32.exe" `
  -PathRaine "$env:APPDATA\neocore\raine" `
  -PathMame "$env:APPDATA\neocore\mame"
