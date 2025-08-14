# Migration-ProjectXml.ps1
# Project.xml migration and update functions

function Backup-ProjectFiles {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath
    )

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = "$ProjectSrcPath\..\backup_$timestamp"

    Write-MigrationLog -Message "Creating backup at: $backupPath" -Level "INFO"

    try {
        # Create backup directory
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null

        # Copy important files
        $filesToBackup = @(
            "$ProjectSrcPath\project.xml",
            "$ProjectSrcPath\mak.bat",
            "$ProjectSrcPath\mak.ps1",
            "$ProjectSrcPath\Makefile"
        )

        foreach ($file in $filesToBackup) {
            if (Test-Path $file) {
                $fileName = Split-Path $file -Leaf
                Copy-Item $file "$backupPath\$fileName" -Force
                Write-MigrationLog -Message "Backed up: $fileName" -Level "INFO"
            }
        }

        Write-MigrationLog -Message "Backup created successfully" -Level "SUCCESS"
        return $backupPath
    } catch {
        Write-MigrationLog -Message "Backup failed: $($_.Exception.Message)" -Level "ERROR"
        return $null
    }
}

function Update-ProjectFiles {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath,

        [Parameter(Mandatory=$true)]
        [string]$NeocorePath
    )

    Write-MigrationLog -Message "Updating project files..." -Level "INFO"

    # Source files from NeoCore bootstrap (excluding Makefile which is handled separately)
    $sourceFiles = @{
        "mak.bat" = "$NeocorePath\bootstrap\standalone\mak.bat"
        "mak.ps1" = "$NeocorePath\bootstrap\standalone\mak.ps1"
    }

    $updated = @()
    $errors = @()

    foreach ($fileName in $sourceFiles.Keys) {
        $sourcePath = $sourceFiles[$fileName]
        $destPath = "$ProjectSrcPath\$fileName"

        if (Test-Path $sourcePath) {
            try {

                Copy-Item -Path $sourcePath -Destination $destPath -Force
                Write-MigrationLog -Message "Updated: $fileName" -Level "INFO"
                $updated += $fileName
            } catch {
                $errorMsg = "Failed to update $fileName`: $($_.Exception.Message)"
                Write-MigrationLog -Message $errorMsg -Level "ERROR"
                $errors += $errorMsg
            }
        } else {
            $errorMsg = "Source file not found: $sourcePath"
            Write-MigrationLog -Message $errorMsg -Level "ERROR"
            $errors += $errorMsg
        }
    }

    if ($errors.Count -gt 0) {
        Show-Error "Failed to update some files: $($errors -join '; ')"
    }

    Write-MigrationLog -Message "Updated $($updated.Count) files successfully" -Level "SUCCESS"
    return $updated
}

function ConvertTo-ProjectXmlV3 {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectXmlPath,

        [Parameter(Mandatory=$true)]
        [xml]$CurrentXml
    )

    Write-MigrationLog -Message "Converting project.xml to v3 format..." -Level "INFO"

    # Extract existing values
    $nameNode = $CurrentXml.SelectSingleNode("//name")
    $versionNode = $CurrentXml.SelectSingleNode("//version")
    $platformNode = $CurrentXml.SelectSingleNode("//platform")
    $raineNode = $CurrentXml.SelectSingleNode("//raine/exeFile")
    $mameNode = $CurrentXml.SelectSingleNode("//mame/exeFile")

    $existingValues = @{
        ProjectName = if ($nameNode) { $nameNode.InnerText } else { "DefaultProject" }
        ProjectVersion = if ($versionNode) { $versionNode.InnerText } else { "1.0.0" }
        Platform = if ($platformNode) { $platformNode.InnerText } else { "cd" }
        RaineExe = if ($raineNode) { $raineNode.InnerText } else { "{{build}}\raine\raine32.exe" }
        MameExe = if ($mameNode) { $mameNode.InnerText } else { "{{build}}\mame\mame64.exe" }
    }

    $compilerPathNode = $CurrentXml.SelectSingleNode("//compiler/path")
    $includePathNode = $CurrentXml.SelectSingleNode("//compiler/includePath")
    $libraryPathNode = $CurrentXml.SelectSingleNode("//compiler/libraryPath")

    $existingValues.CompilerPath = if ($compilerPathNode) { $compilerPathNode.InnerText } else { "{{build}}\gcc\gcc-2.95.2" }
    $existingValues.IncludePath = if ($includePathNode) { $includePathNode.InnerText } else { "{{neocore}}\src-lib\include" }
    $existingValues.LibraryPath = if ($libraryPathNode) { $libraryPathNode.InnerText } else { "{{neocore}}\src-lib" }

    Write-MigrationLog -Message "Extracted project values: $($existingValues.ProjectName) v$($existingValues.ProjectVersion)" -Level "INFO"

    # Generate v3 XML structure
    $v3XmlTemplate = @"
<?xml version="1.0" encoding="UTF-8"?>
<project>
  <name>$($existingValues.ProjectName)</name>
  <version>$($existingValues.ProjectVersion)</version>
  <platform>$($existingValues.Platform)</platform>
  <neocorePath>{{neocore}}</neocorePath>
  <buildPath>{{neocore}}\build</buildPath>
  <makefile>..\Makefile</makefile>
  <gfx>
    <DAT>
      <chardata>
        <setup fileType="char">
          <charfile>out\char.bin</charfile>
          <mapfile>out\charMaps.s</mapfile>
          <palfile>out\charPals.s</palfile>
          <incfile>out\charData.h</incfile>
          <incprefix>../</incprefix>
        </setup>
        <import bank="0">
          <file>assets\sprites\sprites.bmp</file>
        </import>
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
      <exeFile>$($existingValues.RaineExe)</exeFile>
      <config>
        <default>{{build}}\raine\config\default.cfg</default>
        <full>{{build}}\raine\config\fullscreen.cfg</full>
        <yuv>{{build}}\raine\config\yuv.cfg</yuv>
      </config>
    </raine>
    <mame>
      <exeFile>$($existingValues.MameExe)</exeFile>
      <profile>
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
    <path>$($existingValues.CompilerPath)</path>
    <includePath>$($existingValues.IncludePath)</includePath>
    <libraryPath>$($existingValues.LibraryPath)</libraryPath>
    <crtPath>{{neocore}}\src-lib\crt</crtPath>
    <systemFile>
      <cd>{{neocore}}\src-lib\system\neocd.x</cd>
      <cartridge>{{neocore}}\src-lib\system\neocart.x</cartridge>
    </systemFile>
  </compiler>
</project>
"@

    # Write the new XML content
    try {
        Write-MigrationLog -Message "Writing v3 project.xml structure..." -Level "INFO"
        $v3XmlTemplate | Out-File -FilePath $ProjectXmlPath -Encoding UTF8 -Force
        Write-MigrationLog -Message "Successfully converted project.xml to v3 format" -Level "SUCCESS"
        return $true
    } catch {
        Write-MigrationLog -Message "Error writing v3 project.xml: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

function Show-MigrationWarning {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath,

        [Parameter(Mandatory=$true)]
        [string]$ProjectNeocorePath,

        [Parameter(Mandatory=$true)]
        [string]$CurrentVersion,

        [Parameter(Mandatory=$true)]
        [string]$TargetVersion,

        [array]$AutomaticActions = @(),
        [array]$ManualActions = @(),
        [string]$BackupPath = ""
    )

    Write-MigrationLog -Message "Displaying migration warning to user" -Level "INFO"

    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Yellow
    Write-Host "                    [WARNING] MIGRATION ALERT [WARNING]         " -ForegroundColor Red
    Write-Host "================================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "This script will perform a comprehensive migration of your NeoCore project." -ForegroundColor White
    Write-Host ""
    Write-Host "[PROJECT] PROJECT TO MIGRATE:" -ForegroundColor Cyan
    Write-Host "   * Source folder: $ProjectSrcPath" -ForegroundColor Gray
    Write-Host "   * NeoCore folder: $ProjectNeocorePath" -ForegroundColor Gray
    Write-Host ""
    Write-Host "[VERSION] MIGRATION:" -ForegroundColor Cyan
    Write-Host "   * Current version: $CurrentVersion" -ForegroundColor Gray
    Write-Host "   * Target version: $TargetVersion" -ForegroundColor Gray
    Write-Host ""

    if ($AutomaticActions -and $AutomaticActions.Count -gt 0) {
        Write-Host "[AUTOMATIC ACTIONS] THE FOLLOWING WILL BE DONE AUTOMATICALLY:" -ForegroundColor Green
        foreach ($action in $AutomaticActions) {
            Write-Host "   * $action" -ForegroundColor Gray
        }
        Write-Host ""
    }

    if ($ManualActions -and $ManualActions.Count -gt 0) {
        Write-Host "[MANUAL ACTIONS] THE FOLLOWING CAN BE DONE AFTER MIGRATION:" -ForegroundColor Yellow
        foreach ($action in $ManualActions) {
            Write-Host "   * $action" -ForegroundColor Gray
        }
        Write-Host ""
    }

    if ($BackupPath) {
        Write-Host "[BACKUP] AUTOMATIC BACKUP:" -ForegroundColor Magenta
        Write-Host "   * Backup created at: $BackupPath" -ForegroundColor Gray
        Write-Host ""
    }

    Write-Host "================================================================" -ForegroundColor Red
    Write-Host "                    [IMPORTANT] BACKUP REQUIRED                 " -ForegroundColor Red
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "BEFORE PROCEEDING, YOU MUST:" -ForegroundColor Red
    Write-Host "1. Create a backup of your entire project folder" -ForegroundColor White
    Write-Host "2. Commit any pending changes to your version control system" -ForegroundColor White
    Write-Host "3. Ensure you can restore your project if needed" -ForegroundColor White
    Write-Host ""
    Write-Host "This migration will modify critical files and may affect your project's functionality." -ForegroundColor Yellow
    Write-Host "The script will create an automatic backup, but manual backup is strongly recommended." -ForegroundColor Yellow
    Write-Host ""

    Write-Host "[PROMPT] Do you want to continue? (y/N): " -ForegroundColor Yellow -NoNewline
    $response = Read-Host

    if ($response -eq 'y' -or $response -eq 'Y') {
        Write-MigrationLog -Message "User confirmed migration" -Level "INFO"
        return $true
    } else {
        Write-MigrationLog -Message "User cancelled migration" -Level "INFO"
        Write-Host "Migration cancelled by user." -ForegroundColor Yellow
        return $false
    }
}
