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

  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\check.ps1"

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
  Write-Host "--------------------------------------------"
  Write-Host ""

  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\models\project-name.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\models\rule.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\utils\logger.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\services\installers\sdk.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\utils\emulators.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\utils\set-env-path.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\utils\remove-project.ps1"

  Model-Rule -Rule $($buildConfig.rule)
  Model-Project-Name -Name $($Config.project.name)

  $raineProcessName = [System.IO.Path]::GetFileNameWithoutExtension($Config.project.emulator.raine.exeFile)
  $mameProcessName = [System.IO.Path]::GetFileNameWithoutExtension($Config.project.emulator.mame.exeFile)

  Stop-Emulators -RaineProcessName $raineProcessName -MameProcessName $mameProcessName

  if ((Test-Path -Path $buildConfig.pathSpool) -eq $false) { New-Item -Path $buildConfig.pathSpool -ItemType Directory -Force }

  $gccPath = "..\..\build\gcc\gcc-2.95.2"
  Write-Host $gccPath

  if ($Config.project.compiler.path) { $gccPath = $Config.project.compiler.path }

  Set-EnvPath -GCCPath $gccPath -Bin "$($Config.project.buildPath)\bin"
  $env:NEODEV = $buildConfig.pathNeodev

  if ((Test-Path -Path $buildConfig.pathNeoDevBin) -eq $false) { Install-SDK }
  if ((Test-Path -Path $buildConfig.pathNeocoreBin) -eq $false) { Install-SDK }
  if ((Test-Path -Path $buildConfig.pathNeodev) -eq $false) { Install-SDK }

  # TODO : if ((Test-Path -Path "$($buildConfig.pathNeodev)\m68k\include\neocore.h") -eq $false) { Install-SDK }
  # TODO : if ((Test-Path -Path "$($buildConfig.pathNeodev)\m68k\lib\libneocore.a") -eq $false) { Install-SDK }

  if ($Rule -notmatch "^only:") { Remove-Project }
  if ((Test-Path -Path $buildConfig.pathBuild) -eq $false) { New-Item -Path $buildConfig.pathBuild -ItemType Directory -Force }

  if ($Rule -eq "clean") { exit 0 }

  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-raine.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\utils\watcher.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\utils\show-version.ps1"

  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\writers\iso.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\writers\dist.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\writers\program.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\writers\sprite.ps1"

  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\builders\builder-sprite.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\builders\builder-program.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\builders\builder-iso.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\builders\builder-mame.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\builders\exe.ps1"

  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\runners\runner-mame.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\runners\runner-raine.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\runners\animator.ps1"
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\runners\framer.ps1"

  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\installers\nsis.ps1"

  if ($Rule -eq "animator") { RunnerAnimator }
  if ($Rule -eq "framer") { RunnerFramer }
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

  if ($Rule -eq "run:raine" -or $Rule -eq "raine") {
    BuilderSprite
    BuilderProgram
    BuilderISO
    RunnerRaine
  }

  if ($Rule -eq "run:mame" -or $Rule -eq "mame" -or $Rule -eq "run") {
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderMame
    RunnerMame
  }

  if ($Rule -eq "serve:raine") {
    While ($true) {
      BuilderSprite
      BuilderProgram
      BuilderISO
      RunnerRaine
      Watch-Folder -Path "."
      Stop-Emulators -RaineProcessName $raineProcessName -MameProcessName $mameProcessName
    }
  }

  if ($Rule -eq "serve:mame" -or $Rule -eq "serve") {
    While ($true) {
      BuilderSprite
      BuilderProgram
      BuilderISO
      BuilderMame
      RunnerMame
      Watch-Folder -Path "."
      Stop-Emulators -RaineProcessName $raineProcessName -MameProcessName $mameProcessName
    }
  }

  if ($Rule -eq "dist:iso" -or $Rule -eq "dist:raine") {
    if ((Test-Path -Path $Config.project.distPath) -eq $false) { New-Item -Path $Config.project.distPath -ItemType Directory -Force }
    BuilderSprite
    BuilderProgram
    BuilderISO
    Write-Dist `
      -ProjectName $buildConfig.projectName `
      -PathDestination "$($Config.project.distPath)\$($buildConfig.projectName)\$($buildConfig.projectName)-$($buildConfig.version)" `
      -ISOFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).iso" `
      -CUEFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).cue" `
  }

  if ($Rule -eq "dist:mame" -or $Rule -eq "dist:chd") {
    if ((Test-Path -Path $Config.project.distPath) -eq $false) { New-Item -Path $Config.project.distPath -ItemType Directory -Force }
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderMame
    Write-Dist `
      -ProjectName $buildConfig.projectName `
      -PathDestination "$($Config.project.distPath)\$($buildConfig.projectName)\$($buildConfig.projectName)-$($buildConfig.version)" `
      -CHDFile "$($buildConfig.pathMame)\roms\neocdz\$($buildConfig.projectName).chd" `
      -HashFile "$($buildConfig.pathMame)\hash\neocd.xml"
  }

  if ($Rule -eq "dist:exe") {
    if ((Test-Path -Path "$($config.project.buildPath)\tools\nsis-3.08") -eq $false) { Install-NSIS }
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderMame
    BuilderEXE
  }

  if ($Rule -eq "--version") {
    Show-Version
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

Write-Host "informations" -ForegroundColor Blue
Write-Host "Config file : $ConfigFile"

[xml]$config = (Get-Content -Path $ConfigFile)

Main -Config $config -BaseURL "http://azertyvortex.free.fr/download" -Rule $Rule
