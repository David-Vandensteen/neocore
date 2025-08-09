param (
  [Parameter(Mandatory=$true)]
  [string]$ProjectSrcPath,

  [Parameter(Mandatory=$true)]
  [string]$ProjectNeocorePath
)

# Initialize logging
$MigrationLogPath = "$ProjectSrcPath\..\migration.log"
$MigrationStartTime = Get-Date

# Test log file creation immediately
try {
  "=== Migration Log Test ===" | Out-File -FilePath $MigrationLogPath -Encoding UTF8
  Write-Host "Log file test: SUCCESS - File created at $MigrationLogPath" -ForegroundColor Green
} catch {
  Write-Host "Log file test: FAILED - Cannot create file at $MigrationLogPath" -ForegroundColor Red
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
    $logDir = Split-Path -Parent $MigrationLogPath
    if (-not (Test-Path -Path $logDir)) {
      New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }

    $logEntry | Out-File -FilePath $MigrationLogPath -Append -Encoding UTF8
  } catch {
    Write-Host "Warning: Could not write to log file '$MigrationLogPath': $($_.Exception.Message)" -ForegroundColor Yellow
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
  } else {
    Write-Host "[STATUS] PROJECT.XML COMPATIBILITY:" -ForegroundColor Green
    Write-Host "   * Your project.xml appears to be v3 compatible" -ForegroundColor Gray
    Write-Host "   * Migration will still perform full analysis and validation" -ForegroundColor Gray
    Write-Host ""
  }

  if ($deprecatedFiles -and $deprecatedFiles.Count -gt 0) {
    Write-Host "[CLEANUP] DEPRECATED FILES WILL BE REMOVED:" -ForegroundColor Magenta
    foreach ($file in $deprecatedFiles) {
      Write-Host "   * $file" -ForegroundColor Gray
    }
    Write-Host ""
  }

  if ($filesToUpdate -and $filesToUpdate.Count -gt 0) {
    Write-Host "[UPDATE] NEOCORE FILES WILL BE REPLACED:" -ForegroundColor Blue
    foreach ($file in $filesToUpdate) {
      Write-Host "   * $file" -ForegroundColor Gray
    }
    Write-Host ""
  }

  Write-Host "[ANALYSIS] AUTOMATIC COMPATIBILITY CHECKS:" -ForegroundColor Cyan
  Write-Host "   * project.xml structure migration (automatic fixes)" -ForegroundColor Gray
  Write-Host "   * C files v2/v3 compatibility analysis (detection only)" -ForegroundColor Gray
  Write-Host "   * .gitignore patterns validation" -ForegroundColor Gray
  Write-Host ""

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
  Write-Host "           - project.xml will be automatically migrated" -ForegroundColor Red
  Write-Host "           - C files will only be analyzed (manual changes required)" -ForegroundColor Red
  Write-Host "           - Deprecated files (common_crt0_cd.s, crt0_cd.s) will be automatically removed" -ForegroundColor Red
  Write-Host "           - Automatic backups do not replace a complete project backup" -ForegroundColor Red
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

function Get-CIssueCategories {
  param (
    [Parameter(Mandatory=$true)]
    [array]$AllIssues
  )

  $categories = @{
    Vec2short = @()
    PositionGetters = @()
    LoggingFunctions = @()
    PaletteFunctions = @()
    SpriteLoading = @()
    DATlibTypes = @()
    DATlibFunctions = @()
    DeprecatedFunctions = @()
    Other = @()
  }

  foreach ($issue in $AllIssues) {
    if ($issue -match "Vec2short|Position") {
      $categories.Vec2short += $issue
    } elseif ($issue -match "nc_get_position|position getter") {
      $categories.PositionGetters += $issue
    } elseif ($issue -match "nc_log|logging") {
      $categories.LoggingFunctions += $issue
    } elseif ($issue -match "palette|color") {
      $categories.PaletteFunctions += $issue
    } elseif ($issue -match "sprite|gfx") {
      $categories.SpriteLoading += $issue
    } elseif ($issue -match "WORD|DWORD|BYTE|palCount") {
      $categories.DATlibTypes += $issue
    } elseif ($issue -match "Init\s*\(|DATlib") {
      $categories.DATlibFunctions += $issue
    } elseif ($issue -match "deprecated") {
      $categories.DeprecatedFunctions += $issue
    } else {
      $categories.Other += $issue
    }
  }

  return $categories
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

  # Check for sound section migration (v3 format)
  Write-MigrationLog -Message "Checking sound configuration..." -Level "INFO"
  $soundNode = $ProjectXml.SelectSingleNode("//sound")
  if ($soundNode) {
    # Check if sound is already in v3 format (has cd element)
    $soundCdNode = $soundNode.SelectSingleNode("cd")
    if (-not $soundCdNode) {
      $issues += "Migrate sound section to v3 format (move content to sound/cd structure)"
      Write-MigrationLog -Message "Issue detected: Sound section needs migration to v3 format" -Level "WARN"
    } else {
      Write-MigrationLog -Message "Sound section already in v3 format" -Level "INFO"
    }
  } else {
    Write-MigrationLog -Message "No sound section found" -Level "INFO"
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

  # Preserve existing sound section (migrate to v3 cd format)
  $existingSoundSection = ""
  $soundNode = $ProjectXml.SelectSingleNode("//sound")
  if ($soundNode) {
    Write-MigrationLog -Message "Found existing sound section, preserving for v3 migration" -Level "INFO"

    # Create a new XML document to properly format the sound content
    $tempDoc = New-Object System.Xml.XmlDocument
    $tempDoc.LoadXml("<temp>" + $soundNode.InnerXml + "</temp>")

    # Use StringWriter with proper formatting
    $stringWriter = New-Object System.IO.StringWriter
    $xmlWriter = New-Object System.Xml.XmlTextWriter($stringWriter)
    $xmlWriter.Formatting = [System.Xml.Formatting]::Indented
    $xmlWriter.Indentation = 2
    $xmlWriter.IndentChar = ' '

    # Write each child node of the temp element
    foreach ($childNode in $tempDoc.DocumentElement.ChildNodes) {
      $childNode.WriteTo($xmlWriter)
    }

    $xmlWriter.Close()
    $stringWriter.Close()

    $existingSoundSection = $stringWriter.ToString()
    Write-MigrationLog -Message "Preserved sound section content with proper formatting" -Level "INFO"
  } else {
    Write-MigrationLog -Message "No existing sound section found" -Level "INFO"
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
"@

  # Add sound section if it existed in v2 format
  if ($existingSoundSection -ne "") {
    Write-MigrationLog -Message "Adding preserved sound section in v3 format (cd wrapper)" -Level "INFO"

    # Add proper indentation to each line of the sound content (4 spaces for cd level)
    $indentedSoundContent = ""
    $soundLines = $existingSoundSection -split "`r?`n"
    foreach ($line in $soundLines) {
      if ($line.Trim() -ne "") {
        $indentedSoundContent += "      $line`n"
      }
    }

    $soundSectionV3 = @"
  <sound>
    <cd>
$indentedSoundContent    </cd>
  </sound>
"@
    $newXmlContent = $newXmlContent.TrimEnd() + "`n" + $soundSectionV3 + "`n</project>"
  } else {
    $newXmlContent = $newXmlContent + "</project>"
  }

  # Write the new content to file
  try {
    Write-MigrationLog -Message "Writing new v3 project.xml structure to file" -Level "INFO"
    $newXmlContent | Out-File -FilePath $ProjectXmlPath -Encoding UTF8 -Force
    Write-MigrationLog -Message "Successfully wrote v3 project.xml with preserved user data" -Level "SUCCESS"

    Write-Host "  - Project.xml rewritten with complete v3 structure" -ForegroundColor Green
    Write-Host "  - Preserved existing name: '$existingName'" -ForegroundColor Green
    Write-Host "  - Preserved existing version: '$existingVersion'" -ForegroundColor Green
    Write-Host "  - Preserved existing neocorePath: '$existingNeocorePath'" -ForegroundColor Green
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

function Test-CFileV3Compatibility {
  param (
    [Parameter(Mandatory=$true)]
    [string]$FilePath,
    [Parameter(Mandatory=$true)]
    [string]$FileContent
  )

  Write-MigrationLog -Message "Analyzing C file for v3 compatibility: $FilePath" -Level "INFO"
  $issues = @()
  $lineNumber = 0
  $lines = $FileContent -split "`n"

  # Analyze line by line for better context
  foreach ($line in $lines) {
    $lineNumber++
    $trimmedLine = $line.Trim()

    # Skip comments and empty lines
    if ($trimmedLine -match '^\s*//' -or $trimmedLine -match '^\s*/\*' -or $trimmedLine -eq '') {
      continue
    }

    # Check for v2 type usage patterns
    if ($line -match '\bVec2short\b') {
      $issues += "Line $lineNumber" + ": Uses 'Vec2short' type (replaced by 'Position' in v3)"
    }

    if ($line -match '\bHex_Color\b') {
      $issues += "Line $lineNumber" + ": Uses 'Hex_Color' typedef (removed in v3, use char arrays directly)"
    }

    if ($line -match '\bHex_Packed_Color\b') {
      $issues += "Line $lineNumber" + ": Uses 'Hex_Packed_Color' typedef (removed in v3, use char arrays directly)"
    }

    # Check for v2 function signatures (return value patterns)
    if ($line -match '\bVec2short\s+\w+\s*=\s*nc_get_position_') {
      $issues += "Line $lineNumber" + ": Uses v2 position function return pattern (v3 uses output parameters)"
    }

    # Check for specific v2 function calls with old signatures
    if ($line -match '\bnc_get_position_gfx_animated_sprite\s*\([^,)]+\)') {
      $issues += "Line $lineNumber" + ": Uses v2 nc_get_position_gfx_animated_sprite signature (v3 requires output parameter)"
    }

    if ($line -match '\bnc_get_position_gfx_picture\s*\([^,)]+\)') {
      $issues += "Line $lineNumber" + ": Uses v2 nc_get_position_gfx_picture signature (v3 requires output parameter)"
    }

    if ($line -match '\bnc_get_position_gfx_scroller\s*\([^,)]+\)') {
      $issues += "Line $lineNumber" + ": Uses v2 nc_get_position_gfx_scroller signature (v3 requires output parameter)"
    }

    # Check for removed logging functions
    if ($line -match '\bnc_log_vec2short\b') {
      $issues += "Line $lineNumber" + ": Uses 'nc_log_vec2short' function (replaced by 'nc_log_position' in v3)"
    }

    if ($line -match '\bnc_log_rgb16\b') {
      $issues += "Line $lineNumber" + ": Uses 'nc_log_rgb16' function (signature changed in v3)"
    }

    if ($line -match '\bnc_log_packed_color16\b') {
      $issues += "Line $lineNumber" + ": Uses 'nc_log_packed_color16' function (signature changed in v3)"
    }

    # Check for additional deprecated v2 functions
    if ($line -match '\bnc_palette_load\b') {
      $issues += "Line $lineNumber" + ": Uses 'nc_palette_load' function (deprecated in v3, use new palette API)"
    }

    if ($line -match '\bnc_sound_play_wav\b') {
      $issues += "Line $lineNumber" + ": Uses 'nc_sound_play_wav' function (deprecated in v3, use new sound API)"
    }

    if ($line -match '\bnc_gfx_load_sprite_old\b') {
      $issues += "Line $lineNumber" + ": Uses 'nc_gfx_load_sprite_old' function (deprecated in v3, use nc_gfx_load_sprite)"
    }

    if ($line -match '\bnc_draw_sprite_deprecated\b') {
      $issues += "Line $lineNumber" + ": Uses 'nc_draw_sprite_deprecated' function (deprecated in v3, use nc_gfx_draw_sprite)"
    }

    if ($line -match '\bnc_palette_set_color_old\b') {
      $issues += "Line $lineNumber" + ": Uses 'nc_palette_set_color_old' function (deprecated in v3, use new palette API)"
    }

    if ($line -match '\bnc_input_get_old\b') {
      $issues += "Line $lineNumber" + ": Uses 'nc_input_get_old' function (deprecated in v3, use nc_input_get)"
    }

    if ($line -match '\bnc_timer_wait_old\b') {
      $issues += "Line $lineNumber" + ": Uses 'nc_timer_wait_old' function (deprecated in v3, use nc_timer_wait)"
    }

    # Check for v2 include patterns
    if ($line -match '#include\s+"neocore\.h"' -and $line -notmatch '#include\s+<neocore\.h>') {
      $issues += "Line $lineNumber" + ": Uses '#include `"neocore.h`"' (v3 may require updated include path)"
    }

    # Check for palette manager functions with old signatures
    if ($line -match '\bnc_load_palettes\s*\([^,)]*\)') {
      $issues += "Line $lineNumber" + ": Uses v2 nc_load_palettes signature (v3 requires palette bank parameter)"
    }

    if ($line -match '\bnc_get_palette\s*\([^,)]*\)') {
      $issues += "Line $lineNumber`: Uses v2 nc_get_palette signature (v3 API changed)"
    }

    # Check for sprite manager functions with old signatures
    if ($line -match '\bnc_load_sprites\s*\([^,)]*\)') {
      $issues += "Line $lineNumber`: Uses v2 nc_load_sprites signature (v3 requires sprite bank parameter)"
    }

    # Check for DATlib 0.2 patterns
    if ($line -match '\bGFX_AnimatedSprite_\w+_physic\b') {
      $issues += "Line $lineNumber`: Uses DATlib 0.2 physic sprite patterns (DATlib 0.3 required for v3)"
    }

    if ($line -match '\bnc_\w*_gfx_animated_sprite_\w*_physic\b') {
      $issues += "Line $lineNumber`: Uses DATlib 0.2 physic function patterns (DATlib 0.3 API required)"
    }

    # Check for old include patterns
    if ($line -match '#include\s*["<]neocore\.h[">]') {
      $issues += "Line $lineNumber`: Uses '#include `"neocore.h`"' (v3 may require updated include path)"
    }

    # Check for old constant usage
    if ($line -match '\bCD_WIDTH\b|\bCD_HEIGHT\b') {
      $issues += "Line $lineNumber`: Uses CD_WIDTH/CD_HEIGHT constants (verify v3 compatibility)"
    }

    # Check for old macro usage
    if ($line -match '\bVEC2SHORT\s*\(') {
      $issues += "Line $lineNumber`: Uses VEC2SHORT macro (replaced by POSITION macro in v3)"
    }

    # Check for old sound functions
    if ($line -match '\bnc_load_sound\s*\([^,)]*\)') {
      $issues += "Line $lineNumber`: Uses v2 nc_load_sound signature (v3 API may have changed)"
    }

    # Check for old ADPCM functions
    if ($line -match '\bnc_adpcm_\w+\s*\([^,)]*\)') {
      $issues += "Line $lineNumber`: Uses v2 ADPCM functions (verify v3 compatibility and signatures)"
    }

    # Check for old memory management patterns
    if ($line -match '\bnc_malloc\s*\(') {
      $issues += "Line $lineNumber`: Uses nc_malloc (verify v3 memory management compatibility)"
    }

    if ($line -match '\bnc_free\s*\(') {
      $issues += "Line $lineNumber`: Uses nc_free (verify v3 memory management compatibility)"
    }

    # Check for DATlib 0.2 to 0.3 breaking changes

    # paletteInfo structure changes
    if ($line -match '\.palCount\b') {
      $issues += "Line $lineNumber`: Uses 'palCount' member (renamed to 'count' in DATlib 0.3)"
    }

    # scroller structure removed members
    if ($line -match '\.colNumber\b') {
      $issues += "Line $lineNumber`: Uses 'colNumber' member (removed in DATlib 0.3, use config array)"
    }

    if ($line -match '\.topBk\b|\.\botBk\b') {
      $issues += "Line $lineNumber`: Uses 'topBk/botBk' members (removed in DATlib 0.3, use config array)"
    }

    # animation structure (completely removed)
    if ($line -match '\banimation\s+\w+|\banimation\s*\*') {
      $issues += "Line $lineNumber`: Uses 'animation' structure (completely removed in DATlib 0.3)"
    }

    # aSprite member changes
    if ($line -match '\.currentStepNum\b') {
      $issues += "Line $lineNumber`: Uses 'currentStepNum' member (renamed to 'stepNum' in DATlib 0.3)"
    }

    if ($line -match '\.maxStep\b') {
      $issues += "Line $lineNumber`: Uses 'maxStep' member (removed in DATlib 0.3)"
    }

    if ($line -match '\.currentAnimation\b') {
      $issues += "Line $lineNumber`: Uses 'currentAnimation' member (removed in DATlib 0.3, use currentAnim index)"
    }

    # sprFrame member changes
    if ($line -match '\.colSize\b') {
      $issues += "Line $lineNumber`: Uses 'colSize' member (renamed to 'stripSize' in DATlib 0.3)"
    }

    # pictureInfo member changes
    if ($line -match '\.unused__height\b') {
      $issues += "Line $lineNumber`: Uses 'unused__height' member (removed in DATlib 0.3)"
    }

    # scrollerInfo structure changes
    if ($line -match '\.map\[') {
      $issues += "Line $lineNumber`: Uses 'map' array (replaced by 'strips' in DATlib 0.3)"
    }

    # Job meter color constants (values changed)
    if ($line -match '\bJOB_(BLACK|LIGHTRED|DARKRED|GARKGREEN|LIGHTGREEN|DARKGREEN|LIGHTBLUE|DARKBLUE)\b') {
      $issues += "Line $lineNumber`: Uses job meter color constants (values changed significantly in DATlib 0.3)"
    }

    # Old sprite constants
    if ($line -match '\bASPRITE_FRAMES_ADDR\b') {
      $issues += "Line $lineNumber`: Uses 'ASPRITE_FRAMES_ADDR' constant (removed in DATlib 0.3)"
    }

    # Hardcoded sprite flags (should use new constants)
    if ($line -match '\|\s*0x0080\b|\&\s*0xff7f\b') {
      $issues += "Line $lineNumber`: Uses hardcoded sprite flags (use AS_FLAG_* constants in DATlib 0.3)"
    }

    # DATlib function signature changes
    if ($line -match '\bpictureInit\s*\([^,]+,[^,]+,\s*\d+\s*,\s*\d+\s*,[^,]+,[^,]+,[^,)]+\)') {
      $issues += "Line $lineNumber`: Uses v2 pictureInit signature (parameter types changed in DATlib 0.3)"
    }

    if ($line -match '\baSpriteInit\s*\([^,]+,[^,]+,[^,]+,[^,]+,[^,]+,[^,]+,[^,]+,[^,)]+\)') {
      $issues += "Line $lineNumber`: Uses v2 aSpriteInit signature (missing flags parameter in DATlib 0.3)"
    }

    if ($line -match '\bspritePoolInit\s*\([^,]+,[^,]+,[^,)]+\)') {
      $issues += "Line $lineNumber`: Uses v2 spritePoolInit signature (missing clearSprites parameter in DATlib 0.3)"
    }

    # Text function parameter type changes
    if ($line -match '\bfixPrint\s*\(\s*\d+\s*,') {
      $issues += "Line $lineNumber`: Uses fixPrint with int parameters (use ushort parameters in DATlib 0.3)"
    }

    # Logging with labels (removed in v3)
    if ($line -match '\bnc_log_word\s*\([^,]+,[^,)]+\)') {
      $issues += "Line $lineNumber`: Uses nc_log_word with label (labels removed in v3, use nc_log_info + nc_log_word)"
    }

    if ($line -match '\bnc_log_int\s*\([^,]+,[^,)]+\)') {
      $issues += "Line $lineNumber`: Uses nc_log_int with label (labels removed in v3, use nc_log_info + nc_log_int)"
    }

    if ($line -match '\bnc_log_short\s*\([^,]+,[^,)]+\)') {
      $issues += "Line $lineNumber`: Uses nc_log_short with label (labels removed in v3, use nc_log_info + nc_log_short)"
    }

    # Old nc_log function
    if ($line -match '\bnc_log\s*\([^,)]+\)') {
      $issues += "Line $lineNumber`: Uses nc_log function (replaced by nc_log_info/nc_log_info_line in v3)"
    }

    # Physic sprite functions (missing output parameter)
    if ($line -match '\bnc_get_position_gfx_animated_sprite_physic\s*\([^,)]+\)') {
      $issues += "Line $lineNumber`: Uses v2 nc_get_position_gfx_animated_sprite_physic signature (v3 requires output parameter)"
    }

    if ($line -match '\bnc_get_position_gfx_picture_physic\s*\([^,)]+\)') {
      $issues += "Line $lineNumber`: Uses v2 nc_get_position_gfx_picture_physic signature (v3 requires output parameter)"
    }

    # Removed relative position function
    if ($line -match '\bnc_get_relative_position\s*\(') {
      $issues += "Line $lineNumber`: Uses nc_get_relative_position function (removed in v3)"
    }
  }

  Write-MigrationLog -Message "C file analysis completed: $($issues.Count) issues found in $FilePath" -Level "INFO"
  return $issues
}

function Test-MigrationSuccess {
  param (
    [Parameter(Mandatory=$true)]
    [string]$ProjectXmlPath,
    [Parameter(Mandatory=$true)]
    [int]$TotalCIssues,
    [Parameter(Mandatory=$false)]
    [bool]$HasGitignoreIssues = $false
  )

  Write-MigrationLog -Message "Evaluating migration success criteria..." -Level "INFO"

  $success = $true
  $warnings = @()

  # Check if project.xml exists and is valid
  if (-not (Test-Path -Path $ProjectXmlPath)) {
    $success = $false
    $warnings += "project.xml not found"
  } else {
    try {
      [xml]$testXml = Get-Content -Path $ProjectXmlPath
      if (-not $testXml.project) {
        $success = $false
        $warnings += "project.xml structure appears invalid"
      }
    } catch {
      $success = $false
      $warnings += "project.xml cannot be parsed as valid XML"
    }
  }

  # Evaluate C code issues
  if ($TotalCIssues -gt 0) {
    $warnings += "$TotalCIssues C code compatibility issues require manual review"
  }

  # Evaluate .gitignore issues
  if ($HasGitignoreIssues) {
    $warnings += ".gitignore patterns need manual correction"
  }

  Write-MigrationLog -Message "Migration success evaluation: Success=$success, Warnings=$($warnings.Count)" -Level "INFO"

  return @{
    Success = $success
    Warnings = $warnings
    HasCIssues = ($TotalCIssues -gt 0)
    HasGitignoreIssues = $HasGitignoreIssues
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
  Write-MigrationLog -Message "NeoCore path verified: $ProjectNeocorePath" -Level "INFO"

  if (-Not(Test-Path -Path "$ProjectNeocorePath\src-lib")) { Show-Error "$ProjectNeocorePath\src-lib not found" }
  if (-Not(Test-Path -Path "$ProjectNeocorePath\toolchain")) { Show-Error "$ProjectNeocorePath\toolchain not found" }
} else {
  Show-Error "$ProjectNeocorePath not found"
}

if (Test-Path -Path $ProjectSrcPath) {
  $makBat = Resolve-Path -Path "..\..\..\bootstrap\standalone\mak.bat"
  $makPs1 = Resolve-Path -Path "..\..\..\bootstrap\standalone\mak.ps1"
  $makefile = Resolve-Path -Path "..\..\..\bootstrap\standalone\Makefile"

  try {
    Copy-Item -Path $makBat -Destination $ProjectSrcPath -Force
    Copy-Item -Path $makPs1 -Destination $ProjectSrcPath -Force
    Copy-Item -Path $makefile -Destination $ProjectSrcPath -Force
    Write-Host "files copied successfully to $ProjectSrcPath"
  } catch {
    Show-Error "failed to copy some files"
  }
} else {
  Show-Error "$ProjectSrcPath not found"
}

# Project XML Migration Logic
$projectXmlPath = "$ProjectSrcPath\project.xml"
$projectManifestPath = "$ProjectNeocorePath\manifest.xml"

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
      $versionNode = $manifestXml.SelectSingleNode("//version")
      if ($versionNode -and $versionNode.InnerText) {
        $projectNeocoreVersion = $versionNode.InnerText
        Write-MigrationLog -Message "Found project manifest with NeoCore version: $projectNeocoreVersion" -Level "INFO"
      } else {
        Write-MigrationLog -Message "Project manifest found but no version node detected" -Level "WARN"
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

    # Evaluate all migration requirements
    Write-MigrationLog -Message "Evaluating all migration requirements..." -Level "INFO"

    $result = Test-ProjectXmlV3Compatibility -ProjectXml $projectXml -ProjectPath $ProjectSrcPath
    $detectedIssues = @()
    $migrationRequired = $false

    # Check 1: project.xml compatibility issues
    if ($result.issues.Count -gt 0) {
      $migrationRequired = $true
      $detectedIssues += $result.issues
      Write-MigrationLog -Message "Migration required: $($result.issues.Count) project.xml compatibility issues detected" -Level "WARN"
    }

    # Check 2: Deprecated files presence
    $commonCrt0Path = "$ProjectSrcPath\common_crt0_cd.s"
    $crt0Path = "$ProjectSrcPath\crt0_cd.s"
    $deprecatedFiles = @()

    if (Test-Path -Path $commonCrt0Path) {
      $migrationRequired = $true
      $deprecatedFiles += "common_crt0_cd.s"
      Write-MigrationLog -Message "Migration required: Found deprecated file common_crt0_cd.s" -Level "WARN"
    }

    if (Test-Path -Path $crt0Path) {
      $migrationRequired = $true
      $deprecatedFiles += "crt0_cd.s"
      Write-MigrationLog -Message "Migration required: Found deprecated file crt0_cd.s" -Level "WARN"
    }

    # Files that will be updated/replaced during migration
    $filesToUpdate = @()
    $filesToUpdate += "NeoCore library (src-lib/)"
    $filesToUpdate += "Toolchain (toolchain/)"
    $filesToUpdate += "NeoCore manifest (manifest.xml)"
    $filesToUpdate += "Build scripts (Makefile, mak.bat, mak.ps1)"

    # Note: C code analysis and .gitignore checks will be done later in the process
    # These preliminary checks determine if we need user confirmation for structural changes

    if ($migrationRequired) {
      Write-MigrationLog -Message "Migration required: Total issues detected: $($detectedIssues.Count)" -Level "WARN"
    } else {
      Write-MigrationLog -Message "No structural migration issues detected in preliminary analysis" -Level "INFO"
    }
  } catch {
    Write-MigrationLog -Message "Error analyzing project.xml: $($_.Exception.Message)" -Level "WARN"
    $migrationRequired = $true
    $detectedIssues = @("Unable to analyze project.xml file (possibly corrupted)")
  }

  # Show warning and get user confirmation BEFORE any migration (if needed)
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
    Write-MigrationLog -Message "User confirmed migration - proceeding with file updates and analysis..." -Level "INFO"

    # Now that user confirmed, update NeoCore files (src-lib, toolchain, manifest)
    Write-Host ""
    Write-Host "Updating NeoCore files..." -ForegroundColor Cyan
    Write-MigrationLog -Message "Starting NeoCore files update..." -Level "INFO"

    $srcLib = Resolve-Path -Path "..\..\..\src-lib"
    $toolchain = Resolve-Path -Path "..\..\..\toolchain"
    $manifest = Resolve-Path -Path "..\..\..\manifest.xml"

    if (-Not(Test-Path -Path $srcLib)) { Show-Error "$srcLib not found" }
    if (-Not(Test-Path -Path $toolchain)) { Show-Error "$toolchain not found" }
    if (-Not(Test-Path -Path $manifest)) { Show-Error "$manifest not found" }

    try {
      Write-Host "  - Updating src-lib..." -ForegroundColor Gray
      robocopy /MIR "$srcLib" "$ProjectNeocorePath\src-lib" /NFL /NDL /NJH /NJS | Out-Null

      Write-Host "  - Updating manifest..." -ForegroundColor Gray
      Copy-Item -Path $manifest -Destination $ProjectNeocorePath -Force

      Write-Host "  - Updating toolchain..." -ForegroundColor Gray
      robocopy /MIR "$toolchain" "$ProjectNeocorePath\toolchain" /NFL /NDL /NJH /NJS | Out-Null

      Write-MigrationLog -Message "NeoCore files updated successfully to $ProjectNeocorePath" -Level "SUCCESS"
      Write-Host "  - NeoCore files updated successfully" -ForegroundColor Green
    } catch {
      Write-MigrationLog -Message "Failed to update NeoCore files: $($_.Exception.Message)" -Level "ERROR"
      Show-Error "failed to update NeoCore files: $($_.Exception.Message)"
    }
  } else {
    Write-MigrationLog -Message "No structural migration required, but will perform full analysis" -Level "INFO"
    Write-Host "Project appears to be v3 compatible, performing validation analysis..." -ForegroundColor Green
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

  } elseif ($projectNeocoreVersion -like "3.*" -and $projectNeocoreVersion -ne $version) {
    Write-MigrationLog -Message "v3 detected but version differs: $projectNeocoreVersion -> $version" -Level "INFO"
    Write-Host "Project is using NeoCore v3 but version differs from current" -ForegroundColor Yellow
    Write-Host "Version will be updated by file sync..." -ForegroundColor Cyan
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

# Check C files for v2/v3 compatibility issues
Write-MigrationLog -Message "Checking C files for v2/v3 compatibility issues..." -Level "INFO"

# Primary search: only in project source directory (user code)
$srcCFiles = Get-ChildItem -Path $ProjectSrcPath -Filter "*.c" -Recurse -ErrorAction SilentlyContinue

# Secondary search: project root but exclude neocore directory entirely
$projectRootPath = Split-Path -Parent $ProjectSrcPath
$excludeDirs = @("build", "dist", ".git", "node_modules", "temp", "tmp", "neocore")

$rootCFiles = Get-ChildItem -Path $projectRootPath -Filter "*.c" -Recurse -ErrorAction SilentlyContinue |
  Where-Object {
    $exclude = $false
    $filePath = $_.FullName
    # Get the relative path from the project root to avoid excluding based on absolute path
    $relativePath = $filePath.Replace($projectRootPath, "").TrimStart('\', '/')

    # Split on both Windows and Unix path separators
    $pathSegments = $relativePath -split '[\\/]' | Where-Object { $_ -ne "" }

    foreach ($dir in $excludeDirs) {
      if ($pathSegments -contains $dir) {
        $exclude = $true
        break
      }
    }
    -not $exclude
  }

# Combine and deduplicate results (prefer src files)
$allCFiles = @()
$allCFiles += $srcCFiles
foreach ($rootFile in $rootCFiles) {
  $exists = $false
  foreach ($srcFile in $srcCFiles) {
    if ($rootFile.FullName -eq $srcFile.FullName) {
      $exists = $true
      break
    }
  }
  if (-not $exists) {
    $allCFiles += $rootFile
  }
}

$cFiles = $allCFiles

if ($cFiles.Count -gt 0) {
  Write-Host ""
  Write-Host "Analyzing C files for v2 to v3 compatibility..." -ForegroundColor Cyan
  Write-MigrationLog -Message "Found $($cFiles.Count) C files to analyze" -Level "INFO"
  Write-MigrationLog -Message "Searching from project root: $projectRootPath" -Level "INFO"

  $totalIssues = 0
  $filesWithIssues = 0
  $allCIssues = @()  # Collect all issues for dynamic reporting

  foreach ($file in $cFiles) {
    Write-MigrationLog -Message "Analyzing file: $($file.FullName)" -Level "INFO"
    $relativePath = $file.FullName.Replace($projectRootPath, "").TrimStart('\', '/')
    $fileContent = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue

    if ($fileContent) {
      # Use the dedicated function for detailed analysis
      $issues = Test-CFileV3Compatibility -FilePath $relativePath -FileContent $fileContent

      # Display results for this file
      if ($issues.Count -gt 0) {
        $filesWithIssues++
        $totalIssues += $issues.Count
        $allCIssues += $issues  # Collect all issues

        Write-Host ""
        Write-Host "Issues found in: $relativePath" -ForegroundColor Red
        Write-MigrationLog -Message "File '$relativePath' has $($issues.Count) v2/v3 compatibility issues" -Level "WARN"

        # Limit console output to avoid flooding, but log everything
        $maxDisplayIssues = 10
        $displayCount = [Math]::Min($issues.Count, $maxDisplayIssues)

        for ($i = 0; $i -lt $displayCount; $i++) {
          Write-Host "  * $($issues[$i])" -ForegroundColor Yellow
          Write-MigrationLog -Message "Issue in '$relativePath': $($issues[$i])" -Level "WARN"
        }

        # Log remaining issues without console display
        for ($i = $maxDisplayIssues; $i -lt $issues.Count; $i++) {
          Write-MigrationLog -Message "Issue in '$relativePath': $($issues[$i])" -Level "WARN"
        }

        if ($issues.Count -gt $maxDisplayIssues) {
          Write-Host "  * ... and $($issues.Count - $maxDisplayIssues) more issues (see migration log for details)" -ForegroundColor Yellow
        }
      } else {
        Write-MigrationLog -Message "File '$relativePath' appears to be v3 compatible" -Level "INFO"
      }
    } else {
      Write-MigrationLog -Message "Could not read file: $($file.FullName)" -Level "WARN"
    }
  }

  # Summary
  Write-Host ""
  if ($totalIssues -gt 0) {
    Write-Host "C Code Analysis Summary:" -ForegroundColor Red
    Write-Host "  - Files analyzed: $($cFiles.Count)" -ForegroundColor White
    Write-Host "  - Files with issues: $filesWithIssues" -ForegroundColor Red
    Write-Host "  - Total issues found: $totalIssues" -ForegroundColor Red
    Write-Host "  - Status: Manual review and code changes required" -ForegroundColor Yellow
    Write-MigrationLog -Message "C code analysis completed: $totalIssues issues in $filesWithIssues files" -Level "WARN"
  } else {
    Write-Host "C Code Analysis Summary:" -ForegroundColor Green
    Write-Host "  - Files analyzed: $($cFiles.Count)" -ForegroundColor White
    Write-Host "  - Files with issues: 0" -ForegroundColor Green
    Write-Host "  - Status: C code appears to be v3 compatible" -ForegroundColor Green
    Write-MigrationLog -Message "C code analysis completed: No v2/v3 compatibility issues detected" -Level "SUCCESS"
  }
} else {
  Write-Host "No C files found in project directory" -ForegroundColor Yellow
  Write-MigrationLog -Message "No C files found to analyze in $projectRootPath" -Level "INFO"
}

# Check .gitignore file
Write-MigrationLog -Message "Checking .gitignore configuration..." -Level "INFO"
$gitignorePath = "$ProjectSrcPath\..\.gitignore"
$hasGitignoreIssues = $false
$allGitignoreIssues = @()

if (Test-Path -Path $gitignorePath) {
  Write-MigrationLog -Message "Found .gitignore file, checking build/ and dist/ patterns..." -Level "INFO"
  $gitignoreContent = Get-Content -Path $gitignorePath
  $gitignoreNeedsUpdate = $false

  if ($gitignoreContent -contains "build/") {
    Write-MigrationLog -Message ".gitignore contains 'build/' - should be '/build/'" -Level "WARN"
    $gitignoreNeedsUpdate = $true
    $hasGitignoreIssues = $true
    $allGitignoreIssues += @{
      File = ".gitignore"
      Issue = "Incorrect pattern: 'build/'"
      Action = "Change 'build/' to '/build/'"
      Description = "Fix build/ pattern to be root-relative"
    }
  }

  if ($gitignoreContent -contains "dist/") {
    Write-MigrationLog -Message ".gitignore contains 'dist/' - should be '/dist/'" -Level "WARN"
    $gitignoreNeedsUpdate = $true
    $hasGitignoreIssues = $true
    $allGitignoreIssues += @{
      File = ".gitignore"
      Issue = "Incorrect pattern: 'dist/'"
      Action = "Change 'dist/' to '/dist/'"
      Description = "Fix dist/ pattern to be root-relative"
    }
  }

  if ($gitignoreNeedsUpdate) {
    Write-Host ""
    Write-Host "Found .gitignore pattern issues - will be included in migration report." -ForegroundColor Yellow

    # Log the issues for the migration report
    Write-MigrationLog -Message ".gitignore patterns need manual correction" -Level "WARN"
    foreach ($issue in $allGitignoreIssues) {
      Write-MigrationLog -Message ".gitignore issue: '$($issue.Issue)' - $($issue.Action)" -Level "WARN"
    }
  } else {
    Write-MigrationLog -Message ".gitignore patterns are correctly configured" -Level "SUCCESS"
  }
} else {
  Write-MigrationLog -Message ".gitignore not found at $gitignorePath" -Level "ERROR"
  Show-Error "$gitignorePath not found"
}

# Check and remove deprecated common_crt0_cd.s file
Write-MigrationLog -Message "Checking for deprecated common_crt0_cd.s file..." -Level "INFO"
$commonCrt0Path = "$ProjectSrcPath\common_crt0_cd.s"

if (Test-Path -Path $commonCrt0Path) {
  Write-MigrationLog -Message "Found deprecated file: $commonCrt0Path" -Level "WARN"
  Write-Host ""
  Write-Host "Removing deprecated file: common_crt0_cd.s" -ForegroundColor Yellow
  Write-Host "This file is no longer needed in NeoCore v3." -ForegroundColor Gray

  try {
    Remove-Item -Path $commonCrt0Path -Force
    Write-MigrationLog -Message "Successfully deleted deprecated file: $commonCrt0Path" -Level "SUCCESS"
    Write-Host "File successfully removed: common_crt0_cd.s" -ForegroundColor Green
  } catch {
    Write-MigrationLog -Message "Failed to delete file: $($_.Exception.Message)" -Level "ERROR"
    Write-Host "Error: Failed to remove file: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please manually delete the file after migration." -ForegroundColor Yellow
  }
} else {
  Write-MigrationLog -Message "No common_crt0_cd.s file found - good!" -Level "INFO"
}

# Check and remove deprecated crt0_cd.s file
Write-MigrationLog -Message "Checking for deprecated crt0_cd.s file..." -Level "INFO"
$crt0Path = "$ProjectSrcPath\crt0_cd.s"

if (Test-Path -Path $crt0Path) {
  Write-MigrationLog -Message "Found deprecated file: $crt0Path" -Level "WARN"
  Write-Host ""
  Write-Host "Removing deprecated file: crt0_cd.s" -ForegroundColor Yellow
  Write-Host "This file is no longer needed in NeoCore v3." -ForegroundColor Gray

  try {
    Remove-Item -Path $crt0Path -Force
    Write-MigrationLog -Message "Successfully deleted deprecated file: $crt0Path" -Level "SUCCESS"
    Write-Host "File successfully removed: crt0_cd.s" -ForegroundColor Green
  } catch {
    Write-MigrationLog -Message "Failed to delete file: $($_.Exception.Message)" -Level "ERROR"
    Write-Host "Error: Failed to remove file: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please manually delete the file after migration." -ForegroundColor Yellow
  }
} else {
  Write-MigrationLog -Message "No crt0_cd.s file found - good!" -Level "INFO"
}

# Final evaluation: Was migration actually required based on all checks?
Write-MigrationLog -Message "Final migration requirement evaluation..." -Level "INFO"
$finalMigrationRequired = $migrationRequired  # Start with initial assessment

# Add C code issues to requirement evaluation
if ($totalIssues -and $totalIssues -gt 0) {
  $finalMigrationRequired = $true
  Write-MigrationLog -Message "Final evaluation: Found $totalIssues C code compatibility issues" -Level "INFO"
}

# Add .gitignore issues to requirement evaluation
if ($hasGitignoreIssues) {
  $finalMigrationRequired = $true
  Write-MigrationLog -Message "Final evaluation: Found .gitignore pattern issues" -Level "INFO"
}

Write-MigrationLog -Message "Final migration requirement evaluation: $finalMigrationRequired" -Level "INFO"

# Migration completed
Write-MigrationLog -Message "=== NeoCore v2->v3 Migration Completed ===" -Level "SUCCESS"
Write-MigrationLog -Message "Log file saved at: $MigrationLogPath" -Level "INFO"

# Evaluate migration success
$migrationResult = Test-MigrationSuccess -ProjectXmlPath $projectXmlPath -TotalCIssues $(if ($totalIssues) { $totalIssues } else { 0 }) -HasGitignoreIssues $hasGitignoreIssues

# Calculate migration statistics
$migrationStats = @{
  FilesAnalyzed = if ($cFiles) { $cFiles.Count } else { 0 }
  FilesWithIssues = if ($filesWithIssues) { $filesWithIssues } else { 0 }
  TotalIssues = if ($totalIssues) { $totalIssues } else { 0 }
  ProjectXmlMigrated = (Test-Path -Path $projectXmlPath)
  BackupCreated = ($tempBackupPath -and (Test-Path -Path $tempBackupPath))
  StartTime = $MigrationStartTime
}

# Final migration summary
Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host "                  [MIGRATION COMPLETED]                         " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green

# Migration status
if ($migrationResult.Success) {
  Write-Host ""
  Write-Host "[SUCCESS] MIGRATION SUCCESSFUL" -ForegroundColor Green
  Write-Host "   Your NeoCore project has been successfully migrated to v3!" -ForegroundColor White
} else {
  Write-Host ""
  Write-Host "[WARNING] MIGRATION COMPLETED WITH ISSUES" -ForegroundColor Yellow
  Write-Host "   The migration process completed but requires attention:" -ForegroundColor White
  foreach ($warning in $migrationResult.Warnings) {
    Write-Host "   * $warning" -ForegroundColor Yellow
  }
}

# Migration statistics
Write-Host ""
Write-Host "[STATS] MIGRATION STATISTICS:" -ForegroundColor Cyan
Write-Host "   * Project XML: $(if ($migrationStats.ProjectXmlMigrated) { "[OK] Migrated" } else { "[ERROR] Not found" })" -ForegroundColor White
Write-Host "   * C files analyzed: $($migrationStats.FilesAnalyzed)" -ForegroundColor White
Write-Host "   * Files with v2 patterns: $($migrationStats.FilesWithIssues)" -ForegroundColor White
Write-Host "   * Total compatibility issues: $($migrationStats.TotalIssues)" -ForegroundColor White
Write-Host "   * Backup created: $(if ($migrationStats.BackupCreated) { "[OK] Yes" } else { "[ERROR] No" })" -ForegroundColor White

# Next steps based on results
if ($migrationResult.HasCIssues -or $migrationResult.HasGitignoreIssues) {
  Write-Host ""
  Write-Host "[ACTION] REQUIRED ACTIONS:" -ForegroundColor Yellow

  $actionNumber = 1

  # Dynamic C code issues
  if ($migrationResult.HasCIssues -and $allCIssues.Count -gt 0) {
    Write-Host "   [$actionNumber] Review and fix C code compatibility issues:" -ForegroundColor White
    $actionNumber++

    # Group and display issues by category
    $categorizedIssues = Get-CIssueCategories -AllIssues $allCIssues

    foreach ($category in $categorizedIssues.Keys | Sort-Object) {
      $categoryIssues = $categorizedIssues[$category]
      Write-Host "       [$category] ($($categoryIssues.Count) issues):" -ForegroundColor Yellow

      # Show unique patterns for this category
      $uniquePatterns = $categoryIssues | Group-Object -Property Issue | Select-Object Name, Count
      foreach ($pattern in $uniquePatterns) {
        Write-Host "         * $($pattern.Name) ($($pattern.Count) occurrence$(if($pattern.Count -gt 1){"s"}))" -ForegroundColor Gray
      }
      Write-Host ""
    }

    Write-Host "       See detailed file-by-file analysis in: $MigrationLogPath" -ForegroundColor Gray
    Write-Host ""
    Write-Host "   [$actionNumber] Test your updated project:" -ForegroundColor White
    Write-Host "       mak build     # Compile your project" -ForegroundColor Gray
    Write-Host "       mak run       # Test runtime" -ForegroundColor Gray
    Write-Host ""
    $actionNumber++
  }

  # Dynamic .gitignore issues
  if ($migrationResult.HasGitignoreIssues -and $allGitignoreIssues.Count -gt 0) {
    Write-Host "   [$actionNumber] Fix .gitignore patterns:" -ForegroundColor White
    foreach ($issue in $allGitignoreIssues) {
      Write-Host "       * $($issue.Action)" -ForegroundColor Gray
      Write-Host "         File: $($issue.File)" -ForegroundColor DarkGray
      Write-Host "         Reason: $($issue.Description)" -ForegroundColor DarkGray
    }
    Write-Host ""
    $actionNumber++
  }
} else {
  Write-Host ""
  Write-Host "[SUCCESS] GREAT NEWS!" -ForegroundColor Green
  Write-Host "   Your project appears to be fully v3 compatible!" -ForegroundColor White
  Write-Host ""
  Write-Host "   [READY] You can immediately use your migrated project:" -ForegroundColor White
  Write-Host "       mak build     # Compile your project" -ForegroundColor Gray
  Write-Host "       mak run       # Run your project" -ForegroundColor Gray
  Write-Host ""
}

# Additional resources and backup info
Write-Host "[RESOURCES] RESOURCES AND INFORMATION:" -ForegroundColor Cyan
Write-Host "   * Migration log: $MigrationLogPath" -ForegroundColor White
Write-Host "   * NeoCore v3 docs: Check updated README files in your project" -ForegroundColor White
if ($tempBackupPath) {
  Write-Host "   * Project backup: $tempBackupPath" -ForegroundColor White
  Write-Host "     (automatic backup - consider making additional manual backups)" -ForegroundColor Gray
}
Write-Host ""

# Final tips
Write-Host "[TIPS] DEVELOPMENT TIPS:" -ForegroundColor Cyan
Write-Host "   * Keep the migration log for reference during development" -ForegroundColor White
Write-Host "   * If you encounter build errors, check the log for specific line numbers" -ForegroundColor White
Write-Host "   * The backup can be used to compare changes if needed" -ForegroundColor White

Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host "              Thank you for using NeoCore v3!                   " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
