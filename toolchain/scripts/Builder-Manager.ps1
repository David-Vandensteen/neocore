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

  # Set global variable for neocore path before importing modules
  $global:neocorePathAbs = $Config.project.neocorePath
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\import\neocore\modules.ps1"

  if (-Not(Assert-Project -Config $Config)) {
    Write-Host "Project assertion failed" -ForegroundColor Red
    return $false
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
  $global:Manifest = [xml](Get-Content -Path $manifestPath)

  if (-Not(Assert-Manifest)) {
    Write-Host "Manifest assertion failed" -ForegroundColor Red
    return $false
  }

  if (-Not(Assert-Rule -Rule $Rule)) {
    Write-Host "Invalid rule: $Rule" -ForegroundColor Red
    return $false
  }
  if (-not (Stop-Emulators)) {
    Write-Host "Warning: Failed to stop emulators" -ForegroundColor Yellow
    # Continue anyway as this is not critical
  }

  if ($Rule -eq "clean") {
    if (-not (MakClean)) {
      Write-Host "Clean operation failed" -ForegroundColor Red
      return $false
    }
    return $true
  }

  if ($Rule -eq "clean:build") {
    if (-not (MakCleanBuild)) {
      Write-Host "Clean build operation failed" -ForegroundColor Red
      return $false
    }
    return $true
  }

  $spoolPath = Get-TemplatePath -Path "$($Config.project.buildPath)\spool"
  if ((Test-Path -Path $spoolPath) -eq $false) {
    New-Item -Path $spoolPath -ItemType Directory -Force
  }

  $makLogPath = Get-TemplatePath -Path "$($Config.project.buildPath)\mak.log"
  Write-Host "Starting transcript log in $makLogPath" -ForegroundColor Cyan
  Start-Transcript -Path $makLogPath -Force | Out-Null

  $gccPath = "..\..\build\gcc\gcc-2.95.2"
  Write-Host $gccPath

  if ($Config.project.compiler.path) { $gccPath = $Config.project.compiler.path }

  if (-not (Set-EnvPath -GCCPath $gccPath -Bin "$($Config.project.buildPath)\bin")) {
    Write-Host "Environment path setup failed" -ForegroundColor Red
    return $false
  }
  $env:NEODEV = "$($Config.project.buildPath)\neodev-sdk"

  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $sdkComplete = $true

  # Check if SDK is complete by verifying key components
  if (-not (Test-Path -Path "$projectBuildPath\bin")) {
    $sdkComplete = $false
  } elseif (-not (Test-Path -Path "$projectBuildPath\manifest.xml")) {
    $sdkComplete = $false
    Write-Host "Warning: SDK appears incomplete (missing manifest.xml)" -ForegroundColor Yellow
  }

  if (-not $sdkComplete) {
    Write-Host "Installing SDK..." -ForegroundColor Cyan
    if (-not (Install-SDK)) {
      Write-Host "SDK installation failed" -ForegroundColor Red
      return $false
    }
  }

  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  if ((Test-Path -Path "$projectBuildPath\$($Config.project.name)") -eq $false) {
    New-Item -Path "$projectBuildPath\$($Config.project.name)" -ItemType Directory -Force
  }

  if ($Rule -eq "animator") {
    if (-not (Start-Animator)) {
      Write-Host "Animator start failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "framer") {
    if (-not (Start-Framer)) {
      Write-Host "Framer start failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "lib") {
    if (-not (Build-NeocoreLib)) {
      Write-Host "Neocore library build failed" -ForegroundColor Red
      return $false
    }
  }
  if ($Rule -eq "sprite") {
    if (-not (Build-Sprite)) {
      Write-Host "Sprite build failed" -ForegroundColor Red
      return $false
    }
    return $true
  }
  if (($Rule -eq "make") -or ($Rule -eq "") -or (!$Rule) -or ($Rule -eq "default") ) {
    if (-Not(MakDefault)) {
      Write-Host "Default build failed" -ForegroundColor Red
      return $false
    }
    return $true
  }
  if ($Rule -eq "run:raine" -or $Rule -eq "raine" -or $Rule -like "run:raine:*") {
    if (-Not(MakRunRaine)) {
      Write-Host "Raine run failed" -ForegroundColor Red
      return $false
    }
    return $true
  }
  if ($Rule -like "run:mame*" -or $Rule -eq "mame" -or $Rule -eq "run") {
    if (-Not(MakRunMame)) {
      Write-Host "Mame run failed" -ForegroundColor Red
      return $false
    }
    return $true
  }
  if ($Rule -eq "serve:raine") {
    if (-Not(MakServeRaine)) {
      Write-Host "Raine serve failed" -ForegroundColor Red
      return $false
    }
    return $true
  }
  if ($Rule -eq "serve:mame" -or $Rule -eq "serve") {
    if (-Not(MakServeMame)) {
      Write-Host "Mame serve failed" -ForegroundColor Red
      return $false
    }
    return $true
  }
  if ($Rule -eq "dist:iso" -or $Rule -eq "dist:raine") {
    if (-Not(MakDistISO)) {
      Write-Host "ISO distribution failed" -ForegroundColor Red
      return $false
    }
    return $true
  }
  if ($Rule -eq "dist:mame" -or $Rule -eq "dist:chd") {
    if (-Not(MakDistMame)) {
      Write-Host "Mame distribution failed" -ForegroundColor Red
      return $false
    }
    return $true
  }
  if ($Rule -eq "dist:exe") {
    if (-Not(MakDistExe)) {
      Write-Host "Exe distribution failed" -ForegroundColor Red
      return $false
    }
    return $true
  }
  if ($Rule -eq "--version") {
    Show-Version
    return $true
  }
  if ($Rule -eq "only:sprite") {
    if (-Not(Build-Sprite)) {
      Write-Host "Sprite build failed" -ForegroundColor Red
      return $false
    }
    return $true
  }
  if ($Rule -eq "only:program") {
    if (-Not(Build-Program)) {
      Write-Host "Program build failed" -ForegroundColor Red
      return $false
    }
    return $true
  }
  if ($Rule -eq "only:mame") {
    if (-Not(Build-Mame)) {
      Write-Host "Mame build failed" -ForegroundColor Red
      return $false
    }
    return $true
  }
  if ($Rule -eq "only:run") {
    if (-Not(Start-Mame)) {
      Write-Host "Mame start failed" -ForegroundColor Red
      return $false
    }
    return $true
  }
  if ($Rule -eq "only:run:mame") {
    if (-Not(Start-Mame)) {
      Write-Host "Mame start failed" -ForegroundColor Red
      return $false
    }
    return $true
  }
  if ($Rule -eq "only:run:raine") {
    if (-Not(Start-Raine)) {
      Write-Host "Raine start failed" -ForegroundColor Red
      return $false
    }
    return $true
  }

  # All operations completed successfully
  return $true
}

if ((Test-Path -Path $ConfigFile) -eq $false) {
  Write-Host "Config $ConfigFile not found" -ForegroundColor Red
  return 1
}

Write-Host "informations" -ForegroundColor Cyan
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
if (-not $mainResult) {
  Write-Host "Build manager process failed" -ForegroundColor Red
  exit 1
}
