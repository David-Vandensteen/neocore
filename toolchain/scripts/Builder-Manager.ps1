# Neocore
# David Vandensteen
# MIT

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
  Write-Host "check config" -ForegroundColor Yellow
  Check-XML
  Check-Path
  if ($Config.project.name -like "*-*") { Write-Host "error : char - is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*\*") { Write-Host "error : char \ is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*/*") { Write-Host "error : char / is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*$*") { Write-Host "error : char $ is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*=*") { Write-Host "error : char = is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*@*") { Write-Host "error : char @ is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*(*") { Write-Host "error : char ( is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*)*") { Write-Host "error : char ) is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*{*") { Write-Host "error : char { is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*}*") { Write-Host "error : char } is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*#*") { Write-Host "error : char # is not allowed in project name" -ForegroundColor Red; exit 1 }
  Write-Host "config is compliant" -ForegroundColor Green
}

function Remove-Project {
  Write-Host "clean $($buildConfig.pathBuild)" -ForegroundColor Yellow
  if (Test-Path -Path $buildConfig.pathBuild) {
    Get-ChildItem -Path $buildConfig.pathBuild -Recurse -ErrorAction SilentlyContinue | Remove-Item -force -Recurse -ErrorAction SilentlyContinue
  }
  if (Test-Path -Path $buildConfig.pathBuild) { Remove-Item $buildConfig.pathBuild -Force -ErrorAction SilentlyContinue }
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
    [Parameter(Mandatory=$true)][String] $Rule,
    [Parameter(Mandatory=$true)][String] $BaseURL,
    [Parameter(Mandatory=$true)][xml] $Config
  )

  Check -Config $Config

  $buildConfig = [PSCustomObject]@{
    pathMame = "$($Config.project.buildPath)\mame"
    pathRaine = "$($Config.project.buildPath)\raine"
    pathSpool = "$($Config.project.buildPath)\spool"
    pathNeocore = $Config.project.buildPath
    pathBuild = "$($Config.project.buildPath)\$($Config.project.name)"
    pathDist = $Config.project.distPath
    pathNeodevBin = "$($Config.project.buildPath)\neodev-sdk\m68k\bin"
    pathNeocoreBin = "$($Config.project.buildPath)\bin"
    pathNeodev = "$($Config.project.buildPath)\neodev-sdk"
    pathToolchain = $Config.project.toolchainPath
    projectName = $Config.project.name
    version = $Config.project.version
    makefile = $Config.project.makefile
    PRGFile = "$($Config.project.buildPath)\$($Config.project.name)\$($Config.project.name).prg"
    rule = $Rule
    XMLDATFile = $Config.project.XMLDATFile
    baseURL = $BaseURL
  }

  Write-Host "project name : $($buildConfig.projectName)"
  Write-Host "project version : $($buildConfig.version)"
  Write-Host "makefile : $($buildConfig.makefile)"
  Write-Host "path neodev bin : $($buildConfig.pathNeodevBin)"
  Write-Host "path neocore bin : $($buildConfig.pathNeocoreBin)"
  Write-Host "path neodev : $($buildConfig.pathNeoDev)"
  Write-Host "program file : $($buildConfig.PRGFile)"
  Write-Host "required rule : $($buildConfig.rule)"
  Write-Host "project setting file : $XMLProjectSettingFile"
  Write-Host "graphic data XML file for DATLib : $($buildConfig.XMLDATFile)"
  Write-Host "mame folder : $($buildConfig.pathMame)"
  Write-Host "raine folder : $($buildConfig.pathRaine)"
  Write-Host "spool folder for download : $($buildConfig.pathSpool)"
  Write-Host "neocore folder : $($buildConfig.pathNeocore)"
  Write-Host "path build : $($buildConfig.pathBuild)"
  Write-Host "path dist : $($buildConfig.pathDist)"
  Write-Host "toolchain : $($buildConfig.pathToolchain)"
  Write-Host "--------------------------------------------"
  Write-Host ""

  Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-logger.ps1"
  Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-sdk.ps1"
  Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-emulators.ps1"

  Stop-Emulators

  if ((Test-Path -Path $buildConfig.pathSpool) -eq $false) { New-Item -Path $buildConfig.pathSpool -ItemType Directory -Force }

  Set-EnvPath -PathNeoDevBin $buildConfig.pathNeodevBin -PathNeocoreBin $buildConfig.pathNeocoreBin
  $env:NEODEV = $buildConfig.pathNeodev

  if ((Test-Path -Path $buildConfig.pathNeoDevBin) -eq $false) { Install-SDK }
  if ((Test-Path -Path $buildConfig.pathNeocoreBin) -eq $false) { Install-SDK }
  if ((Test-Path -Path $buildConfig.pathNeodev) -eq $false) { Install-SDK }

  if ((Test-Path -Path "$($buildConfig.pathNeodev)\m68k\include\neocore.h") -eq $false) { Install-SDK }
  if ((Test-Path -Path "$($buildConfig.pathNeodev)\m68k\lib\libneocore.a") -eq $false) { Install-SDK }

  if ($Rule -notmatch "^only:") { Remove-Project }
  if ((Test-Path -Path $buildConfig.pathBuild) -eq $false) { New-Item -Path $buildConfig.pathBuild -ItemType Directory -Force }

  function BuilderProgram {
    Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-program.ps1"
    Write-Program -ProjectName $buildConfig.projectName -PathNeoDev $buildConfig.pathNeodev -MakeFile $buildConfig.makefile -PRGFile $buildConfig.PRGFile
  }

  function BuilderSprite {
    Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-sprite.ps1"
    Write-Sprite -XMLFile $buildConfig.XMLDATFile -Format "cd" -OutputFile "$($buildConfig.pathBuild)\$($buildConfig.projectName)"
  }

  function BuilderISO {
    Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-iso.ps1"
    Write-ISO `
      -PRGFile $buildConfig.PRGFile `
      -SpriteFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).cd" `
      -OutputFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).iso" `
      -PathISOBuildFolder "$($buildConfig.pathBuils)\iso" `
      -PathCDTemplate "$($buildConfig.pathNeocore)\cd_template"

    $configCDDA = $null

    if ($Config.project.sound.cdda.tracks.track) { $configCDDA = $config.project.sound.cdda }

    Write-Host "copy assets to $($buildConfig.pathBuild)\assets" -ForegroundColor Blue
    Robocopy /MIR assets "$($buildConfig.pathBuild)\assets" | Out-Null
    # TODO : check lastexitcode

    Write-CUE `
      -OutputFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).cue" `
      -ISOName "$($buildConfig.projectName).iso" `
      -Config $configCDDA
  }

  function BuilderMame {
    Write-Mame `
      -ProjectName $buildConfig.projectName `
      -PathMame $buildConfig.pathMame `
      -CUEFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).cue" `
      -OutputFile "$($buildConfig.pathMame)\roms\neocdz\$($buildConfig.projectName).chd"
  }

  function RunnerMame {
    Mame -GameName $buildConfig.projectName -PathMame $buildConfig.pathMame -XMLArgsFile "$($buildConfig.pathNeocore)\mame-args.xml"
  }

  function RunnerRaine {
    Raine -FileName "$($buildConfig.projectName).cue" -PathRaine $buildConfig.pathRaine -PathISO $buildConfig.pathBuild
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
    Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-mame.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderMame
    RunnerMame
  }
  if ($Rule -eq "run:raine") {
    Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-raine.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
    RunnerRaine
  }
  if ($Rule -eq "run:mame") {
    Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-mame.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderMame
    RunnerMame
  }
  if ($Rule -eq "serve") {
    Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-mame.ps1"
    Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-watcher.ps1"
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
    Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-mame.ps1"
    Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-dist.ps1"
    if ((Test-Path -Path $buildConfig.pathDist) -eq $false) { New-Item -Path $buildConfig.pathDist -ItemType Directory -Force }
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderMame
    Write-Dist `
      -ProjectName $buildConfig.projectName `
      -PathDestination "$($buildConfig.pathDist)\$($buildConfig.projectName)\$($buildConfig.version)" `
      -ISOFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).iso" `
      -CUEFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).cue" `
      -CHDFile "$($buildConfig.pathMame)\roms\neocdz\$($buildConfig.projectName).chd" `
      -HashFile "$($buildConfig.pathMame)\hash\neocd.xml"

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

Main -Config $config -BaseURL "http://azertyvortex.free.fr/download" -Rule $Rule
