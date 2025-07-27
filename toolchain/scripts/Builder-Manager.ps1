# Neocore
# David Vandensteen
# MIT

# TODO : externalize folders creation

param (
  [Parameter(Mandatory=$true)][String] $ConfigFile,
  [String] $Rule = "default"
)

function Main {
  param (
    [Parameter(Mandatory=$true)][String] $Rule,
    [Parameter(Mandatory=$true)][xml] $Config
  )

  Write-Host "Builder Manager" -ForegroundColor Cyan

  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\import\neocore\modules.ps1"

  if (-Not(Assert-Project -Config $Config)) {
    Write-Host "Project assertion failed" -ForegroundColor Red
    exit 1
  }

  Write-Host ""
  Write-Host "Name : $($Config.project.name)"
  Write-Host "Version : $($Config.project.version)"
  Write-Host "Makefile : $($Config.project.makefile)"
  Write-Host "Rule : $($Rule)"
  Write-Host "--------------------------------------------"
  Write-Host ""

  $manifestPath = $(Resolve-TemplatePath -Path "$($Config.project.neocorePath)\manifest.xml")
  Write-Host "Getting manifest from $manifestPath" -ForegroundColor Cyan
  [xml]$Manifest = (Get-Content -Path $manifestPath)

  if (-Not(Assert-Manifest)) {
    Write-Host "Manifest assertion failed" -ForegroundColor Red
    exit 1
  }

  if (-Not(Assert-Rule -Rule $Rule)) {
    Write-Host "Invalid rule: $Rule" -ForegroundColor Red
    exit 1
  }
  Stop-Emulators

  if ($Rule -eq "clean") {
    MakClean
    exit 0
  }

  if ($Rule -eq "clean:build") {
    MakCleanBuild
    exit 0
  }

  $spoolPath = Get-TemplatePath -Path "$($Config.project.buildPath)\spool"
  if ((Test-Path -Path $spoolPath) -eq $false) {
    New-Item -Path $spoolPath -ItemType Directory -Force
  }

  $makLogPath = Get-TemplatePath -Path "$($Config.project.buildPath)\mak.log"
  Write-Host "Starting transcript log in $makLogPath" -ForegroundColor Cyan
  Start-Transcript -Path $makLogPath -Force

  $gccPath = "..\..\build\gcc\gcc-2.95.2"
  Write-Host $gccPath

  if ($Config.project.compiler.path) { $gccPath = $Config.project.compiler.path }

  Set-EnvPath -GCCPath $gccPath -Bin "$($Config.project.buildPath)\bin"
  $env:NEODEV = "$($Config.project.buildPath)\neodev-sdk"

  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  if ((Test-Path -Path "$projectBuildPath\bin") -eq $false) { Install-SDK }

  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  if ((Test-Path -Path "$projectBuildPath\$($Config.project.name)") -eq $false) {
    New-Item -Path "$projectBuildPath\$($Config.project.name)" -ItemType Directory -Force
  }

  if ($Rule -eq "animator") { Start-Animator }
  if ($Rule -eq "framer") { Start-Framer }
  if ($Rule -eq "lib") { Build-NeocoreLib }
  if ($Rule -eq "sprite") { Build-Sprite }
  if (($Rule -eq "make") -or ($Rule -eq "") -or (!$Rule) -or ($Rule -eq "default") ) {
    if (-Not(MakDefault)) {
      Write-Host "Default build failed" -ForegroundColor Red
      exit 1
    }
  }
  if ($Rule -eq "iso") {
    if (-Not(MakISO)) {
      Write-Host "ISO build failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "run:raine" -or $Rule -eq "raine" -or $Rule -like "run:raine:*") {
    if (-Not(MakRunRaine)) {
      Write-Host "Raine run failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -like "run:mame*" -or $Rule -eq "mame" -or $Rule -eq "run") {
    if (-Not(MakRunMame)) {
      Write-Host "Mame run failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "serve:raine") {
    if (-Not(MakServeRaine)) {
      Write-Host "Raine serve failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "serve:mame" -or $Rule -eq "serve") {
    if (-Not(MakServeMame)) {
      Write-Host "Mame serve failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "dist:iso" -or $Rule -eq "dist:raine") {
    if (-Not(MakDistISO)) {
      Write-Host "ISO distribution failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "dist:mame" -or $Rule -eq "dist:chd") {
    if (-Not(MakDistMame)) {
      Write-Host "Mame distribution failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "dist:exe") {
    if (-Not(MakDistExe)) {
      Write-Host "Exe distribution failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "--version") {
    Show-Version
  }
  if ($Rule -eq "only:sprite") {
    if (-Not(Build-Sprite)) {
      Write-Host "Sprite build failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "only:program") {
    if (-Not(Build-Program)) {
      Write-Host "Program build failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "only:iso") {
    if (-Not(Build-ISO)) {
      Write-Host "ISO build failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "only:mame") {
    if (-Not(Build-Mame)) {
      Write-Host "Mame build failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "only:run") {
    if (-Not(Start-Mame)) {
      Write-Host "Mame start failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "only:run:mame") {
    if (-Not(Start-Mame)) {
      Write-Host "Mame start failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "only:run:raine") {
    if (-Not(Start-Raine)) {
      Write-Host "Raine start failed" -ForegroundColor Red
      return $false
    }
  }

  # All operations completed successfully
  return $true
}

if ((Test-Path -Path $ConfigFile) -eq $false) {
  Write-Host "Config $ConfigFile not found" -ForegroundColor Red
  return 1
}

Write-Host "informations" -ForegroundColor Blue
Write-Host "Config file : $ConfigFile"

# FIX: Safe XML parsing with error handling
try {
  [xml]$config = (Get-Content -Path $ConfigFile)
} catch {
  Write-Host "Invalid XML configuration file: $ConfigFile" -ForegroundColor Red
  Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
  return 1
}

$mainResult = Main -Config $config -Rule $Rule
if ($mainResult -eq $false) {
  Write-Host "Build manager process failed" -ForegroundColor Red
  exit 1
}

Write-Host "Build manager process completed successfully" -ForegroundColor Green
exit 0
