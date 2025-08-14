param (
  [Parameter(Mandatory=$true)]
  [string]$ProjectSrcPath,

  [Parameter(Mandatory=$true)]
  [string]$ProjectNeocorePath
)

Write-Host "NeoCore v2 to v3 Migration Tool" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan
Write-Host ""

# Import migration modules with error handling
$ModulePath = "$PSScriptRoot\modules"

try {
    . "$ModulePath\Migration-Logging.ps1"
    . "$ModulePath\Migration-Validation.ps1"
    . "$ModulePath\Migration-ProjectXml.ps1"
    . "$ModulePath\Migration-CCode.ps1"
    . "$ModulePath\Migration-FileManager.ps1"
} catch {
    Write-Host "Error loading modules: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

function Main {
    # Initialize logging
    if (-not (Initialize-MigrationLogging -ProjectSrcPath $ProjectSrcPath)) {
        Write-Host "Failed to initialize logging" -ForegroundColor Red
        exit 1
    }

    Write-MigrationLog -Message "=== NeoCore v2->v3 Migration Started ===" -Level "INFO"
    Write-MigrationLog -Message "Project source: $ProjectSrcPath" -Level "INFO"
    Write-MigrationLog -Message "NeoCore path: $ProjectNeocorePath" -Level "INFO"

    # Step 1: Validate prerequisites
    try {
        Test-MigrationPrerequisites -ProjectSrcPath $ProjectSrcPath -ProjectNeocorePath $ProjectNeocorePath | Out-Null
    } catch {
        Write-Host "Prerequisites validation failed: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }

    # Step 1.5: Check for existing build directory
    $projectRootPath = (Get-Item $ProjectSrcPath).Parent.FullName
    $buildPath = "$projectRootPath\build"
    if (Test-Path $buildPath) {
        Write-Host ""
        Write-Host "*** BUILD DIRECTORY EXISTS ***" -ForegroundColor Red -BackgroundColor Black
        Write-Host ""
        Write-Host "A build directory already exists and must be removed before migration." -ForegroundColor Red
        Write-Host "Build directory: $buildPath" -ForegroundColor Yellow
        Write-Host ""
        Write-MigrationLog -Message "Migration stopped: Build directory exists at $buildPath" -Level "ERROR"
        exit 1
    }

    # Step 2: Get version information
    $currentVersion = Get-ProjectVersion -ProjectNeocorePath $ProjectNeocorePath

    # Get target version dynamically from source NeoCore
    $sourceNeocorePath = (Resolve-Path "$PSScriptRoot\..\..\..").Path
    $targetVersion = Get-ProjectVersion -ProjectNeocorePath $sourceNeocorePath
    if ($targetVersion -eq "Unknown") {
        Write-Host ""
        Write-Host "*** CONFIGURATION ERROR ***" -ForegroundColor Red -BackgroundColor Black
        Write-Host ""
        Write-Host "Could not determine target NeoCore version from source." -ForegroundColor Red
        Write-Host "Source path: $sourceNeocorePath" -ForegroundColor Yellow
        Write-Host "Expected manifest.xml at: $sourceNeocorePath\manifest.xml" -ForegroundColor Yellow
        Write-Host ""
        Write-MigrationLog -Message "Migration stopped: Could not determine target NeoCore version" -Level "ERROR"
        exit 1
    }

    # Step 2.1: Check minimum version support
    Write-MigrationLog -Message "Checking version compatibility..." -Level "INFO"
    Write-MigrationLog -Message "Current NeoCore version: $currentVersion" -Level "INFO"

    if (-not (Test-MinimumVersionSupport -CurrentVersion $currentVersion -MinimumVersion "2.0.0")) {
        Write-Host ""
        Write-Host "*** UNSUPPORTED VERSION ***" -ForegroundColor Red -BackgroundColor Black
        Write-Host ""
        Write-Host "This migration script only supports NeoCore v2.0.0 and above." -ForegroundColor Red
        Write-Host "Current project version: $currentVersion" -ForegroundColor Yellow
        Write-Host "Minimum supported version: 2.0.0" -ForegroundColor Green
        Write-Host ""
        Write-MigrationLog -Message "Migration stopped: Unsupported version $currentVersion (minimum: 2.0.0)" -Level "ERROR"
        exit 1
    }

    Write-MigrationLog -Message "Version check passed: $currentVersion >= 2.0.0" -Level "SUCCESS"

    # Step 2.5: Analyze project structure
    $structureAnalysis = Analyze-ProjectStructure -ProjectSrcPath $ProjectSrcPath

    # Step 3: Analyze project.xml compatibility
    $projectXmlPath = "$ProjectSrcPath\project.xml"
    $migrationNeeded = $false
    $detectedIssues = @()

    if (Test-FileExists -FilePath $projectXmlPath -Description "Project XML") {
        try {
            [xml]$projectXml = Get-Content -Path $projectXmlPath
            $detectedIssues = Test-ProjectXmlV3Compatibility -ProjectXml $projectXml -ProjectPath $ProjectSrcPath
            $migrationNeeded = ($detectedIssues.Count -gt 0)
        } catch {
            Show-Error "Failed to parse project.xml: $($_.Exception.Message)"
        }
    } else {
        Show-Error "project.xml not found at $projectXmlPath"
    }

    # Step 3.5: Analyze C code for compatibility
    $codeAnalysis = Invoke-CCodeAnalysis -ProjectSrcPath $ProjectSrcPath -Silent

    # Step 4: Show migration warning and get user confirmation

    # Pre-check all potential issues before showing warning
    $automaticActions = @()
    $manualActions = @()

    # Add XML compatibility issues to automatic actions
    if ($detectedIssues -and $detectedIssues.Count -gt 0) {
        foreach ($issue in $detectedIssues) {
            $automaticActions += "[PROJECT.XML] $issue"
        }
    }

    # Check .gitignore issues (MANUAL)
    $gitignorePath = "$ProjectSrcPath\..\.gitignore"
    $gitignoreIssues = @()
    if (Test-Path $gitignorePath) {
        $gitignoreContent = Get-Content $gitignorePath -ErrorAction SilentlyContinue
        # Check for specific incorrect patterns that need manual fix
        if ($gitignoreContent -contains "build/") {
            $gitignoreIssues += "Change 'build/' to '/build/'"
        }
        if ($gitignoreContent -contains "dist/") {
            $gitignoreIssues += "Change 'dist/' to '/dist/'"
        }
        if ($gitignoreIssues.Count -gt 0) {
            $manualActions += "[GITIGNORE] Manual fix needed: $($gitignoreIssues -join ', ')"
        }
    } else {
        $manualActions += "[GITIGNORE] File not found at expected location: $gitignorePath"
    }

    # Check for deprecated .s files (AUTOMATIC)
    $deprecatedSFiles = @("$ProjectSrcPath\common_crt0_cd.s", "$ProjectSrcPath\crt0_cd.s")
    $foundDeprecatedS = @()
    foreach ($sFile in $deprecatedSFiles) {
        if (Test-Path $sFile) {
            $foundDeprecatedS += Split-Path $sFile -Leaf
        }
    }
    if ($foundDeprecatedS.Count -gt 0) {
        $automaticActions += "[DEPRECATED FILES] Remove deprecated files: $($foundDeprecatedS -join ', ')"
    }


    # Check if Makefile will be overwritten (AUTOMATIC)
    if (Test-Path "$ProjectSrcPath\Makefile") {
        if (-not (Test-MakefileUpToDate -ProjectSrcPath $ProjectSrcPath -SourceNeocorePath $sourceNeocorePath)) {
            $automaticActions += "[MAKEFILE] Overwrite existing Makefile with v3 version"
        }
    }

    # Check if NeoCore library needs update (AUTOMATIC)
    $sourceSrcLib = "$sourceNeocorePath\src-lib"
    $targetSrcLib = "$ProjectNeocorePath\src-lib"
    if (Test-Path $sourceSrcLib) {
        if (-not (Test-NeocoreLibraryUpToDate -ProjectNeocorePath $ProjectNeocorePath -SourceNeocorePath $sourceNeocorePath)) {
            if (Test-Path $targetSrcLib) {
                $automaticActions += "[NEOCORE LIB] Replace NeoCore library (src-lib) with v3 version"
            } else {
                $automaticActions += "[NEOCORE LIB] Install NeoCore library (src-lib) v3"
            }
        }
    }

    # Check if toolchain needs update (AUTOMATIC)
    $sourceToolchain = "$sourceNeocorePath\toolchain"
    $targetToolchain = "$ProjectNeocorePath\toolchain"
    if (Test-Path $sourceToolchain) {
        if (-not (Test-ToolchainUpToDate -ProjectNeocorePath $ProjectNeocorePath -SourceNeocorePath $sourceNeocorePath)) {
            if (Test-Path $targetToolchain) {
                $automaticActions += "[TOOLCHAIN] Replace toolchain with v3 version"
            } else {
                $automaticActions += "[TOOLCHAIN] Install toolchain v3"
            }
        }
    }

    # Add C code analysis results to manual actions if issues found
    if ($codeAnalysis.HasIssues) {
        $manualActions += "[C CODE REVIEW] $($codeAnalysis.TotalIssues) compatibility issues found in $($codeAnalysis.FilesWithIssues) files - details provided after migration"
    }

    # Check if project is already fully migrated to v3
    $isAlreadyMigrated = Test-MinimumVersionSupport -CurrentVersion $currentVersion -MinimumVersion $targetVersion

    # Show migration warning only if migration is actually needed
    if (($migrationNeeded -or $automaticActions.Count -gt 0 -or $manualActions.Count -gt 0) -and -not $isAlreadyMigrated) {
        $proceed = Show-MigrationWarning -ProjectSrcPath $ProjectSrcPath -ProjectNeocorePath $ProjectNeocorePath -CurrentVersion $currentVersion -TargetVersion $targetVersion -AutomaticActions $automaticActions -ManualActions $manualActions

        if (-not $proceed) {
            Write-MigrationLog -Message "Migration cancelled by user" -Level "INFO"
            exit 0
        }
    } elseif ($isAlreadyMigrated) {
        Write-Host "Project is already migrated to version $targetVersion or higher." -ForegroundColor Green
        Write-MigrationLog -Message "Project already migrated to version $targetVersion or higher" -Level "INFO"
        if ($manualActions.Count -gt 0) {
            Write-Host ""
            Write-Host "Note: Some manual actions were detected but won't be processed since the project is already migrated:" -ForegroundColor Yellow
            foreach ($action in $manualActions) {
                Write-Host "  * $action" -ForegroundColor Yellow
            }
        }
        exit 0
    }

    # Step 5: Creating backup and performing migration
    Write-Host "Step 5: Creating backup..." -ForegroundColor Yellow
    $backupPath = Backup-ProjectFiles -ProjectSrcPath $ProjectSrcPath
    if (-not $backupPath) {
        Show-Error "Failed to create backup"
    }
    Write-Host "Backup created at: $backupPath" -ForegroundColor Green

    # Step 6: Update project files
    Write-Host "Step 6: Updating project files..." -ForegroundColor Yellow

    # Check and update Makefile if needed
    if (Test-Path "$ProjectSrcPath\Makefile") {
        if (Test-MakefileUpToDate -ProjectSrcPath $ProjectSrcPath -SourceNeocorePath (Resolve-Path "$PSScriptRoot\..\..\..").Path) {
            Write-Host "   Makefile is already up to date" -ForegroundColor Green
        } else {
            Write-Host "   Updating Makefile to v3 version..." -ForegroundColor Yellow
            $sourceMakefile = (Resolve-Path "$PSScriptRoot\..\..\..").Path + "\bootstrap\standalone\Makefile"
            $targetMakefile = "$ProjectSrcPath\Makefile"
            try {
                Copy-Item -Path $sourceMakefile -Destination $targetMakefile -Force
                Write-Host "   Makefile updated successfully" -ForegroundColor Green
            } catch {
                Write-Host "   Failed to update Makefile: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }

    # Update other project files (mak.bat, mak.ps1)
    $updatedFiles = Update-ProjectFiles -ProjectSrcPath $ProjectSrcPath -NeocorePath (Resolve-Path "$PSScriptRoot\..\..\..").Path
    Write-Host "Updated files: $($updatedFiles -join ', ')" -ForegroundColor Green

    # Step 6.5: Remove deprecated files
    Write-Host "Step 6.5: Removing deprecated files..." -ForegroundColor Yellow
    $removedFiles = Remove-DeprecatedFiles -ProjectSrcPath $ProjectSrcPath -Silent
    if ($removedFiles.Count -gt 0) {
        Write-Host "Removed deprecated files: $($removedFiles -join ', ')" -ForegroundColor Green
    } else {
        Write-Host "No deprecated files found" -ForegroundColor Green
    }

    # Step 6.7: Clean build artifacts
    Write-Host "Step 6.7: Cleaning build artifacts..." -ForegroundColor Yellow
    $cleanedArtifacts = Clean-BuildArtifacts -ProjectSrcPath $ProjectSrcPath
    if ($cleanedArtifacts.Count -gt 0) {
        Write-Host "Cleaned build artifacts: $($cleanedArtifacts -join ', ')" -ForegroundColor Green
    } else {
        Write-Host "No build artifacts to clean" -ForegroundColor Green
    }

    # Step 6.8: Check .gitignore
    Write-Host "Step 6.8: Checking .gitignore..." -ForegroundColor Yellow
    $gitignoreResult = Check-GitIgnorePatterns -ProjectSrcPath $ProjectSrcPath -Silent

    # Step 6.9: Update NeoCore library (src-lib)
    Write-Host "Step 6.9: Updating NeoCore library..." -ForegroundColor Yellow
    $sourceNeocorePath = (Resolve-Path "$PSScriptRoot\..\..\..").Path
    if (Test-NeocoreLibraryUpToDate -ProjectNeocorePath $ProjectNeocorePath -SourceNeocorePath $sourceNeocorePath) {
        Write-Host "   NeoCore library is already up to date" -ForegroundColor Green
        $neocoreLibUpdated = $true
    } else {
        $neocoreLibUpdated = Update-NeocoreLibrary -ProjectNeocorePath $ProjectNeocorePath -SourceNeocorePath $sourceNeocorePath -Silent
        if (-not $neocoreLibUpdated) {
            Show-Error "Failed to update NeoCore library"
        }
    }

    # Step 6.10: Update toolchain
    Write-Host "Step 6.10: Updating toolchain..." -ForegroundColor Yellow
    if (Test-ToolchainUpToDate -ProjectNeocorePath $ProjectNeocorePath -SourceNeocorePath $sourceNeocorePath) {
        Write-Host "   Toolchain is already up to date" -ForegroundColor Green
        $toolchainUpdated = $true
    } else {
        $toolchainUpdated = Update-Toolchain -ProjectNeocorePath $ProjectNeocorePath -SourceNeocorePath $sourceNeocorePath -Silent
        if (-not $toolchainUpdated) {
            Show-Error "Failed to update toolchain"
        }
    }

    # Step 7: Migrate project.xml if needed
    if ($migrationNeeded) {
        Write-Host "Step 7: Migrating project.xml to v3 format..." -ForegroundColor Yellow
        $xmlMigrated = ConvertTo-ProjectXmlV3 -ProjectXmlPath $projectXmlPath -CurrentXml $projectXml
        if ($xmlMigrated) {
            Write-Host "project.xml successfully migrated to v3 format" -ForegroundColor Green
        } else {
            Show-Error "Failed to migrate project.xml"
        }
    } else {
        Write-Host "Step 7: project.xml migration not needed" -ForegroundColor Green
    }

    # Step 8: Generate summary report
    Write-Host ""

    # Generate comprehensive summary
    $migrationData = @{
        ProjectPath = $ProjectSrcPath
        NeocorePath = $ProjectNeocorePath
        CurrentVersion = $currentVersion
        TargetVersion = $targetVersion
        BackupPath = $backupPath
        UpdatedFiles = $updatedFiles
        RemovedFiles = $removedFiles
        CleanedArtifacts = $cleanedArtifacts
        GitIgnoreResult = $gitignoreResult
        NeocoreLibUpdated = $neocoreLibUpdated
        ToolchainUpdated = $toolchainUpdated
        XmlIssuesFound = $detectedIssues.Count
        XmlMigrated = $migrationNeeded
        CodeIssues = $codeAnalysis
        StructureAnalysis = $structureAnalysis
    }

    $summary = Generate-MigrationSummary -MigrationData $migrationData

    if ($codeAnalysis.HasIssues) {
        Write-Host "[ACTION REQUIRED] Next Steps:" -ForegroundColor Yellow
        Write-Host "1. Review C code issues found:" -ForegroundColor White
        Write-Host "   - Files with issues: $($codeAnalysis.FilesWithIssues)" -ForegroundColor Gray
        Write-Host "   - Total issues: $($codeAnalysis.TotalIssues)" -ForegroundColor Gray
        Write-Host ""
        Write-Host "   Detailed issues:" -ForegroundColor White
        foreach ($issue in $codeAnalysis.Issues) {
            Write-Host "   - $($issue.File): $($issue.Issue)" -ForegroundColor Gray
        }
        Write-Host ""
        Write-Host "2. Test your project:" -ForegroundColor White
        Write-Host "   mak sprite" -ForegroundColor Gray
        Write-Host "   mak" -ForegroundColor Gray
        Write-Host "   mak run:raine" -ForegroundColor Gray
        Write-Host ""
        if ($gitignoreResult.HasIssues -or $gitignoreIssues.Count -gt 0) {
            Write-Host "3. Check .gitignore:" -ForegroundColor White
            if ($gitignoreIssues.Count -gt 0) {
                foreach ($issue in $gitignoreIssues) {
                    Write-Host "   $issue" -ForegroundColor Gray
                }
            } else {
                Write-Host "   Review .gitignore patterns" -ForegroundColor Gray
            }
            Write-Host ""
        }
    } else {
        Write-Host "[SUCCESS] Your project is ready!" -ForegroundColor Green
        Write-Host "Test commands:" -ForegroundColor White
        Write-Host "   mak sprite" -ForegroundColor Gray
        Write-Host "   mak" -ForegroundColor Gray
        Write-Host "   mak run:raine" -ForegroundColor Gray
        Write-Host ""
        if ($gitignoreResult.HasIssues -or $gitignoreIssues.Count -gt 0) {
            Write-Host "Don't forget to check .gitignore:" -ForegroundColor White
            if ($gitignoreIssues.Count -gt 0) {
                foreach ($issue in $gitignoreIssues) {
                    Write-Host "   $issue" -ForegroundColor Gray
                }
            } else {
                Write-Host "   Review .gitignore patterns" -ForegroundColor Gray
            }
            Write-Host ""
        }
    }

    Write-Host "[RESOURCES]" -ForegroundColor Cyan
    Write-Host "* Migration log: $(Get-MigrationLogPath)" -ForegroundColor White
    Write-Host "* Backup location: $backupPath" -ForegroundColor White
    Write-Host "* Migration guide: See the NeoCore repository on GitHub for migration documentation" -ForegroundColor White
    Write-Host ""

    Write-MigrationLog -Message "Migration completed successfully" -Level "SUCCESS"
}

# Execute main function
try {
    Main
    exit 0
} catch {
    Write-MigrationLog -Message "Migration failed: $($_.Exception.Message)" -Level "ERROR"
    Write-Host "Migration failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
