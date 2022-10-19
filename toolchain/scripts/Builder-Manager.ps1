# TODO : change BuilderZIP
param (
  [Parameter(Mandatory=$true)][String] $ConfigFile,
  [String] $Rule = "default"
)

function Remove-Project {
  Write-Host "clean $PATH_BUILD" -ForegroundColor Yellow
  if (Test-Path -Path $PATH_BUILD) {
    Get-ChildItem -Path $PATH_BUILD -Recurse -ErrorAction SilentlyContinue | Remove-Item -force -Recurse -ErrorAction SilentlyContinue
  }
  if (Test-Path -Path $PATH_BUILD) { Remove-Item $PATH_BUILD -Force -ErrorAction SilentlyContinue }
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
  $pathToolchain = $Config.project.toolchainPath
  Write-Host "path toolchain : $pathToolchain"

  if ((Test-Path -Path $pathToolchain) -eq $false) {
    Write-Host "error : Toolchain path $pathToolchain not found" -ForegroundColor Red
    exit 1
  }

  $PATH_TOOLCHAIN = $pathToolchain

  Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-sdk.ps1"
  Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-emulators.ps1"

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
  Write-Host "path build : $PATH_BUILD"
  Write-Host "--------------------------------------------"
  Write-Host ""

  Stop-Emulators

  if ((Test-Path -Path $PathNeoDevBin) -eq $false) { Install-SDK }
  if ((Test-Path -Path $PathNeocoreBin) -eq $false) { Install-SDK }
  if ((Test-Path -Path $PathNeoDev) -eq $false) { Install-SDK }
  if ((Test-Path -Path "$PathNeoDev\m68k\include\neocore.h") -eq $false) { Install-SDK }
  if ((Test-Path -Path "$PathNeoDev\m68k\lib\libneocore.a") -eq $false) { Install-SDK }

  if ($Rule -notmatch "^only:") { Remove-Project }
  if ((Test-Path -Path $PATH_BUILD) -eq $false) { New-Item -Path $PATH_BUILD -ItemType Directory -Force }

  function BuilderProgram {
    Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-program.ps1"
    Write-Program -ProjectName $ProjectName -PathNeoDev $PathNeoDev -MakeFile $MakeFile -PRGFile $PRGFile
  }

  function BuilderSprite {
    Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-sprite.ps1"
    Write-Sprite -XMLFile $XMLDATFile -Format "cd" -OutputFile "$PATH_BUILD\$ProjectName"
  }

  function BuilderISO {
    Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-iso.ps1"
    Write-ISO `
      -PRGFile $PRGFile `
      -SpriteFile "$PATH_BUILD\$ProjectName.cd" `
      -OutputFile "$PATH_BUILD\$ProjectName.iso" `
      -PathISOBuildFolder "$PATH_BUILD\iso" `
      -PathCDTemplate "$PATH_NEOCORE\cd_template"

    $configCDDA = $null

    if ($Config.project.sound.cdda.tracks.track) { $configCDDA = $config.project.sound.cdda }

    Write-CUE `
      -OutputFile "$PATH_BUILD\$ProjectName.cue" `
      -ISOName "$ProjectName.iso" `
      -Config $configCDDA

    Write-Host "copy assets to $PATH_BUILD\assets" -ForegroundColor Green
    Robocopy /MIR assets "$PATH_BUILD\assets" | Out-Null
    # TODO : check lastexitcode
  }

  function BuilderMame {
    Write-Mame `
      -ProjectName $ProjectName `
      -PathMame $PathMame `
      -CUEFile "$PATH_BUILD\$ProjectName.cue" `
      -OutputFile "$PathMame\roms\neocdz\$ProjectName.chd"
  }

  function BuilderZIP {
    Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-zip.ps1"
    Write-ZIP `
      -Path "$PATH_BUILD\iso" `
      -OutputFile "$PATH_BUILD\$ProjectName.zip" `
      -ISOFile "$PATH_BUILD\$ProjectName.iso"
  }

  function RunnerMame {
    Mame -GameName $ProjectName -PathMame $PathMame -XMLArgsFile "$PATH_NEOCORE\mame-args.xml"
  }

  function RunnerRaine {
    Raine -File "$PATH_BUILD\$ProjectName.cue" -PathRaine $PathRaine
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
    Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-mame.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
    #BuilderZIP
    BuilderMame
    RunnerMame
  }
  if ($Rule -eq "run:raine") {
    Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-raine.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
    #BuilderZIP
    RunnerRaine
  }
  if ($Rule -eq "run:mame") {
    Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-mame.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
    #BuilderZIP
    BuilderMame
    RunnerMame
  }
  if ($Rule -eq "serve") {
    Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-mame.ps1"
    Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-watcher.ps1"
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
$pathNeocore = $config.project.buildPath
$pathBuild = "$pathNeocore\$projectName"

#$pathBuild = "..\..\build\projects\$projectName"
#$pathNeocore = "..\..\build"

if ($projectName -eq "") {
  Write-Host "error : add the project name in : $ConfigFile" -ForegroundColor Red
}

if ((Test-Path -Path $pathNeocore) -eq $false) { New-Item -Path $pathNeocore -ItemType Directory -Force }
if ((Test-Path -Path $pathBuild) -eq $false) { New-Item -Path $pathBuild -ItemType Directory -Force }

$PATH_BUILD = (Resolve-Path -Path $pathBuild).Path
$PATH_NEOCORE = (Resolve-Path -Path $pathNeocore).Path

Main `
  -MakeFile $makefile `
  -ProjectName $projectName `
  -PathNeoDevBin "$PATH_NEOCORE\neodev-sdk\m68k\bin" `
  -PathNeocoreBin "$PATH_NEOCORE\bin" `
  -PathNeoDev "$PATH_NEOCORE\neodev-sdk" `
  -PRGFile "$PATH_BUILD\$ProjectName.prg" `
  -Rule $Rule `
  -XMLDATFile $XMLDATFile `
  -Config  $config `
  -PathRaine "$PATH_NEOCORE\raine" `
  -PathMame "$PATH_NEOCORE\mame" `
  -BaseURL "http://azertyvortex.free.fr/download" `
  -PathSpool "$PATH_NEOCORE\spool"