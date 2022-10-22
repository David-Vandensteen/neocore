# TODO : rule dist:iso
# TODO : rule dist:mame
# TODO : mame is not needed to make a mame dist

param (
  [Parameter(Mandatory=$true)][String] $ConfigFile,
  [String] $Rule = "default"
)

function Check {
  param ([Parameter(Mandatory=$true)][xml] $Config)
  function Check-XMLError {
    param ([Parameter(Mandatory=$true)][String] $Entry)
    Write-Host "error : xml $Entry not found" -ForegroundColor Red
    exit 1
  }
  function Check-PathError {
    param ([Parameter(Mandatory=$true)][String] $Path)
    Write-Host "error : $Path not found" -ForegroundColor Red
    exit 1
  }
  function Check-XML {
    if (-Not($Config.project.name)) { Check-XMLError -Entry "project.name" }
    if (-Not($Config.project.version)) { Check-XMLError -Entry "project.version" }
    if (-Not($Config.project.makefile)) { Check-XMLError -Entry "project.makefile" }
    if (-Not($Config.project.toolchainPath)) { Check-XMLError -Entry "project.toolchainPath" }
    if (-Not($Config.project.buildPath)) { Check-XMLError -Entry "project.buildPath" }
    if (-Not($Config.project.distPath)) { Check-XMLError -Entry "project.distPath" }
    if (-Not($Config.project.XMLDATFile)) { Check-XMLError -Entry "project.XMLDATFile" }
  }
  function Check-Path {
    if ((Test-Path -Path $Config.project.makefile) -eq $false) { Check-PathError -Path $Config.project.makefile }
    if ((Test-Path -Path $Config.project.toolchainPath) -eq $false) { Check-PathError -Path $Config.project.toolchainPath }
    if ((Test-Path -Path $Config.project.XMLDATFile) -eq $false) { Check-PathError -Path $Config.project.XMLDATFile }
    if ((Test-Path -Path "$($Config.project.toolchainPath)\..\manifest.xml") -eq $false) { Check-PathError -Path "$($Config.project.toolchainPath)\..\manifest.xml" }

  }
  Write-Host "check config" -ForegroundColor Blue
  Check-XML
  Check-Path
  Write-Host "config is compliant" -ForegroundColor Green
}

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

  Check -Config $Config
  $pathDist = $Config.project.distPath
  $pathToolchain = $Config.project.toolchainPath
  $version = $Config.project.version

  Write-Host "path toolchain : $pathToolchain"

  $PATH_TOOLCHAIN = $pathToolchain

  Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-logger.ps1"
  Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-sdk.ps1"
  Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-emulators.ps1"

  $BASE_URL = $BaseURL
  $PATH_SPOOL = $PathSpool

  if ((Test-Path -Path $PATH_SPOOL) -eq $false) { New-Item -Path $PATH_SPOOL -ItemType Directory -Force }

  Write-Host "project name : $ProjectName"
  Write-Host "project version : $version"
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
  Write-Host "path dist : $pathDist"
  Write-Host "--------------------------------------------"
  Write-Host ""

  Stop-Emulators

  Set-EnvPath -PathNeoDevBin $PathNeoDevBin -PathNeocoreBin $PathNeocoreBin
  $env:NEODEV = $PathNeoDev

  if ((Test-Path -Path $PathNeoDevBin) -eq $false) { Install-SDK }
  if ((Test-Path -Path $PathNeocoreBin) -eq $false) { Install-SDK }
  if ((Test-Path -Path $PathNeoDev) -eq $false) { Install-SDK }
  if ((Test-Path -Path "$PathNeoDev\m68k\include\neocore.h") -eq $false) { Install-SDK }
  if ((Test-Path -Path "$PathNeoDev\m68k\lib\libneocore.a") -eq $false) { Install-SDK }

  if ($Rule -notmatch "^only:") { Remove-Project }
  if ((Test-Path -Path $PATH_BUILD) -eq $false) { New-Item -Path $PATH_BUILD -ItemType Directory -Force }
  if ((Test-Path -Path $pathDist) -eq $false) { New-Item -Path $pathDist -ItemType Directory -Force }

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

    Write-Host "copy assets to $PATH_BUILD\assets" -ForegroundColor Blue
    Robocopy /MIR assets "$PATH_BUILD\assets" | Out-Null
    # TODO : check lastexitcode

    Write-CUE `
      -OutputFile "$PATH_BUILD\$ProjectName.cue" `
      -ISOName "$ProjectName.iso" `
      -Config $configCDDA
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
  if ($Rule -eq "run") {
    Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-mame.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderMame
    RunnerMame
  }
  if ($Rule -eq "run:raine") {
    Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-raine.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
    RunnerRaine
  }
  if ($Rule -eq "run:mame") {
    Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-mame.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
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
  if ($Rule -eq "dist") {
    Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-mame.ps1"
    Import-Module "$PATH_TOOLCHAIN\scripts\modules\module-dist.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderMame
    Write-Dist `
      -ProjectName $ProjectName `
      -PathDestination "$pathDist\$ProjectName\$version" `
      -ISOFile "$PATH_BUILD\$ProjectName.iso" `
      -CUEFile "$PATH_BUILD\$ProjectName.cue" `
      -CHDFile "$PathMame\roms\neocdz\$ProjectName.chd" `
      -HashFile "$PathMame\hash\neocd.xml"

  }
  if ($Rule -eq "only:sprite") { BuilderSprite }
  if ($Rule -eq "only:program") { BuilderProgram }
  if ($Rule -eq "only:iso") { BuilderISO }
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