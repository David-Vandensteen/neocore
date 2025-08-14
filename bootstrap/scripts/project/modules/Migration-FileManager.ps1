# Migration-FileManager.ps1
# File management and cleanup functions for migration

function Remove-DeprecatedFiles {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath,

        [switch]$Silent = $false
    )

    Write-MigrationLog -Message "Checking for deprecated files..." -Level "INFO"

    $deprecatedFiles = @(
        @{ Path = "$ProjectSrcPath\neocore.h"; Description = "Deprecated header file" },
        @{ Path = "$ProjectSrcPath\system.h"; Description = "Deprecated header file" },
        @{ Path = "$ProjectSrcPath\externs.h"; Description = "Deprecated header file" },
        @{ Path = "$ProjectSrcPath\common_crt0_cd.s"; Description = "Deprecated assembly file - no longer needed in v3" },
        @{ Path = "$ProjectSrcPath\crt0_cd.s"; Description = "Deprecated assembly file - no longer needed in v3" }
    )

    $removedFiles = @()

    foreach ($fileInfo in $deprecatedFiles) {
        $filePath = $fileInfo.Path
        $fileName = Split-Path $filePath -Leaf

        if (Test-Path $filePath) {
            Write-MigrationLog -Message "Found deprecated file: $filePath" -Level "WARN"

            if (-not $Silent) {
                Write-Host "   Removing deprecated file: $fileName" -ForegroundColor Yellow
                Write-Host "   $($fileInfo.Description)" -ForegroundColor Gray
            }

            try {
                Remove-Item -Path $filePath -Force
                Write-MigrationLog -Message "Successfully deleted deprecated file: $filePath" -Level "SUCCESS"
                $removedFiles += $fileName

                if (-not $Silent) {
                    Write-Host "   File successfully removed: $fileName" -ForegroundColor Green
                }
            } catch {
                Write-MigrationLog -Message "Failed to delete file: $($_.Exception.Message)" -Level "ERROR"
                if (-not $Silent) {
                    Write-Host "   Error: Failed to remove file: $($_.Exception.Message)" -ForegroundColor Red
                    Write-Host "   Please manually delete the file after migration." -ForegroundColor Yellow
                }
            }
        }
    }

    if ($removedFiles.Count -gt 0) {
        Write-MigrationLog -Message "Removed $($removedFiles.Count) deprecated files: $($removedFiles -join ', ')" -Level "SUCCESS"
    } else {
        Write-MigrationLog -Message "No deprecated files found to remove" -Level "INFO"
    }

    return $removedFiles
}

function Check-GitIgnorePatterns {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath,

        [switch]$Silent = $false
    )

    Write-MigrationLog -Message "Checking .gitignore configuration..." -Level "INFO"

    # .gitignore is in parent directory of src
    $gitignorePath = "$ProjectSrcPath\..\.gitignore"
    $hasGitignoreIssues = $false
    $allGitignoreIssues = @()

    try {
        if (Test-Path -Path $gitignorePath) {
            Write-MigrationLog -Message "Found .gitignore file, checking build/ and dist/ patterns..." -Level "INFO"
            $gitignoreContent = Get-Content -Path $gitignorePath -ErrorAction SilentlyContinue
            $gitignoreNeedsUpdate = $false

            # Check for incorrect build/ pattern (should be /build/)
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

            # Check for incorrect dist/ pattern (should be /dist/)
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
                if (-not $Silent) {
                    Write-Host "   [WARNING] .gitignore pattern issues found" -ForegroundColor Yellow
                    Write-Host "   Patterns need manual correction - see migration report" -ForegroundColor Gray
                }

                # Log the issues for the migration report
                Write-MigrationLog -Message ".gitignore patterns need manual correction" -Level "WARN"
                foreach ($issue in $allGitignoreIssues) {
                    Write-MigrationLog -Message ".gitignore issue: '$($issue.Issue)' - $($issue.Action)" -Level "WARN"
                }
                return @{
                    HasIssues = $true
                    Issues = $allGitignoreIssues
                    NeedsManualFix = $true
                }
            } else {
                Write-MigrationLog -Message ".gitignore patterns are correctly configured" -Level "SUCCESS"
                if (-not $Silent) {
                    Write-Host "   .gitignore patterns are correct" -ForegroundColor Green
                }
                return @{
                    HasIssues = $false
                    Issues = @()
                    NeedsManualFix = $false
                }
            }
        } else {
            Write-MigrationLog -Message ".gitignore not found at $gitignorePath" -Level "ERROR"
            if (-not $Silent) {
                Write-Host "   [ERROR] .gitignore not found" -ForegroundColor Red
            }
            return @{
                HasIssues = $true
                Issues = @(@{
                    File = ".gitignore"
                    Issue = "File not found"
                    Action = "Create .gitignore file"
                    Description = ".gitignore file missing"
                })
                NeedsManualFix = $true
            }
        }
    } catch {
        Write-MigrationLog -Message "Failed to check .gitignore: $($_.Exception.Message)" -Level "ERROR"
        return @{
            HasIssues = $true
            Issues = @()
            NeedsManualFix = $true
        }
    }
}

function Clean-BuildArtifacts {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath
    )

    Write-MigrationLog -Message "Cleaning build artifacts..." -Level "INFO"

    $artifactPatterns = @(
        "*.o",
        "*.rom",
        "*.iso",
        "*.bin",
        "build/*",
        "temp/*"
    )

    $cleanedItems = @()

    foreach ($pattern in $artifactPatterns) {
        $fullPattern = "$ProjectSrcPath\$pattern"
        $items = Get-ChildItem -Path $fullPattern -ErrorAction SilentlyContinue

        foreach ($item in $items) {
            try {
                if ($item.PSIsContainer) {
                    Remove-Item $item.FullName -Recurse -Force
                } else {
                    Remove-Item $item.FullName -Force
                }
                Write-MigrationLog -Message "Cleaned: $($item.Name)" -Level "INFO"
                $cleanedItems += $item.Name
            } catch {
                Write-MigrationLog -Message "Failed to clean $($item.Name): $($_.Exception.Message)" -Level "WARN"
            }
        }
    }

    if ($cleanedItems.Count -gt 0) {
        Write-MigrationLog -Message "Cleaned $($cleanedItems.Count) build artifacts" -Level "SUCCESS"
    } else {
        Write-MigrationLog -Message "No build artifacts found to clean" -Level "INFO"
    }

    return $cleanedItems
}

function Analyze-ProjectStructure {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath
    )

    Write-MigrationLog -Message "Analyzing project structure..." -Level "INFO"

    $analysis = @{
        HasMakefile = Test-Path "$ProjectSrcPath\Makefile"
        HasMakBat = Test-Path "$ProjectSrcPath\mak.bat"
        HasMakPs1 = Test-Path "$ProjectSrcPath\mak.ps1"
        HasProjectXml = Test-Path "$ProjectSrcPath\project.xml"
        HasMainC = Test-Path "$ProjectSrcPath\main.c"
        HasAssetsDir = Test-Path "$ProjectSrcPath\assets"
        CFiles = @()
        HFiles = @()
        ObsoleteFiles = @()
    }

    # Find C and H files
    if (Test-Path $ProjectSrcPath) {
        $analysis.CFiles = Get-ChildItem "$ProjectSrcPath\*.c" -ErrorAction SilentlyContinue | ForEach-Object { $_.Name }
        $analysis.HFiles = Get-ChildItem "$ProjectSrcPath\*.h" -ErrorAction SilentlyContinue | ForEach-Object { $_.Name }

        # Check for obsolete files
        $obsoleteFiles = @("neocore.h", "system.h", "externs.h")
        foreach ($obsoleteFile in $obsoleteFiles) {
            if (Test-Path "$ProjectSrcPath\$obsoleteFile") {
                $analysis.ObsoleteFiles += $obsoleteFile
            }
        }
    }

    Write-MigrationLog -Message "Project structure analysis completed" -Level "INFO"
    Write-MigrationLog -Message "Found $($analysis.CFiles.Count) C files, $($analysis.HFiles.Count) H files" -Level "INFO"

    if ($analysis.ObsoleteFiles.Count -gt 0) {
        Write-MigrationLog -Message "Found $($analysis.ObsoleteFiles.Count) obsolete files: $($analysis.ObsoleteFiles -join ', ')" -Level "WARN"
    }

    return $analysis
}

function Generate-MigrationSummary {
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$MigrationData
    )

    Write-MigrationLog -Message "Generating migration summary report..." -Level "INFO"

    $summary = @{
        ProjectPath = $MigrationData.ProjectPath
        NeocorePath = $MigrationData.NeocorePath
        CurrentVersion = $MigrationData.CurrentVersion
        TargetVersion = $MigrationData.TargetVersion
        BackupPath = $MigrationData.BackupPath
        UpdatedFiles = $MigrationData.UpdatedFiles
        RemovedFiles = $MigrationData.RemovedFiles
        CleanedArtifacts = $MigrationData.CleanedArtifacts
        XmlIssuesFound = $MigrationData.XmlIssuesFound
        XmlMigrated = $MigrationData.XmlMigrated
        CodeIssues = $MigrationData.CodeIssues
        StructureAnalysis = $MigrationData.StructureAnalysis
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }

    # Write summary to log
    Write-MigrationLog -Message "=== MIGRATION SUMMARY ===" -Level "INFO"
    Write-MigrationLog -Message "Migration completed at: $($summary.Timestamp)" -Level "INFO"
    Write-MigrationLog -Message "Project: $($summary.ProjectPath)" -Level "INFO"
    Write-MigrationLog -Message "Version: $($summary.CurrentVersion) -> $($summary.TargetVersion)" -Level "INFO"
    Write-MigrationLog -Message "Backup: $($summary.BackupPath)" -Level "INFO"
    Write-MigrationLog -Message "Files updated: $($summary.UpdatedFiles.Count)" -Level "INFO"
    Write-MigrationLog -Message "Files removed: $($summary.RemovedFiles.Count)" -Level "INFO"
    Write-MigrationLog -Message "Artifacts cleaned: $($summary.CleanedArtifacts.Count)" -Level "INFO"
    Write-MigrationLog -Message "XML migrated: $($summary.XmlMigrated)" -Level "INFO"

    return $summary
}

function Test-MakefileUpToDate {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath,

        [Parameter(Mandatory=$true)]
        [string]$SourceNeocorePath
    )

    $targetMakefile = "$ProjectSrcPath\Makefile"
    $sourceMakefile = "$SourceNeocorePath\bootstrap\standalone\Makefile"

    # If target doesn't exist, definitely not up to date
    if (-not (Test-Path $targetMakefile)) {
        return $false
    }

    # Check if source exists
    if (-not (Test-Path $sourceMakefile)) {
        return $false
    }

    # Compare file hashes
    $sourceHash = (Get-FileHash $sourceMakefile -Algorithm MD5).Hash
    $targetHash = (Get-FileHash $targetMakefile -Algorithm MD5).Hash

    return ($sourceHash -eq $targetHash)
}

function Test-NeocoreLibraryUpToDate {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectNeocorePath,

        [Parameter(Mandatory=$true)]
        [string]$SourceNeocorePath
    )

    $sourceSrcLib = "$SourceNeocorePath\src-lib"
    $targetSrcLib = "$ProjectNeocorePath\src-lib"

    # If target doesn't exist, definitely not up to date
    if (-not (Test-Path $targetSrcLib)) {
        return $false
    }

    # Check if source exists
    if (-not (Test-Path $sourceSrcLib)) {
        return $false
    }

    # Compare key files to determine if up to date
    $keyFiles = @(
        "neocore.h",
        "neocore.c",
        "crt\crt0_cd.s",
        "system\neocd.x"
    )

    foreach ($file in $keyFiles) {
        $sourceFile = "$sourceSrcLib\$file"
        $targetFile = "$targetSrcLib\$file"

        if ((Test-Path $sourceFile) -and (Test-Path $targetFile)) {
            $sourceHash = (Get-FileHash $sourceFile -Algorithm MD5).Hash
            $targetHash = (Get-FileHash $targetFile -Algorithm MD5).Hash

            if ($sourceHash -ne $targetHash) {
                return $false
            }
        } elseif ((Test-Path $sourceFile) -and (-not (Test-Path $targetFile))) {
            return $false
        }
    }

    return $true
}

function Test-ToolchainUpToDate {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectNeocorePath,

        [Parameter(Mandatory=$true)]
        [string]$SourceNeocorePath
    )

    $sourceToolchain = "$SourceNeocorePath\toolchain"
    $targetToolchain = "$ProjectNeocorePath\toolchain"

    # If target doesn't exist, definitely not up to date
    if (-not (Test-Path $targetToolchain)) {
        return $false
    }

    # Check if source exists
    if (-not (Test-Path $sourceToolchain)) {
        return $false
    }

    # Compare key files to determine if up to date
    $keyFiles = @(
        "scripts\Builder-Manager.ps1",
        "scripts\modules\Build-Module.ps1"
    )

    foreach ($file in $keyFiles) {
        $sourceFile = "$sourceToolchain\$file"
        $targetFile = "$targetToolchain\$file"

        if ((Test-Path $sourceFile) -and (Test-Path $targetFile)) {
            $sourceHash = (Get-FileHash $sourceFile -Algorithm MD5).Hash
            $targetHash = (Get-FileHash $targetFile -Algorithm MD5).Hash

            if ($sourceHash -ne $targetHash) {
                return $false
            }
        } elseif ((Test-Path $sourceFile) -and (-not (Test-Path $targetFile))) {
            return $false
        }
    }

    return $true
}

function Update-NeocoreLibrary {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectNeocorePath,

        [Parameter(Mandatory=$true)]
        [string]$SourceNeocorePath,

        [switch]$Silent = $false
    )

    Write-MigrationLog -Message "Updating NeoCore library (src-lib)..." -Level "INFO"

    $sourceSrcLib = "$SourceNeocorePath\src-lib"
    $targetSrcLib = "$ProjectNeocorePath\src-lib"

    if (-not (Test-Path $sourceSrcLib)) {
        Write-MigrationLog -Message "Source src-lib not found: $sourceSrcLib" -Level "ERROR"
        return $false
    }

    try {
        # Backup existing src-lib if it exists
        if (Test-Path $targetSrcLib) {
            $backupPath = "$targetSrcLib.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            Write-MigrationLog -Message "Backing up existing src-lib to: $backupPath" -Level "INFO"
            Copy-Item -Path $targetSrcLib -Destination $backupPath -Recurse -Force
        }

        # Remove existing and copy new
        if (Test-Path $targetSrcLib) {
            Write-MigrationLog -Message "Removing existing src-lib directory..." -Level "INFO"
            Remove-Item -Path $targetSrcLib -Recurse -Force -ErrorAction Stop
        }

        Write-MigrationLog -Message "Copying new src-lib from: $sourceSrcLib" -Level "INFO"
        Copy-Item -Path $sourceSrcLib -Destination $targetSrcLib -Recurse -Force -ErrorAction Stop

        Write-MigrationLog -Message "NeoCore library updated successfully" -Level "SUCCESS"
        if (-not $Silent) {
            Write-Host "   NeoCore library updated to v3" -ForegroundColor Green
        }

        # Also update the manifest.xml file
        $sourceManifest = "$SourceNeocorePath\manifest.xml"
        $targetManifest = "$ProjectNeocorePath\manifest.xml"
        if (Test-Path $sourceManifest) {
            Write-MigrationLog -Message "Updating manifest.xml..." -Level "INFO"
            Copy-Item -Path $sourceManifest -Destination $targetManifest -Force -ErrorAction Stop
            Write-MigrationLog -Message "Manifest.xml updated successfully" -Level "SUCCESS"
            if (-not $Silent) {
                Write-Host "   Manifest.xml updated to v3" -ForegroundColor Green
            }
        } else {
            Write-MigrationLog -Message "Source manifest.xml not found: $sourceManifest" -Level "WARN"
        }

        return $true
    } catch {
        Write-MigrationLog -Message "Failed to update NeoCore library: $($_.Exception.Message)" -Level "ERROR"
        Write-MigrationLog -Message "Stack trace: $($_.ScriptStackTrace)" -Level "ERROR"
        if (-not $Silent) {
            Write-Host "   Failed to update NeoCore library: $($_.Exception.Message)" -ForegroundColor Red
        }
        return $false
    }
}

function Update-Toolchain {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectNeocorePath,

        [Parameter(Mandatory=$true)]
        [string]$SourceNeocorePath,

        [switch]$Silent = $false
    )

    Write-MigrationLog -Message "Updating toolchain..." -Level "INFO"

    $sourceToolchain = "$SourceNeocorePath\toolchain"
    $targetToolchain = "$ProjectNeocorePath\toolchain"

    if (-not (Test-Path $sourceToolchain)) {
        Write-MigrationLog -Message "Source toolchain not found: $sourceToolchain" -Level "ERROR"
        return $false
    }

    try {
        # Backup existing toolchain if it exists
        if (Test-Path $targetToolchain) {
            $backupPath = "$targetToolchain.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            Write-MigrationLog -Message "Backing up existing toolchain to: $backupPath" -Level "INFO"
            Copy-Item -Path $targetToolchain -Destination $backupPath -Recurse -Force
        }

        # Remove existing and copy new
        if (Test-Path $targetToolchain) {
            Write-MigrationLog -Message "Removing existing toolchain directory..." -Level "INFO"
            Remove-Item -Path $targetToolchain -Recurse -Force -ErrorAction Stop
        }

        Write-MigrationLog -Message "Copying new toolchain from: $sourceToolchain" -Level "INFO"
        Copy-Item -Path $sourceToolchain -Destination $targetToolchain -Recurse -Force -ErrorAction Stop

        Write-MigrationLog -Message "Toolchain updated successfully" -Level "SUCCESS"
        if (-not $Silent) {
            Write-Host "   Toolchain updated to v3" -ForegroundColor Green
        }
        return $true
    } catch {
        Write-MigrationLog -Message "Failed to update toolchain: $($_.Exception.Message)" -Level "ERROR"
        Write-MigrationLog -Message "Stack trace: $($_.ScriptStackTrace)" -Level "ERROR"
        if (-not $Silent) {
            Write-Host "   Failed to update toolchain: $($_.Exception.Message)" -ForegroundColor Red
        }
        return $false
    }
}
