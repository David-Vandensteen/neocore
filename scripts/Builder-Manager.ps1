# TODO : change BuilderZIP
param (
  [Parameter(Mandatory=$true)][String] $ConfigFile,
  [String] $Rule = "default"
)

Import-Module "..\..\scripts\modules\module-sdk.ps1"
Import-Module "..\..\scripts\modules\module-emulators.ps1"

function Remove-Project {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName
  )
  Write-Host "clean $ProjectName project" -ForegroundColor Yellow
  Write-Host "remove $env:TEMP\neocore\$ProjectName"
  if (Test-Path -Path $env:TEMP\neocore\$ProjectName) {
    Get-ChildItem -Path $env:TEMP\neocore\$ProjectName -Recurse -ErrorAction SilentlyContinue | Remove-Item -force -Recurse -ErrorAction SilentlyContinue
  }
  if (Test-Path -Path $env:TEMP\neocore\$ProjectName) { Remove-Item $env:TEMP\neocore\$ProjectName -Force -ErrorAction SilentlyContinue }
}

function Set-EnvPath {
  param (
    [Parameter(Mandatory=$true)][String] $PathNeoDevBin,
    [Parameter(Mandatory=$true)][String] $PathNeocoreBin
  )
  $env:path = "$PathNeoDevBin;$PathNeocoreBin;$env:windir\System32;$env:windir\System32\WindowsPowerShell\v1.0\"
  Write-Host "Env Path: $env:path"
  Write-Host "--------------------------------------------"
  Write-Host ""
}

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
    [Parameter(Mandatory=$true)][String] $PathRaine,
    [Parameter(Mandatory=$true)][String] $BaseURL,
    [Parameter(Mandatory=$true)][String] $PathSpool,
    [Parameter(Mandatory=$true)][xml] $Config
  )
  $BASE_URL = $BaseURL
  $PATH_SPOOL = $PathSpool

  if ((Test-Path -Path $PATH_SPOOL) -eq $false) { New-Item -Path $PATH_SPOOL -ItemType Directory -Force }

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
  Write-Host "spool folder for download : $PATH_SPOOL"
  Write-Host "neocore folder : $PATH_NEOCORE"
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

  function BuilderProgram {
    Import-Module "..\..\scripts\modules\module-program.ps1"
    Write-Program -ProjectName $ProjectName -PathNeoDev $PathNeoDev -MakeFile $MakeFile -PRGFile $PRGFile
  }

  function BuilderSprite {
    Import-Module "..\..\scripts\modules\module-sprite.ps1"
    Write-Sprite -XMLFile $XMLDATFile -Format "cd" -OutputFile "$env:TEMP\neocore\$ProjectName\$ProjectName"
  }

  function BuilderISO {
    Import-Module "..\..\scripts\modules\module-iso.ps1"
    Write-ISO `
      -PRGFile $PRGFile `
      -SpriteFile "$env:TEMP\neocore\$ProjectName\$ProjectName.cd" `
      -OutputFile "$env:TEMP\neocore\$ProjectName\$ProjectName.iso" `
      -PathISOBuildFolder "$env:TEMP\neocore\$ProjectName\iso" `
      -PathCDTemplate "$PATH_NEOCORE\cd_template"

    $configCDDA = $null

    if ($Config.project.sound.cdda.tracks.track) { $configCDDA = $config.project.sound.cdda }

    Write-CUE `
      -OutputFile "$env:TEMP\neocore\$ProjectName\$ProjectName.cue" `
      -ISOName "$ProjectName.iso" `
      -Config $configCDDA

    Write-Host "copy assets to $env:TEMP\neocore\$ProjectName\assets" -ForegroundColor Green
    Robocopy /MIR assets "$env:TEMP\neocore\$ProjectName\assets" | Out-Null
  }

  function BuilderMame {
    Write-Mame `
      -ProjectName $ProjectName `
      -PathMame $PathMame `
      -CUEFile "$env:TEMP\neocore\$ProjectName\$ProjectName.cue" `
      -OutputFile "$PathMame\roms\neocdz\$ProjectName.chd"
  }

  function BuilderZIP {
    Import-Module "..\..\scripts\modules\module-zip.ps1"
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
    Import-Module "..\..\scripts\modules\module-mame.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
    #BuilderZIP
    BuilderMame
    RunnerMame
  }
  if ($Rule -eq "run:raine") {
    Import-Module "..\..\scripts\modules\module-raine.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
    #BuilderZIP
    RunnerRaine
  }
  if ($Rule -eq "run:mame") {
    Import-Module "..\..\scripts\modules\module-mame.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
    #BuilderZIP
    BuilderMame
    RunnerMame
  }
  if ($Rule -eq "serve") {
    Import-Module "..\..\scripts\modules\module-mame.ps1"
    Import-Module "..\..\scripts\modules\module-watcher.ps1"
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
Write-Host "Config file : $ConfigFile"
[xml]$config = (Get-Content -Path $ConfigFile)
$projectName = $config.project.name
$makefile = $config.project.makefile
$XMLDATFile = $config.project.XMLDATFile

$pathBuild = "..\..\build"
$pathNeocore = "..\..\build"

if ((Test-Path -Path $pathBuild) -eq $false) { New-Item -Path $pathBuild -ItemType Directory -Force }
if ((Test-Path -Path $pathNeocore) -eq $false) { New-Item -Path $pathNeocore -ItemType Directory -Force }

$PATH_BUILD = (Resolve-Path -Path $pathBuild).Path
$PATH_NEOCORE = (Resolve-Path -Path $pathNeocore).Path

Main `
  -MakeFile $makefile `
  -ProjectName $projectName `
  -PathNeoDevBin "$PATH_NEOCORE\neodev-sdk\m68k\bin" `
  -PathNeocoreBin "$PATH_NEOCORE\bin" `
  -PathNeoDev "$PATH_NEOCORE\neodev-sdk" `
  -PRGFile "$env:TEMP\neocore\$ProjectName\$ProjectName.prg" `
  -Rule $Rule `
  -XMLDATFile $XMLDATFile `
  -Config  $config `
  -PathRaine "$PATH_NEOCORE\raine" `
  -PathMame "$PATH_NEOCORE\mame" `
  -BaseURL "http://azertyvortex.free.fr/download" `
  -PathSpool "$PATH_BUILD\spool"