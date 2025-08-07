param (
  [Parameter(Mandatory=$true)]
  [string]$ProjectSrcPath,

  [Parameter(Mandatory=$true)]
  [string]$ProjectNeocorePath
)

# Initialize logging
$global:MigrationLogPath = "$ProjectSrcPath\..\migration.log"

# Display log path for debugging
Write-Host "Migration log will be written to: $global:MigrationLogPath" -ForegroundColor Cyan

# Test log file creation immediately
try {
  "=== Migration Log Test ===" | Out-File -FilePath $global:MigrationLogPath -Encoding UTF8
  Write-Host "Log file test: SUCCESS - File created at $global:MigrationLogPath" -ForegroundColor Green
} catch {
  Write-Host "Log file test: FAILED - Cannot create file at $global:MigrationLogPath" -ForegroundColor Red
  Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
  exit 1
}

function Write-MigrationLog {
  param(
    [string]$Message,
    [string]$Level = "INFO"
  )
  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  $logEntry = "[$timestamp] [$Level] $Message"

  # Only write to log file (no console output for logs)
  try {
    # Ensure the parent directory exists
    $logDir = Split-Path -Parent $global:MigrationLogPath
    if (-not (Test-Path -Path $logDir)) {
      New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }

    $logEntry | Out-File -FilePath $global:MigrationLogPath -Append -Encoding UTF8
  } catch {
    Write-Host "Warning: Could not write to log file '$global:MigrationLogPath': $($_.Exception.Message)" -ForegroundColor Yellow
  }
}

function Show-Error {
  param ($message)
  Write-MigrationLog -Message "FATAL: $message" -Level "ERROR"
  exit 1
}

function Show-MigrationWarning {
  param(
    [string]$ProjectSrcPath,
    [string]$ProjectNeocorePath,
    [string]$CurrentVersion,
    [string]$TargetVersion,
    [array]$DetectedIssues,
    [string]$BackupPath = ""
  )

  Write-MigrationLog -Message "Displaying migration warning to user" -Level "INFO"
  Write-MigrationLog -Message "Migration details - Current: $CurrentVersion, Target: $TargetVersion, Issues count: $($DetectedIssues.Count)" -Level "INFO"

  Write-Host ""
  Write-Host "================================================================" -ForegroundColor Yellow
  Write-Host "                    [WARNING] MIGRATION ALERT [WARNING]         " -ForegroundColor Red
  Write-Host "================================================================" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "This script will perform an automatic migration of your NeoCore project." -ForegroundColor White
  Write-Host ""
  Write-Host "[PROJECT] PROJECT TO MIGRATE:" -ForegroundColor Cyan
  Write-Host "   * Source folder: $ProjectSrcPath" -ForegroundColor Gray
  Write-Host "   * NeoCore folder: $ProjectNeocorePath" -ForegroundColor Gray
  Write-Host ""
  Write-Host "[VERSION] MIGRATION:" -ForegroundColor Cyan
  Write-Host "   * Current version: $CurrentVersion" -ForegroundColor Gray
  Write-Host "   * Target version: $TargetVersion" -ForegroundColor Gray
  Write-Host ""

  if ($DetectedIssues -and $DetectedIssues.Count -gt 0) {
    Write-Host "[CHANGES] PROJECT.XML WILL BE UPDATED WITH:" -ForegroundColor Cyan
    foreach ($issue in $DetectedIssues) {
      Write-Host "   * $issue" -ForegroundColor Gray
    }
    Write-Host ""
  }

  Write-Host "[BACKUP] AUTOMATIC BACKUPS:" -ForegroundColor Green
  if ($BackupPath -and $BackupPath -ne "") {
    Write-Host "   * Complete project -> $BackupPath" -ForegroundColor Gray
    Write-MigrationLog -Message "Backup path displayed to user: $BackupPath" -Level "INFO"
  } else {
    Write-Host "   * Complete project -> %TEMP%\[UUID] (will be created)" -ForegroundColor Gray
    Write-MigrationLog -Message "Backup path template displayed to user: %TEMP%\[UUID] (will be created)" -Level "INFO"
  }
  Write-Host ""
  Write-Host "[SAFETY] RECOMMENDED ACTIONS BEFORE MIGRATION:" -ForegroundColor Red
  Write-Host "   1. Backup your ENTIRE project to another folder" -ForegroundColor Yellow
  Write-Host "   2. Close your editor/IDE before continuing" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "[CRITICAL] IMPORTANT: This migration will permanently modify your files!" -ForegroundColor Red
  Write-Host "           Automatic backups do not replace a complete project backup." -ForegroundColor Red
  Write-Host ""
  Write-Host "================================================================" -ForegroundColor Yellow

  do {
    Write-Host ""
    Write-MigrationLog -Message "Prompting user for migration confirmation" -Level "INFO"
    $confirmation = Read-Host "Do you want to continue with the migration? (Y/N)"
    $confirmation = $confirmation.Trim()
    Write-MigrationLog -Message "User input received: '$confirmation'" -Level "INFO"

    if ($confirmation -eq "Y" -or $confirmation -eq "y") {
      Write-MigrationLog -Message "User confirmed migration continuation" -Level "INFO"
      return $true
    } elseif ($confirmation -eq "N" -or $confirmation -eq "n") {
      Write-MigrationLog -Message "User cancelled migration" -Level "INFO"
      Write-Host ""
      Write-Host "Migration cancelled by user." -ForegroundColor Yellow
      Write-Host "No modifications have been made." -ForegroundColor Green
      return $false
    } else {
      Write-MigrationLog -Message "Invalid user input: '$confirmation', requesting Y/N again" -Level "WARN"
      Write-Host "Please answer 'Y' or 'N'." -ForegroundColor Red
    }
  } while ($true)
}

function Test-ProjectXmlV3Compatibility {
  param (
    [Parameter(Mandatory=$true)]
    [xml]$ProjectXml,
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath
  )

  Write-MigrationLog -Message "Starting v3 compatibility analysis..." -Level "INFO"
  $issues = @()
  $warnings = @()

  # Check for missing platform element (v3 requirement)
  Write-MigrationLog -Message "Checking for platform element..." -Level "INFO"
  $platformNode = $ProjectXml.SelectSingleNode("//platform")
  if (-not $platformNode) {
    $issues += "Add <platform> element if missing - required for v3 compatibility"
    Write-MigrationLog -Message "Issue detected: Missing platform element" -Level "WARN"
  } elseif ([string]::IsNullOrWhiteSpace($platformNode.InnerText)) {
    $issues += "Update <platform> element - should specify target platform (e.g., 'cd')"
    Write-MigrationLog -Message "Issue detected: Empty platform element" -Level "WARN"
  } else {
    Write-MigrationLog -Message "Platform element found: '$($platformNode.InnerText)'" -Level "INFO"
  }

  # Check for missing DAT setup elements (v3 requirements)
  Write-MigrationLog -Message "Checking DAT setup elements..." -Level "INFO"
  $datSetupNode = $ProjectXml.SelectSingleNode("//DAT//chardata//setup")
  if ($datSetupNode) {
    Write-MigrationLog -Message "DAT setup node found, checking required elements..." -Level "INFO"
    $requiredDatElements = @("charfile", "mapfile", "palfile", "incfile", "incprefix")
    $missingDatElements = @()

    foreach ($elementName in $requiredDatElements) {
      $existingElement = $datSetupNode.SelectSingleNode($elementName)
      if (-not $existingElement) {
        $missingDatElements += $elementName
        Write-MigrationLog -Message "Missing DAT element: $elementName" -Level "WARN"
      } else {
        Write-MigrationLog -Message "Found DAT element: $elementName = '$($existingElement.InnerText)'" -Level "INFO"
      }
    }

    if ($missingDatElements.Count -gt 0) {
      $issues += "Add DAT setup elements if missing: $($missingDatElements -join ', ') - required for v3 DAT processing"
      Write-MigrationLog -Message "Issue detected: Missing DAT elements: $($missingDatElements -join ', ')" -Level "WARN"
    }
  } else {
    Write-MigrationLog -Message "No DAT setup node found" -Level "INFO"
  }

  # Check for missing fixdata section (v3 requirement)
  Write-MigrationLog -Message "Checking fixdata section..." -Level "INFO"
  $datNode = $ProjectXml.SelectSingleNode("//DAT")
  if ($datNode) {
    $fixdataNode = $datNode.SelectSingleNode("fixdata")
    if (-not $fixdataNode) {
      $issues += "Add fixdata section if missing - required for v3 fix font processing"
      Write-MigrationLog -Message "Issue detected: Missing fixdata section" -Level "WARN"
    } else {
      Write-MigrationLog -Message "Fixdata section found" -Level "INFO"
    }
  } else {
    Write-MigrationLog -Message "No DAT node found" -Level "INFO"
  }

  # Check for missing RAINE config section (v3 requirement)
  Write-MigrationLog -Message "Checking RAINE configuration..." -Level "INFO"
  $raineNode = $ProjectXml.SelectSingleNode("//emulator/raine")
  if ($raineNode) {
    $configNode = $raineNode.SelectSingleNode("config")
    if (-not $configNode) {
      $issues += "Add RAINE config section if missing - required for v3 emulator configurations"
      Write-MigrationLog -Message "Issue detected: Missing RAINE config section" -Level "WARN"
    } else {
      Write-MigrationLog -Message "RAINE config section found" -Level "INFO"
    }
  } else {
    Write-MigrationLog -Message "No RAINE emulator node found" -Level "INFO"
  }

  # Check for missing MAME profile section (v3 requirement)
  Write-MigrationLog -Message "Checking MAME configuration..." -Level "INFO"
  $mameNode = $ProjectXml.SelectSingleNode("//emulator/mame")
  if ($mameNode) {
    $profileNode = $mameNode.SelectSingleNode("profile")
    if (-not $profileNode) {
      $issues += "Add MAME profile section if missing - required for v3 emulator configurations"
      Write-MigrationLog -Message "Issue detected: Missing MAME profile section" -Level "WARN"
    } else {
      Write-MigrationLog -Message "MAME profile section found" -Level "INFO"
    }
  } else {
    Write-MigrationLog -Message "No MAME emulator node found" -Level "INFO"
  }

  # Check for missing compiler elements (v3 requirements)
  Write-MigrationLog -Message "Checking compiler configuration..." -Level "INFO"
  $compilerNode = $ProjectXml.SelectSingleNode("//compiler")
  if ($compilerNode) {
    $crtPathNode = $compilerNode.SelectSingleNode("crtPath")
    if (-not $crtPathNode) {
      $issues += "Add compiler <crtPath> element if missing - required for v3 compilation"
      Write-MigrationLog -Message "Issue detected: Missing compiler crtPath element" -Level "WARN"
    } else {
      Write-MigrationLog -Message "Compiler crtPath found: '$($crtPathNode.InnerText)'" -Level "INFO"
    }

    # Check systemFile structure (v3 format)
    $systemFileNode = $compilerNode.SelectSingleNode("systemFile")
    if (-not $systemFileNode) {
      $issues += "Add systemFile section if missing - required for v3 compilation"
      Write-MigrationLog -Message "Issue detected: Missing systemFile section" -Level "WARN"
    } else {
      Write-MigrationLog -Message "SystemFile section found, checking cd/cartridge elements..." -Level "INFO"
      $cdNode = $systemFileNode.SelectSingleNode("cd")
      $cartridgeNode = $systemFileNode.SelectSingleNode("cartridge")
      if (-not $cdNode -or -not $cartridgeNode) {
        $issues += "Update systemFile structure to v3 format (add cd/cartridge elements if missing)"
        Write-MigrationLog -Message "Issue detected: SystemFile missing cd/cartridge elements" -Level "WARN"
      } else {
        Write-MigrationLog -Message "SystemFile cd and cartridge elements found" -Level "INFO"
      }
    }
  } else {
    Write-MigrationLog -Message "No compiler node found" -Level "INFO"
  }

  # Note: With complete rewrite approach, most legacy pattern detection is unnecessary
  # The new v3 template will automatically use the correct structure and paths

  Write-MigrationLog -Message "Compatibility analysis completed: $($issues.Count) issues, $($warnings.Count) warnings" -Level "INFO"
  if ($issues.Count -gt 0) {
    Write-MigrationLog -Message "Detected issues: $($issues -join '; ')" -Level "WARN"
  }
  if ($warnings.Count -gt 0) {
    Write-MigrationLog -Message "Detected warnings: $($warnings -join '; ')" -Level "WARN"
  }

  return @{
    Issues = $issues
    Warnings = $warnings
    IsCompatible = ($issues.Count -eq 0)
  }
}

function Repair-ProjectXmlForV3 {
  param (
    [Parameter(Mandatory=$true)]
    [xml]$ProjectXml,
    [Parameter(Mandatory=$true)]
    [string]$ProjectXmlPath
  )

  # Rewrite project.xml with v3 template structure (skip all incremental changes)
  Write-MigrationLog -Message "Starting project.xml rewrite with v3 template structure" -Level "INFO"
  Write-Host "  - Rewriting project.xml with v3 template structure..." -ForegroundColor Yellow

  # Get existing values to preserve user data
  Write-MigrationLog -Message "Extracting existing project data for preservation" -Level "INFO"
  $existingName = ""
  $existingVersion = "1.0.0"
  $existingNeocorePath = "..\neocore"
  $existingMakefile = "..\Makefile"
  $existingBuildPath = "{{neocore}}\build"
  $existingDistPath = "{{neocore}}\dist"
  $existingCompilerPath = "{{build}}\gcc\gcc-2.95.2"
  $existingIncludePath = "{{neocore}}\src-lib\include"
  $existingLibraryPath = "{{build}}\lib"
  $existingRaineExe = "{{build}}\raine\raine32.exe"
  $existingMameExe = "{{build}}\mame\mame64.exe"

  $nameNode = $ProjectXml.SelectSingleNode("//name")
  if ($nameNode) {
    $existingName = $nameNode.InnerText
    Write-MigrationLog -Message "Preserving project name: $existingName" -Level "INFO"
  }

  $versionNode = $ProjectXml.SelectSingleNode("//version")
  if ($versionNode) {
    $existingVersion = $versionNode.InnerText
    Write-MigrationLog -Message "Preserving project version: $existingVersion" -Level "INFO"
  }

  $neocorePathNode = $ProjectXml.SelectSingleNode("//neocorePath")
  if ($neocorePathNode) {
    $existingNeocorePath = $neocorePathNode.InnerText
    Write-MigrationLog -Message "Preserving neocorePath: $existingNeocorePath" -Level "INFO"
  }

  $makefileNode = $ProjectXml.SelectSingleNode("//makefile")
  if ($makefileNode) {
    $existingMakefile = $makefileNode.InnerText
    Write-MigrationLog -Message "Preserving makefile path: $existingMakefile" -Level "INFO"
  }

  # Preserve existing paths if they exist
  $buildPathNode = $ProjectXml.SelectSingleNode("//buildPath")
  if ($buildPathNode) {
    $existingBuildPath = $buildPathNode.InnerText
    Write-MigrationLog -Message "Preserving buildPath: $existingBuildPath" -Level "INFO"
  }

  $distPathNode = $ProjectXml.SelectSingleNode("//distPath")
  if ($distPathNode) {
    $existingDistPath = $distPathNode.InnerText
    Write-MigrationLog -Message "Preserving distPath: $existingDistPath" -Level "INFO"
  }

  $compilerPathNode = $ProjectXml.SelectSingleNode("//compiler/path")
  if ($compilerPathNode) {
    $existingCompilerPath = $compilerPathNode.InnerText
    Write-MigrationLog -Message "Preserving compiler path: $existingCompilerPath" -Level "INFO"
  }

  $includePathNode = $ProjectXml.SelectSingleNode("//compiler/includePath")
  if ($includePathNode) { $existingIncludePath = $includePathNode.InnerText }

  # Force includePath to v3 standard value (always use template)
  $existingIncludePath = "{{neocore}}\src-lib\include"
  Write-MigrationLog -Message "Forcing includePath to v3 standard: $existingIncludePath" -Level "INFO"

  $libraryPathNode = $ProjectXml.SelectSingleNode("//compiler/libraryPath")
  if ($libraryPathNode) {
    $existingLibraryPath = $libraryPathNode.InnerText
    Write-MigrationLog -Message "Preserving libraryPath: $existingLibraryPath" -Level "INFO"
  }

  $raineExeNode = $ProjectXml.SelectSingleNode("//emulator/raine/exeFile")
  if ($raineExeNode) {
    $existingRaineExe = $raineExeNode.InnerText
    Write-MigrationLog -Message "Preserving RAINE executable: $existingRaineExe" -Level "INFO"
  }

  $mameExeNode = $ProjectXml.SelectSingleNode("//emulator/mame/exeFile")
  if ($mameExeNode) {
    $existingMameExe = $mameExeNode.InnerText
    Write-MigrationLog -Message "Preserving MAME executable: $existingMameExe" -Level "INFO"
  }

  # Create completely new v3 structure
  $newXmlContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<project>
  <name>$existingName</name>
  <version>$existingVersion</version>
  <platform>cd</platform>
  <makefile>$existingMakefile</makefile>
  <neocorePath>$existingNeocorePath</neocorePath>
  <buildPath>$existingBuildPath</buildPath>
  <distPath>$existingDistPath</distPath>
  <gfx>
    <DAT>
      <chardata>
        <setup>
          <starting_tile>256</starting_tile>
          <charfile>out\char.bin</charfile>
          <mapfile>out\charMaps.s</mapfile>
          <palfile>out\charPals.s</palfile>
          <incfile>out\charInclude.h</incfile>
          <incprefix>../</incprefix>
        </setup>
        <pict id="logo">
          <file>assets\gfx\logo.png</file>
        </pict>
      </chardata>
      <fixdata>
        <chardata>
          <setup fileType="fix">
            <charfile>out\fix.bin</charfile>
            <palfile>out\fixPals.s</palfile>
            <incfile>out\fixData.h</incfile>
          </setup>
          <import bank="0">
            <file>{{build}}\fix\systemFont.bin</file>
          </import>
        </chardata>
      </fixdata>
    </DAT>
  </gfx>
  <emulator>
    <raine>
      <exeFile>$existingRaineExe</exeFile>
      <config>
        <!-- To use a named config, use mak run:raine:<configName>.
        Example: mak run:raine:full to run RAINE in fullscreen.
        You can add more custom configs. -->
        <default>{{build}}\raine\config\default.cfg</default>
        <full>{{build}}\raine\config\fullscreen.cfg</full>
        <yuv>{{build}}\raine\config\yuv.cfg</yuv>
      </config>
    </raine>
    <mame>
      <exeFile>$existingMameExe</exeFile>
      <profile>
        <!-- To use a named profile, use mak run:mame:<profileName>.
        Example: mak run:mame:full to run MAME in fullscreen.
        You can add more custom profiles. -->
        <default>-window -skip_gameinfo neocdz</default>
        <full>-nowindow -skip_gameinfo neocdz</full>
        <nosound>-sound none -window -skip_gameinfo neocdz</nosound>
        <debug>-debug -window -skip_gameinfo neocdz</debug>
      </profile>
    </mame>
  </emulator>
  <compiler>
    <name>gcc</name>
    <version>2.95.2</version>
    <path>$existingCompilerPath</path>
    <includePath>$existingIncludePath</includePath>
    <libraryPath>$existingLibraryPath</libraryPath>
    <crtPath>{{neocore}}\src-lib\crt</crtPath>
    <systemFile>
      <cd>{{neocore}}\src-lib\system\neocd.x</cd>
      <cartridge>{{neocore}}\src-lib\system\neocart.x</cartridge>
    </systemFile>
  </compiler>
</project>
"@

  # Write the new content to file
  try {
    Write-MigrationLog -Message "Writing new v3 project.xml structure to file" -Level "INFO"
    $newXmlContent | Out-File -FilePath $ProjectXmlPath -Encoding UTF8 -Force
    Write-MigrationLog -Message "Successfully wrote v3 project.xml with preserved user data" -Level "SUCCESS"

    # Post-generation validation with Assert-Project
    Write-MigrationLog -Message "Validating generated project.xml with Assert-Project module" -Level "INFO"
    try {
      # Load the generated XML for validation
      [xml]$generatedXml = Get-Content -Path $ProjectXmlPath

      # Determine NeoCore path for Assert modules
      $resolvedNeocorePath = if ($existingNeocorePath -like "*neocore*") {
        if ([System.IO.Path]::IsPathRooted($existingNeocorePath)) {
          $existingNeocorePath
        } else {
          Resolve-Path -Path (Join-Path (Split-Path -Parent $ProjectXmlPath) $existingNeocorePath) -ErrorAction SilentlyContinue
        }
      } else { $null }

      if ($resolvedNeocorePath -and (Test-Path -Path $resolvedNeocorePath)) {
        Write-MigrationLog -Message "Resolved NeoCore path: $resolvedNeocorePath" -Level "INFO"

        # Load Assert modules directly (no function due to PowerShell scope issues)
        $assertPath = Join-Path $resolvedNeocorePath "toolchain\scripts\modules\assert"
        Write-MigrationLog -Message "Loading Assert modules from: $assertPath" -Level "INFO"

        if (Test-Path -Path $assertPath) {
          $modules = @("path.ps1", "project\name.ps1", "project\gfx\dat.ps1", "project\compiler\systemFile.ps1", "project.ps1")
          $loadedCount = 0

          foreach ($module in $modules) {
            $fullPath = Join-Path $assertPath $module
            if (Test-Path $fullPath) {
              try {
                . $fullPath
                $loadedCount++
                Write-MigrationLog -Message "Loaded Assert module: $module" -Level "INFO"
              } catch {
                Write-MigrationLog -Message "Error loading $module : $($_.Exception.Message)" -Level "ERROR"
              }
            } else {
              Write-MigrationLog -Message "Assert module not found: $fullPath" -Level "WARN"
            }
          }

          Write-MigrationLog -Message "Loaded $loadedCount/$($modules.Count) Assert modules" -Level "INFO"

          # Test and execute Assert-Project validation
          if (Get-Command "Assert-Project" -ErrorAction SilentlyContinue) {
            Write-MigrationLog -Message "Assert-Project function is available, validating XML..." -Level "SUCCESS"

            try {
              Assert-Project -Config $generatedXml
              Write-MigrationLog -Message "[OK] Generated project.xml passed Assert-Project validation" -Level "SUCCESS"
              Write-Host "  - Generated XML validated with Assert-Project" -ForegroundColor Green
            } catch {
              Write-MigrationLog -Message "Assert-Project validation failed: $($_.Exception.Message)" -Level "WARN"
              Write-Host "  - Warning: Assert-Project validation failed: $($_.Exception.Message)" -ForegroundColor Yellow
            }
          } else {
            Write-MigrationLog -Message "Assert-Project function not available after module loading" -Level "WARN"
            Write-Host "  - Warning: Assert-Project function not available - skipping validation" -ForegroundColor Yellow
          }
        } else {
          Write-MigrationLog -Message "Assert modules path not found: $assertPath" -Level "WARN"
          Write-Host "  - Warning: Assert modules not found - skipping validation" -ForegroundColor Yellow
        }
      } else {
        Write-MigrationLog -Message "NeoCore path not resolved ($existingNeocorePath) - skipping Assert-Project validation" -Level "WARN"
        Write-Host "  - Warning: NeoCore path not resolved - skipping validation" -ForegroundColor Yellow
      }
    } catch {
      Write-MigrationLog -Message "Error during Assert-Project validation: $($_.Exception.Message)" -Level "WARN"
      Write-Host "  - Warning: Could not validate with Assert-Project: $($_.Exception.Message)" -ForegroundColor Yellow
    }

    Write-Host "  - Project.xml rewritten with complete v3 structure" -ForegroundColor Green
    Write-Host "  - Preserved existing name: '$existingName'" -ForegroundColor Green
    Write-Host "  - Preserved existing version: '$existingVersion'" -ForegroundColor Green
    Write-Host "  - Preserved existing neocorePath: '$existingNeocorePath'" -ForegroundColor Green
    Write-Host "  - Preserved existing buildPath: '$existingBuildPath'" -ForegroundColor Green
    Write-Host "  - Preserved existing compiler paths" -ForegroundColor Green
    return $true
  } catch {
    Write-MigrationLog -Message "Error writing project.xml: $($_.Exception.Message)" -Level "ERROR"
    Write-Host "  - Error rewriting project.xml: $($_.Exception.Message)" -ForegroundColor Red
    return $false
  }
}

function Update-ProjectManifestVersion {
  param (
    [Parameter(Mandatory=$true)]
    [string]$ProjectManifestPath,
    [Parameter(Mandatory=$true)]
    [string]$NewVersion
  )

  Write-MigrationLog -Message "Updating project manifest version to $NewVersion" -Level "INFO"

  if (Test-Path -Path $ProjectManifestPath) {
    try {
      [xml]$projectManifest = Get-Content -Path $ProjectManifestPath
      $oldVersion = $projectManifest.manifest.version
      Write-MigrationLog -Message "Current manifest version: $oldVersion" -Level "INFO"

      if ($oldVersion -ne $NewVersion) {
        # Update version
        $projectManifest.manifest.version = $NewVersion
        $projectManifest.Save($ProjectManifestPath)

        Write-MigrationLog -Message "Updated manifest version: $oldVersion -> $NewVersion" -Level "SUCCESS"
        Write-Host "  - Updated project manifest.xml version: $oldVersion to $NewVersion" -ForegroundColor Green
        return $true
      } else {
        Write-MigrationLog -Message "Manifest version already up to date ($NewVersion)" -Level "INFO"
        Write-Host "  - Project manifest.xml version is already up to date ($NewVersion)" -ForegroundColor Green
        return $false
      }
    } catch {
      Write-MigrationLog -Message "Error updating project manifest: $($_.Exception.Message)" -Level "ERROR"
      Write-Host "Warning: Could not update project manifest.xml: $($_.Exception.Message)" -ForegroundColor Yellow
      return $false
    }
  } else {
    Write-MigrationLog -Message "Project manifest.xml not found at $ProjectManifestPath" -Level "ERROR"
    Write-Host "Warning: Project manifest.xml not found at $ProjectManifestPath" -ForegroundColor Yellow
    return $false
  }
}

# Read version from manifest.xml
$manifestPath = Resolve-Path -Path "..\..\..\manifest.xml"
if (-Not(Test-Path -Path $manifestPath)) {
  Show-Error "manifest.xml not found at $manifestPath"
}

try {
  [xml]$manifestXml = Get-Content -Path $manifestPath
  $version = $manifestXml.manifest.version
  Write-Host "Neocore version: $version" -ForegroundColor Green
} catch {
  Show-Error "Failed to read version from manifest.xml: $($_.Exception.Message)"
}

if (Test-Path -Path $ProjectNeocorePath) {
  $srcLib = Resolve-Path -Path "..\..\..\src-lib"
  $toolchain = Resolve-Path -Path "..\..\..\toolchain"
  $manifest = Resolve-Path -Path "..\..\..\manifest.xml"

  if (-Not(Test-Path -Path $srcLib)) { Show-Error "$srcLib not found" }
  if (-Not(Test-Path -Path $toolchain)) { Show-Error "$toolchain not found" }
  if (-Not(Test-Path -Path $manifest)) { Show-Error "$manifest not found" }

  if (-Not(Test-Path -Path "$ProjectNeocorePath\src-lib")) { Show-Error "$ProjectNeocorePath\src-lib not found" }
  if (-Not(Test-Path -Path "$ProjectNeocorePath\toolchain")) { Show-Error "$ProjectNeocorePath\toolchain not found" }

  try {
    robocopy /MIR "$srcLib" "$ProjectNeocorePath\src-lib"
    Copy-Item -Path $manifest -Destination $ProjectNeocorePath -Force
    robocopy /MIR "$toolchain" "$ProjectNeocorePath\toolchain"
    Write-Host "files copied successfully to $ProjectNeocorePath"
  } catch {
    Show-Error "failed to copy some files"
  }
} else {
  Show-Error "$ProjectNeocorePath not found"
}

if (Test-Path -Path $ProjectSrcPath) {
  $makBat = Resolve-Path -Path "..\..\..\bootstrap\standalone\mak.bat"
  $makPs1 = Resolve-Path -Path "..\..\..\bootstrap\standalone\mak.ps1"

  try {
    Copy-Item -Path $makBat -Destination $ProjectSrcPath -Force
    Copy-Item -Path $makPs1 -Destination $ProjectSrcPath -Force
    Write-Host "files copied successfully to $ProjectSrcPath"
  } catch {
    Show-Error "failed to copy some files"
  }
} else {
  Show-Error "$ProjectSrcPath not found"
}

# Project XML Migration Logic
$projectXmlPath = "$ProjectSrcPath\project.xml"
$projectManifestPath = "$ProjectSrcPath\..\manifest.xml"

# Initialize migration logging
Write-MigrationLog -Message "=== NeoCore v2->v3 Migration Started ===" -Level "INFO"
Write-MigrationLog -Message "Project source path: $ProjectSrcPath" -Level "INFO"
Write-MigrationLog -Message "NeoCore path: $ProjectNeocorePath" -Level "INFO"
Write-MigrationLog -Message "Project XML: $projectXmlPath" -Level "INFO"
Write-MigrationLog -Message "Project manifest: $projectManifestPath" -Level "INFO"

if (Test-Path -Path $projectXmlPath) {
  Write-MigrationLog -Message "Found project.xml, analyzing for v3 migration..." -Level "INFO"

  # Preliminary analysis to determine migration needs
  Write-MigrationLog -Message "Starting preliminary analysis to determine migration needs..." -Level "INFO"
  $projectNeocoreVersion = "Unknown"
  $migrationRequired = $false
  $detectedIssues = @()

  Write-MigrationLog -Message "Checking for project manifest at: $projectManifestPath" -Level "INFO"
  if (Test-Path -Path $projectManifestPath) {
    Write-MigrationLog -Message "Project manifest found, reading version information..." -Level "INFO"
    try {
      [xml]$manifestXml = Get-Content -Path $projectManifestPath
      $versionNode = $manifestXml.SelectSingleNode("//neocore")
      if ($versionNode -and $versionNode.version) {
        $projectNeocoreVersion = $versionNode.version
        Write-MigrationLog -Message "Found project manifest with NeoCore version: $projectNeocoreVersion" -Level "INFO"
      } else {
        Write-MigrationLog -Message "Project manifest found but no neocore version node detected" -Level "WARN"
      }
    } catch {
      Write-MigrationLog -Message "Error reading project manifest: $($_.Exception.Message)" -Level "WARN"
    }
  } else {
    Write-MigrationLog -Message "Project manifest not found at $projectManifestPath" -Level "WARN"
  }

  # Quick compatibility check to determine what needs to be done
  Write-MigrationLog -Message "Performing compatibility check on project.xml..." -Level "INFO"
  try {
    [xml]$projectXml = Get-Content -Path $projectXmlPath
    Write-MigrationLog -Message "Project.xml loaded successfully, running compatibility test..." -Level "INFO"
    $result = Test-ProjectXmlV3Compatibility -ProjectXml $projectXml -ProjectPath $ProjectSrcPath

    if ($result.issues.Count -gt 0) {
      $migrationRequired = $true
      $detectedIssues = $result.issues
      Write-MigrationLog -Message "Migration required: $($result.issues.Count) compatibility issues detected" -Level "WARN"
    } else {
      Write-MigrationLog -Message "No compatibility issues detected in preliminary analysis" -Level "INFO"
    }
  } catch {
    Write-MigrationLog -Message "Error analyzing project.xml: $($_.Exception.Message)" -Level "WARN"
    $migrationRequired = $true
    $detectedIssues = @("Unable to analyze project.xml file (possibly corrupted)")
  }

  # Show warning and get user confirmation BEFORE any migration
  Write-MigrationLog -Message "Evaluating if migration warning should be displayed..." -Level "INFO"
  Write-MigrationLog -Message "Migration required: $migrationRequired, Detected issues count: $($detectedIssues.Count)" -Level "INFO"

  if ($migrationRequired) {
    Write-MigrationLog -Message "Migration required - preparing backup and user confirmation..." -Level "INFO"
    # Create automatic backup in temp folder with UUID
    $backupUuid = [System.Guid]::NewGuid().ToString()
    $tempBackupPath = "$env:TEMP\$backupUuid"
    $projectRootPath = Split-Path -Parent $ProjectSrcPath

    Write-MigrationLog -Message "Creating automatic project backup with UUID: $backupUuid" -Level "INFO"
    Write-MigrationLog -Message "Backup will be created at: $tempBackupPath" -Level "INFO"
    Write-MigrationLog -Message "Project root path: $projectRootPath" -Level "INFO"
    Write-Host "Creating automatic project backup..." -ForegroundColor Cyan

    try {
      # Create temp backup directory
      Write-MigrationLog -Message "Creating backup directory: $tempBackupPath" -Level "INFO"
      New-Item -ItemType Directory -Path $tempBackupPath -Force | Out-Null

      # Copy entire project to temp backup, excluding the migration log file
      Write-MigrationLog -Message "Starting robocopy operation from '$projectRootPath' to '$tempBackupPath'" -Level "INFO"
      robocopy "$projectRootPath" "$tempBackupPath" /E /XD ".git" "build" "dist" "node_modules" /XF "migration.log" /NFL /NDL /NJH /NJS | Out-Null

      Write-MigrationLog -Message "Project backup created at: $tempBackupPath" -Level "SUCCESS"
      Write-Host "  - Backup location: $tempBackupPath" -ForegroundColor Green
      Write-Host "  - Backup UUID: $backupUuid" -ForegroundColor Green
    } catch {
      Write-MigrationLog -Message "Warning: Could not create automatic backup: $($_.Exception.Message)" -Level "WARN"
      Write-Host "  - Warning: Could not create automatic backup" -ForegroundColor Yellow
    }

    Write-MigrationLog -Message "Calling Show-MigrationWarning for user confirmation..." -Level "INFO"
    if (-not (Show-MigrationWarning -ProjectSrcPath $ProjectSrcPath -ProjectNeocorePath $ProjectNeocorePath -CurrentVersion $projectNeocoreVersion -TargetVersion $version -DetectedIssues $detectedIssues -BackupPath $tempBackupPath)) {
      Write-MigrationLog -Message "User declined migration - exiting script" -Level "INFO"
      exit 0
    }
    Write-MigrationLog -Message "User confirmed migration - proceeding with analysis..." -Level "INFO"
  } else {
    Write-MigrationLog -Message "No migration required based on preliminary analysis" -Level "INFO"
  }

  Write-Host ""
  Write-Host "Analyzing project for v3 migration..." -ForegroundColor Cyan
  Write-MigrationLog -Message "Starting detailed v3 migration analysis..." -Level "INFO"

  # Use the previously determined values from the preliminary analysis
  Write-Host "Project's current NeoCore version: $projectNeocoreVersion" -ForegroundColor Yellow
  Write-MigrationLog -Message "Current project NeoCore version: $projectNeocoreVersion" -Level "INFO"

  # Check if migration from v2 to v3 is needed
  Write-MigrationLog -Message "Evaluating migration requirements based on version..." -Level "INFO"
  if ($projectNeocoreVersion -like "2.*") {
    $migrationRequired = $true
    Write-MigrationLog -Message "v2 detected - migration to v3 required" -Level "WARN"
    Write-Host "Migration from v2 to v3 is required!" -ForegroundColor Red

    # Always update manifest version when migrating from v2 to v3
    Write-MigrationLog -Message "Updating project manifest from $projectNeocoreVersion to $version" -Level "INFO"
    Write-Host "Updating project manifest to v3..." -ForegroundColor Cyan
    $null = Update-ProjectManifestVersion -ProjectManifestPath $projectManifestPath -NewVersion $version
    $projectNeocoreVersion = $version # Update the displayed version

  } elseif ($projectNeocoreVersion -like "3.*" -and $projectNeocoreVersion -ne $version) {
    Write-MigrationLog -Message "v3 detected but version differs: $projectNeocoreVersion -> $version" -Level "INFO"
    Write-Host "Project is using NeoCore v3 but version differs from current" -ForegroundColor Yellow
    Write-Host "Updating to latest v3 version..." -ForegroundColor Cyan
    $null = Update-ProjectManifestVersion -ProjectManifestPath $projectManifestPath -NewVersion $version
    $projectNeocoreVersion = $version
    $migrationRequired = $false # No structural migration needed, just version update

  } elseif ($projectNeocoreVersion -eq $version) {
    Write-MigrationLog -Message "Project already uses current NeoCore version ($version)" -Level "SUCCESS"
    Write-Host "Project is already using the current NeoCore version ($version)" -ForegroundColor Green
    $migrationRequired = $false

  } else {
    Write-MigrationLog -Message "Unrecognized version format: $projectNeocoreVersion" -Level "WARN"
    Write-Host "Warning: Unrecognized version format, proceeding with compatibility check..." -ForegroundColor Yellow
    $migrationRequired = $true
  }

  } else {
    Write-MigrationLog -Message "Project manifest.xml not found at $projectManifestPath" -Level "WARN"
    Write-Host "Warning: Project manifest.xml not found at $projectManifestPath" -ForegroundColor Yellow
    Write-Host "Proceeding with compatibility check..." -ForegroundColor Yellow
    $migrationRequired = $true
  }

  # Run detailed compatibility check if migration is required
  Write-MigrationLog -Message "Checking if detailed compatibility check is needed..." -Level "INFO"
  Write-MigrationLog -Message "Migration required flag: $migrationRequired" -Level "INFO"

  if ($migrationRequired) {
    Write-MigrationLog -Message "Starting detailed compatibility check..." -Level "INFO"
    try {
      # Load and analyze project.xml (re-use previous analysis if available)
      if (-not $result) {
        Write-MigrationLog -Message "Loading and analyzing project.xml (no previous result available)..." -Level "INFO"
        [xml]$projectXml = Get-Content -Path $projectXmlPath
        $result = Test-ProjectXmlV3Compatibility -ProjectXml $projectXml -ProjectPath $ProjectSrcPath
      } else {
        Write-MigrationLog -Message "Re-using previous compatibility analysis result" -Level "INFO"
      }

      Write-MigrationLog -Message "Compatibility check completed: $($result.Issues.Count) issues, $($result.Warnings.Count) warnings" -Level "INFO"

      if ($result.Issues.Count -gt 0) {
        Write-MigrationLog -Message "Migration required - found $($result.Issues.Count) blocking issues" -Level "WARN"
        Write-Host ""
        Write-Host "v2 to v3 migration issues found:" -ForegroundColor Red
        foreach ($issue in $result.Issues) {
          Write-MigrationLog -Message "Issue: $issue" -Level "WARN"
          Write-Host "  * $issue" -ForegroundColor Red
        }

      # Attempt automatic repair
      Write-MigrationLog -Message "Starting automatic v3 migration..." -Level "INFO"
      Write-Host "Attempting automatic v3 migration..." -ForegroundColor Cyan
      $null = Repair-ProjectXmlForV3 -ProjectXml $projectXml -ProjectXmlPath $projectXmlPath

      # Re-test after repairs
      Write-MigrationLog -Message "Re-testing project.xml after migration..." -Level "INFO"
      [xml]$updatedXml = Get-Content -Path $projectXmlPath
      $retest = Test-ProjectXmlV3Compatibility -ProjectXml $updatedXml -ProjectPath $ProjectSrcPath

      if ($retest.IsCompatible) {
        Write-MigrationLog -Message "Migration successful - project.xml is now v3 compatible" -Level "SUCCESS"
        Write-Host "project.xml is v3 compatible!" -ForegroundColor Green
      } else {
        Write-MigrationLog -Message "Migration completed but $($retest.Issues.Count) issues remain" -Level "WARN"
        Write-Host "Some issues remain - manual review recommended" -ForegroundColor Yellow
      }
    } elseif ($result.Issues.Count -eq 0) {
      if ($migrationRequired) {
        Write-MigrationLog -Message "No structural changes needed - project.xml already v3 compatible" -Level "SUCCESS"
        Write-Host "  - project.xml is already v3 compatible!" -ForegroundColor Green
      } else {
        Write-MigrationLog -Message "Project is fully v3 compatible - no migration needed" -Level "SUCCESS"
        Write-Host "  - project.xml is v3 compatible (no migration needed)" -ForegroundColor Green
      }
    }

    if ($result.Warnings.Count -gt 0) {
      Write-MigrationLog -Message "Found $($result.Warnings.Count) warnings for manual review" -Level "WARN"
      Write-Host ""
      Write-Host "Warnings (manual review recommended):" -ForegroundColor Yellow
      foreach ($warning in $result.Warnings) {
        Write-MigrationLog -Message "Warning: $warning" -Level "WARN"
        Write-Host "  * $warning" -ForegroundColor Yellow
      }
    }

    # Display project info (reload XML to get the most current data after migration)
    [xml]$currentProjectXml = Get-Content -Path $projectXmlPath

    $projectNameNode = $currentProjectXml.SelectSingleNode("//name")
    $projectVersionNode = $currentProjectXml.SelectSingleNode("//version")
    $projectPlatformNode = $currentProjectXml.SelectSingleNode("//platform")

    $projectName = if ($projectNameNode) { $projectNameNode.InnerText } else { "Unknown" }
    $projectVersion = if ($projectVersionNode) { $projectVersionNode.InnerText } else { "Unknown" }
    $projectPlatform = if ($projectPlatformNode) { $projectPlatformNode.InnerText } else { "Unknown" }

    Write-MigrationLog -Message "Project info - Name: $projectName, Version: $projectVersion, Platform: $projectPlatform" -Level "INFO"
    Write-Host ""
    Write-Host "Project Info:" -ForegroundColor Cyan
    Write-Host "  - Name: $projectName" -ForegroundColor White
    Write-Host "  - Version: $projectVersion" -ForegroundColor White
    Write-Host "  - Platform: $projectPlatform" -ForegroundColor White
    Write-Host "  - NeoCore Version: $projectNeocoreVersion" -ForegroundColor White

    # Show migration summary
    if ($migrationRequired) {
      Write-Host ""
      Write-Host "Migration Summary:" -ForegroundColor Cyan
      Write-Host "  - Source Version: $projectNeocoreVersion" -ForegroundColor Yellow
      Write-Host "  - Target Version: $version" -ForegroundColor Green
      if ($retest -and $retest.IsCompatible) {
        Write-MigrationLog -Message "Migration completed successfully" -Level "SUCCESS"
        Write-Host "  - Status: Migration Complete" -ForegroundColor Green
      } else {
        Write-MigrationLog -Message "Migration completed but manual review required" -Level "WARN"
        Write-Host "  - Status: Manual Review Required" -ForegroundColor Yellow
      }
    }

  } catch {
    Write-MigrationLog -Message "Error during compatibility check or migration: $($_.Exception.Message)" -Level "ERROR"
    Write-MigrationLog -Message "Stack trace: $($_.ScriptStackTrace)" -Level "ERROR"
    Write-Host "Error: Could not parse project.xml: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please manually verify project.xml format" -ForegroundColor Yellow
  }
} else {
  Write-MigrationLog -Message "project.xml not found at $projectXmlPath" -Level "ERROR"
  Write-Host "Warning: project.xml not found at $projectXmlPath" -ForegroundColor Yellow
  Write-Host "This may not be a NeoCore project directory" -ForegroundColor Yellow
}

# Check .gitignore file
Write-MigrationLog -Message "Checking .gitignore configuration..." -Level "INFO"
$gitignorePath = "$ProjectSrcPath\..\.gitignore"

if (Test-Path -Path $gitignorePath) {
  Write-MigrationLog -Message "Found .gitignore file, checking build/ and dist/ patterns..." -Level "INFO"
  $gitignoreContent = Get-Content -Path $gitignorePath
  if ($gitignoreContent -notcontains "build/") {
  } else {
    Write-MigrationLog -Message ".gitignore contains 'build/' - should be '/build/'" -Level "WARN"
    Write-Host ""
    Write-Host "warning : the $gitignorePath file contains 'build/'" -ForegroundColor Yellow
    Write-Host "please change it to '/build/'" -ForegroundColor Yellow
  }
  if ($gitignoreContent -notcontains "dist/") {
  } else {
    Write-MigrationLog -Message ".gitignore contains 'dist/' - should be '/dist/'" -Level "WARN"
    Write-Host ""
    Write-Host "warning : the $gitignorePath file contains 'dist/'" -ForegroundColor Yellow
    Write-Host "please change it to '/dist/'" -ForegroundColor Yellow
  }
} else {
  Write-MigrationLog -Message ".gitignore not found at $gitignorePath" -Level "ERROR"
  Show-Error "$gitignorePath not found"
}

# Migration completed
Write-MigrationLog -Message "=== NeoCore v2->v3 Migration Completed ===" -Level "SUCCESS"
Write-MigrationLog -Message "Script execution completed successfully" -Level "SUCCESS"
Write-MigrationLog -Message "Total log entries written during migration process" -Level "INFO"
Write-MigrationLog -Message "Log file saved at: $global:MigrationLogPath" -Level "INFO"
Write-Host ""
Write-Host "Migration process completed. Check the migration log for detailed information:" -ForegroundColor Green
Write-Host "  Log file: $global:MigrationLogPath" -ForegroundColor Cyan
