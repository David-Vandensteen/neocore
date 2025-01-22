# Neocore
# David Vandensteen
# MIT

param (
  [Parameter(Mandatory=$true)][String] $ConfigFile,
  [String] $Rule = "default"
)

function Main {
  param (
    [Parameter(Mandatory=$true)][String] $Rule,
    [Parameter(Mandatory=$true)][String] $BaseURL,
    [Parameter(Mandatory=$true)][xml] $Config
  )

  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\config.ps1"

  Assert-Config -Config $Config

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
    projectName = $Config.project.name
    version = $Config.project.version
    makefile = $Config.project.makefile
    PRGFile = "$($Config.project.buildPath)\$($Config.project.name)\$($Config.project.name).prg"
    rule = $Rule
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
  Write-Host "--------------------------------------------"
  Write-Host ""

  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\assert\project-name.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\assert\rule.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\logger.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\install\sdk.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\stop\emulators.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\set\env-path.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\remove\project.ps1"

  Assert-Rule -Rule $($buildConfig.rule)
  Assert-ProjectName -Name $($Config.project.name)
  Stop-Emulators

  if ((Test-Path -Path $buildConfig.pathSpool) -eq $false) { New-Item -Path $buildConfig.pathSpool -ItemType Directory -Force }

  $gccPath = "..\..\build\gcc\gcc-2.95.2"
  Write-Host $gccPath

  if ($Config.project.compiler.path) { $gccPath = $Config.project.compiler.path }

  Set-EnvPath -GCCPath $gccPath -Bin "$($Config.project.buildPath)\bin"
  $env:NEODEV = $buildConfig.pathNeodev

  if ((Test-Path -Path $buildConfig.pathNeoDevBin) -eq $false) { Install-SDK }
  if ((Test-Path -Path $buildConfig.pathNeocoreBin) -eq $false) { Install-SDK }
  if ((Test-Path -Path $buildConfig.pathNeodev) -eq $false) { Install-SDK }

  if ($Rule -notmatch "^only:") { Remove-Project }
  if ((Test-Path -Path $buildConfig.pathBuild) -eq $false) { New-Item -Path $buildConfig.pathBuild -ItemType Directory -Force }
  if ($Rule -eq "clean") { exit 0 }

  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\build\sprite.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\build\program.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\build\iso.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\build\mame.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\build\exe.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\install\nsis.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\show\version.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\start\mame.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\start\raine.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\start\animator.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\start\framer.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\watch\folder.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\iso.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\dist.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\program.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\sprite.ps1"

  if ($Rule -eq "animator") { Start-Animator }
  if ($Rule -eq "framer") { Start-Framer }
  if ($Rule -eq "sprite") { Build-Sprite }

  if (($Rule -eq "make") -or ($Rule -eq "") -or (!$Rule) -or ($Rule -eq "default") ) {
    Build-Sprite
    Build-Program
  }

  if ($Rule -eq "iso") {
    Build-Sprite
    Build-Program
    Build-ISO
  }

  if ($Rule -eq "run:raine" -or $Rule -eq "raine") {
    Build-Sprite
    Build-Program
    Build-ISO
    Start-Raine
  }

  if ($Rule -eq "run:mame" -or $Rule -eq "mame" -or $Rule -eq "run") {
    Build-Sprite
    Build-Program
    Build-ISO
    Build-Mame
    Start-Mame
  }

  if ($Rule -eq "serve:raine") {
    While ($true) {
      Build-Sprite
      Build-Program
      Build-ISO
      Start-Raine
      Watch-Folder -Path "."
      Stop-Emulators
    }
  }

  if ($Rule -eq "serve:mame" -or $Rule -eq "serve") {
    While ($true) {
      Build-Sprite
      Build-Program
      Build-ISO
      Build-Mame
      Start-Mame
      Watch-Folder -Path "."
      Stop-Emulators
    }
  }

  if ($Rule -eq "dist:iso" -or $Rule -eq "dist:raine") {
    if ((Test-Path -Path $Config.project.distPath) -eq $false) { New-Item -Path $Config.project.distPath -ItemType Directory -Force }
    Build-Sprite
    Build-Program
    Build-ISO
    Write-Dist `
      -ProjectName $buildConfig.projectName `
      -PathDestination "$($Config.project.distPath)\$($buildConfig.projectName)\$($buildConfig.projectName)-$($buildConfig.version)" `
      -ISOFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).iso" `
      -CUEFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).cue" `
  }

  if ($Rule -eq "dist:mame" -or $Rule -eq "dist:chd") {
    if ((Test-Path -Path $Config.project.distPath) -eq $false) { New-Item -Path $Config.project.distPath -ItemType Directory -Force }
    Build-Sprite
    Build-Program
    Build-ISO
    Build-Mame
    Write-Dist `
      -ProjectName $buildConfig.projectName `
      -PathDestination "$($Config.project.distPath)\$($buildConfig.projectName)\$($buildConfig.projectName)-$($buildConfig.version)" `
      -CHDFile "$($buildConfig.pathMame)\roms\neocdz\$($buildConfig.projectName).chd" `
      -HashFile "$($buildConfig.pathMame)\hash\neocd.xml"
  }

  if ($Rule -eq "dist:exe") {
    if ((Test-Path -Path "$($config.project.buildPath)\tools\nsis-3.08") -eq $false) { Install-NSIS }
    Build-Sprite
    Build-Program
    Build-ISO
    Build-Mame
    Build-EXE
  }

  if ($Rule -eq "--version") {
    Show-Version
  }

  if ($Rule -eq "only:sprite") { Build-Sprite }
  if ($Rule -eq "only:program") { Build-Program }
  if ($Rule -eq "only:iso") { Build-ISO }
  if ($Rule -eq "only:mame") { Build-Mame }
  if ($Rule -eq "only:run") { Start-Mame }
  if ($Rule -eq "only:run:mame") { Start-Mame }
  if ($Rule -eq "only:run:raine") { Start-Mame }
}

if ((Test-Path -Path $ConfigFile) -eq $false) {
  Write-Host "Config $ConfigFile not found" -ForegroundColor Red
  exit 1
}

Write-Host "informations" -ForegroundColor Blue
Write-Host "Config file : $ConfigFile"

[xml]$config = (Get-Content -Path $ConfigFile)

Main -Config $config -BaseURL "http://azertyvortex.free.fr/download" -Rule $Rule
