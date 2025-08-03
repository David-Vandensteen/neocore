param (
  [Parameter(Mandatory=$true)]
  [string]$ProjectSrcPath,

  [Parameter(Mandatory=$true)]
  [string]$ProjectNeocorePath
)

function Show-Error {
  param ($message)
  Write-Host "error: $message" -ForegroundColor Red
  exit 1
}

function Test-ProjectXmlV3Compatibility {
  param (
    [Parameter(Mandatory=$true)]
    [xml]$ProjectXml,
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath
  )

  $issues = @()
  $warnings = @()

  # Check for missing platform element (v3 requirement)
  $platformNode = $ProjectXml.SelectSingleNode("//platform")
  if (-not $platformNode) {
    $issues += "Missing <platform> element - required for v3 compatibility"
  } elseif ([string]::IsNullOrWhiteSpace($platformNode.InnerText)) {
    $issues += "Empty <platform> element - should specify target platform (e.g., 'cd')"
  }

  # Check for missing DAT setup elements (v3 requirements)
  $datSetupNode = $ProjectXml.SelectSingleNode("//DAT//chardata//setup")
  if ($datSetupNode) {
    $requiredDatElements = @("charfile", "mapfile", "palfile", "incfile", "incprefix")
    $missingDatElements = @()

    foreach ($elementName in $requiredDatElements) {
      $existingElement = $datSetupNode.SelectSingleNode($elementName)
      if (-not $existingElement) {
        $missingDatElements += $elementName
      }
    }

    if ($missingDatElements.Count -gt 0) {
      $issues += "Missing DAT setup elements: $($missingDatElements -join ', ') - required for v3 DAT processing"
    }
  }

  # Check for missing fixdata section (v3 requirement)
  $datNode = $ProjectXml.SelectSingleNode("//DAT")
  if ($datNode) {
    $fixdataNode = $datNode.SelectSingleNode("fixdata")
    if (-not $fixdataNode) {
      $issues += "Missing fixdata section - required for v3 fix font processing"
    }
  }

  # Check for missing RAINE config section (v3 requirement)
  $raineNode = $ProjectXml.SelectSingleNode("//emulator/raine")
  if ($raineNode) {
    $configNode = $raineNode.SelectSingleNode("config")
    if (-not $configNode) {
      $issues += "Missing RAINE config section - required for v3 emulator configurations"
    }
  }

  # Check for missing MAME profile section (v3 requirement)
  $mameNode = $ProjectXml.SelectSingleNode("//emulator/mame")
  if ($mameNode) {
    $profileNode = $mameNode.SelectSingleNode("profile")
    if (-not $profileNode) {
      $issues += "Missing MAME profile section - required for v3 emulator configurations"
    }
  }

  # Check for missing compiler elements (v3 requirements)
  $compilerNode = $ProjectXml.SelectSingleNode("//compiler")
  if ($compilerNode) {
    $crtPathNode = $compilerNode.SelectSingleNode("crtPath")
    if (-not $crtPathNode) {
      $issues += "Missing compiler <crtPath> element - required for v3 compilation"
    }

    # Check systemFile structure (v3 format)
    $systemFileNode = $compilerNode.SelectSingleNode("systemFile")
    if (-not $systemFileNode) {
      $issues += "Missing systemFile section - required for v3 compilation"
    } else {
      $cdNode = $systemFileNode.SelectSingleNode("cd")
      $cartridgeNode = $systemFileNode.SelectSingleNode("cartridge")
      if (-not $cdNode -or -not $cartridgeNode) {
        $issues += "systemFile structure needs v3 update (missing cd/cartridge elements)"
      }
    }
  }

  # Check for old commented sound section (v2 legacy to remove)
  $xmlContent = $ProjectXml.OuterXml
  if ($xmlContent -match '<!--\s*To use CDDA audio tracks, uncomment and set up your files\.[\s\S]*?</sound>\s*-->') {
    $warnings += "Found old commented sound section (v2 legacy) - will be removed during migration"
  }  # Check for deprecated DAT configuration patterns
  $oldDatPatterns = $ProjectXml.SelectNodes("//DAT//setup[starting_tile]")
  if ($oldDatPatterns.Count -gt 0) {
    $warnings += "Found deprecated DAT setup with starting_tile - may need v3 DAT configuration update"
  }

  # Check for old emulator paths
  $raineExe = $ProjectXml.SelectSingleNode("//raine/exeFile")
  if ($raineExe -and $raineExe.InnerText -like "*raine32.exe*") {
    $warnings += "RAINE executable path may need updating for v3"
  }

  # Note: We no longer force template variables - just provide informational warnings
  # Check for potential template opportunities (informational only)
  $buildPath = $ProjectXml.SelectSingleNode("//buildPath")
  if ($buildPath -and $buildPath.InnerText -notlike "*{{neocore}}*" -and $buildPath.InnerText -like "*..\..\build*") {
    $warnings += "buildPath could use {{neocore}} template for better portability (optional)"
  }

  $includePath = $ProjectXml.SelectSingleNode("//compiler/includePath")
  if ($includePath -and $includePath.InnerText -notlike "*{{neocore}}*" -and $includePath.InnerText -like "*..\..\src-lib\include*") {
    $warnings += "includePath could use {{neocore}} template for better portability (optional)"
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
  Write-Host "  - Rewriting project.xml with v3 template structure..." -ForegroundColor Yellow

  # Get existing values to preserve user data
  $existingName = ""
  $existingVersion = "1.0.0"
  $existingNeocorePath = "..\neocore"
  $existingBuildPath = "{{neocore}}\build"
  $existingDistPath = "{{neocore}}\dist"
  $existingCompilerPath = "{{build}}\gcc\gcc-2.95.2"
  $existingIncludePath = "{{neocore}}\src-lib\include"
  $existingLibraryPath = "{{build}}\lib"
  $existingRaineExe = "{{build}}\raine\raine32.exe"
  $existingMameExe = "{{build}}\mame\mame64.exe"

  $nameNode = $ProjectXml.SelectSingleNode("//name")
  if ($nameNode) { $existingName = $nameNode.InnerText }

  $versionNode = $ProjectXml.SelectSingleNode("//version")
  if ($versionNode) { $existingVersion = $versionNode.InnerText }

  $neocorePathNode = $ProjectXml.SelectSingleNode("//neocorePath")
  if ($neocorePathNode) { $existingNeocorePath = $neocorePathNode.InnerText }

  # Preserve existing paths if they exist
  $buildPathNode = $ProjectXml.SelectSingleNode("//buildPath")
  if ($buildPathNode) { $existingBuildPath = $buildPathNode.InnerText }

  $distPathNode = $ProjectXml.SelectSingleNode("//distPath")
  if ($distPathNode) { $existingDistPath = $distPathNode.InnerText }

  $compilerPathNode = $ProjectXml.SelectSingleNode("//compiler/path")
  if ($compilerPathNode) { $existingCompilerPath = $compilerPathNode.InnerText }

  $includePathNode = $ProjectXml.SelectSingleNode("//compiler/includePath")
  if ($includePathNode) { $existingIncludePath = $includePathNode.InnerText }

  # Force includePath to v3 standard value (always use template)
  $existingIncludePath = "{{neocore}}\src-lib\include"

  $libraryPathNode = $ProjectXml.SelectSingleNode("//compiler/libraryPath")
  if ($libraryPathNode) { $existingLibraryPath = $libraryPathNode.InnerText }

  $raineExeNode = $ProjectXml.SelectSingleNode("//emulator/raine/exeFile")
  if ($raineExeNode) { $existingRaineExe = $raineExeNode.InnerText }

  $mameExeNode = $ProjectXml.SelectSingleNode("//emulator/mame/exeFile")
  if ($mameExeNode) { $existingMameExe = $mameExeNode.InnerText }

  # Create completely new v3 structure
  $newXmlContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<project>
  <name>$existingName</name>
  <version>$existingVersion</version>
  <platform>cd</platform>
  <makefile>Makefile</makefile>
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
    $newXmlContent | Out-File -FilePath $ProjectXmlPath -Encoding UTF8 -Force
    Write-Host "  - Project.xml rewritten with complete v3 structure" -ForegroundColor Green
    Write-Host "  - Preserved existing name: '$existingName'" -ForegroundColor Green
    Write-Host "  - Preserved existing version: '$existingVersion'" -ForegroundColor Green
    Write-Host "  - Preserved existing neocorePath: '$existingNeocorePath'" -ForegroundColor Green
    Write-Host "  - Preserved existing buildPath: '$existingBuildPath'" -ForegroundColor Green
    Write-Host "  - Preserved existing compiler paths" -ForegroundColor Green
    return $true
  } catch {
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

  if (Test-Path -Path $ProjectManifestPath) {
    try {
      [xml]$projectManifest = Get-Content -Path $ProjectManifestPath
      $oldVersion = $projectManifest.manifest.version

      if ($oldVersion -ne $NewVersion) {
        # Create backup
        $backupPath = "$ProjectManifestPath.v2.backup"
        Copy-Item -Path $ProjectManifestPath -Destination $backupPath -Force

        # Update version
        $projectManifest.manifest.version = $NewVersion
        $projectManifest.Save($ProjectManifestPath)

        Write-Host "  - Updated project manifest.xml version: $oldVersion to $NewVersion" -ForegroundColor Green
        return $true
      } else {
        Write-Host "  - Project manifest.xml version is already up to date ($NewVersion)" -ForegroundColor Green
        return $false
      }
    } catch {
      Write-Host "Warning: Could not update project manifest.xml: $($_.Exception.Message)" -ForegroundColor Yellow
      return $false
    }
  } else {
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
  exit 1
}

# Project XML Migration Logic
$projectXmlPath = "$ProjectSrcPath\project.xml"
$projectManifestPath = "$ProjectSrcPath\..\manifest.xml"

if (Test-Path -Path $projectXmlPath) {
  Write-Host ""
  Write-Host "Analyzing project for v3 migration..." -ForegroundColor Cyan

  # Check project's current NeoCore version
  $projectNeocoreVersion = "Unknown"
  $migrationRequired = $false

  if (Test-Path -Path $projectManifestPath) {
    try {
      [xml]$projectManifest = Get-Content -Path $projectManifestPath
      $projectNeocoreVersion = $projectManifest.manifest.version
      Write-Host "Project's current NeoCore version: $projectNeocoreVersion" -ForegroundColor Yellow

      # Check if migration from v2 to v3 is needed
      if ($projectNeocoreVersion -like "2.*") {
        $migrationRequired = $true
        Write-Host "Migration from v2 to v3 is required!" -ForegroundColor Red

        # Always update manifest version when migrating from v2 to v3
        Write-Host "Updating project manifest to v3..." -ForegroundColor Cyan
        $manifestUpdated = Update-ProjectManifestVersion -ProjectManifestPath $projectManifestPath -NewVersion $version
        $projectNeocoreVersion = $version # Update the displayed version

      } elseif ($projectNeocoreVersion -like "3.*" -and $projectNeocoreVersion -ne $version) {
        Write-Host "Project is using NeoCore v3 but version differs from current" -ForegroundColor Yellow
        Write-Host "Updating to latest v3 version..." -ForegroundColor Cyan
        $manifestUpdated = Update-ProjectManifestVersion -ProjectManifestPath $projectManifestPath -NewVersion $version
        $projectNeocoreVersion = $version
        $migrationRequired = $false # No structural migration needed, just version update

      } elseif ($projectNeocoreVersion -eq $version) {
        Write-Host "Project is already using the current NeoCore version ($version)" -ForegroundColor Green
        $migrationRequired = $false

      } else {
        Write-Host "Warning: Unrecognized version format, proceeding with compatibility check..." -ForegroundColor Yellow
        $migrationRequired = $true
      }
    } catch {
      Write-Host "Warning: Could not read project manifest.xml: $($_.Exception.Message)" -ForegroundColor Yellow
      Write-Host "Proceeding with compatibility check..." -ForegroundColor Yellow
      $migrationRequired = $true
    }
  } else {
    Write-Host "Warning: Project manifest.xml not found at $projectManifestPath" -ForegroundColor Yellow
    Write-Host "Proceeding with compatibility check..." -ForegroundColor Yellow
    $migrationRequired = $true
  }

  try {
    # Load and analyze project.xml
    [xml]$projectXml = Get-Content -Path $projectXmlPath

    # Test compatibility (always run for detailed analysis)
    $compatibilityResult = Test-ProjectXmlV3Compatibility -ProjectXml $projectXml -ProjectPath $ProjectSrcPath

    if ($migrationRequired -and $compatibilityResult.Issues.Count -gt 0) {
      Write-Host ""
      Write-Host "v2 to v3 migration issues found:" -ForegroundColor Red
      foreach ($issue in $compatibilityResult.Issues) {
        Write-Host "  * $issue" -ForegroundColor Red
      }

      # Create backup
      $backupPath = "$projectXmlPath.v2.backup"
      Copy-Item -Path $projectXmlPath -Destination $backupPath -Force
      Write-Host ""
      Write-Host "Backup created: $backupPath" -ForegroundColor Yellow

      # Attempt automatic repair
      Write-Host "Attempting automatic v3 migration..." -ForegroundColor Cyan
      $repaired = Repair-ProjectXmlForV3 -ProjectXml $projectXml -ProjectXmlPath $projectXmlPath

      # Re-test after repairs
      [xml]$updatedXml = Get-Content -Path $projectXmlPath
      $retest = Test-ProjectXmlV3Compatibility -ProjectXml $updatedXml -ProjectPath $ProjectSrcPath

      if ($retest.IsCompatible) {
        Write-Host "project.xml is v3 compatible!" -ForegroundColor Green
      } else {
        Write-Host "Some issues remain - manual review recommended" -ForegroundColor Yellow
      }
    } elseif ($compatibilityResult.Issues.Count -eq 0) {
      if ($migrationRequired) {
        Write-Host "  - project.xml is already v3 compatible!" -ForegroundColor Green
      } else {
        Write-Host "  - project.xml is v3 compatible (no migration needed)" -ForegroundColor Green
      }
    }

    if ($compatibilityResult.Warnings.Count -gt 0) {
      Write-Host ""
      Write-Host "Warnings (manual review recommended):" -ForegroundColor Yellow
      foreach ($warning in $compatibilityResult.Warnings) {
        Write-Host "  * $warning" -ForegroundColor Yellow
      }
    }

    # Display project info
    $projectNameNode = $projectXml.SelectSingleNode("//name")
    $projectVersionNode = $projectXml.SelectSingleNode("//version")
    $projectPlatformNode = $projectXml.SelectSingleNode("//platform")

    $projectName = if ($projectNameNode) { $projectNameNode.InnerText } else { "Unknown" }
    $projectVersion = if ($projectVersionNode) { $projectVersionNode.InnerText } else { "Unknown" }
    $projectPlatform = if ($projectPlatformNode) { $projectPlatformNode.InnerText } else { "Unknown" }

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
      if ($compatibilityResult.IsCompatible) {
        Write-Host "  - Status: Migration Complete" -ForegroundColor Green
      } else {
        Write-Host "  - Status: Manual Review Required" -ForegroundColor Yellow
      }
    }

  } catch {
    Write-Host "Error: Could not parse project.xml: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please manually verify project.xml format" -ForegroundColor Yellow
  }
} else {
  Write-Host "Warning: project.xml not found at $projectXmlPath" -ForegroundColor Yellow
  Write-Host "This may not be a NeoCore project directory" -ForegroundColor Yellow
}

$gitignorePath = "$ProjectSrcPath\..\.gitignore"

if (Test-Path -Path $gitignorePath) {
  $gitignoreContent = Get-Content -Path $gitignorePath
  if ($gitignoreContent -notcontains "build/") {
  } else {
    Write-Host ""
    Write-Host "warning : the $gitignorePath file contains 'build/'" -ForegroundColor Yellow
    Write-Host "please change it to '/build/'" -ForegroundColor Yellow
  }
  if ($gitignoreContent -notcontains "dist/") {
  } else {
    Write-Host ""
    Write-Host "warning : the $gitignorePath file contains 'dist/'" -ForegroundColor Yellow
    Write-Host "please change it to '/dist/'" -ForegroundColor Yellow
  }
} else {
  Show-Error "$gitignorePath not found"
  exit 1
}
