param (
    [Parameter(Mandatory=$true)]
    [string]$ProjectSrcPath,

    [Parameter(Mandatory=$true)]
    [string]$ProjectNeocorePath
)

# Import modules
. "$PSScriptRoot\upgrade\modules\write\log.ps1"
. "$PSScriptRoot\upgrade\modules\assert\build\path.ps1"
. "$PSScriptRoot\upgrade\modules\assert\manifest.ps1"
. "$PSScriptRoot\upgrade\modules\assert\gitignore.ps1"
. "$PSScriptRoot\upgrade\modules\get\manifest\version.ps1"
. "$PSScriptRoot\upgrade\modules\get\project\versions.ps1"
. "$PSScriptRoot\upgrade\modules\compare\project\versions.ps1"
. "$PSScriptRoot\upgrade\modules\write\projectXML.ps1"
. "$PSScriptRoot\upgrade\modules\copy\makefile.ps1"
. "$PSScriptRoot\upgrade\modules\copy\neocore\files.ps1"
. "$PSScriptRoot\upgrade\modules\remove\obsolete\files.ps1"
. "$PSScriptRoot\upgrade\modules\analyze\ccode\legacy.ps1"

function Main {
    # Initialize log file
    $logFile = "$ProjectSrcPath\..\upgrade.log"

    Write-Host "NeoCore v2 to v3 Migration Tool" -ForegroundColor Cyan
    Write-Host "===============================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Project Source Path: $ProjectSrcPath" -ForegroundColor White
    Write-Host "Project NeoCore Path: $ProjectNeocorePath" -ForegroundColor White
    Write-Host ""

    # Log migration start
    Write-Log -File $logFile -Level "INFO" -Message "=== NeoCore v2->v3 Migration Started ==="
    Write-Log -File $logFile -Level "INFO" -Message "Project Source Path: $ProjectSrcPath"
    Write-Log -File $logFile -Level "INFO" -Message "Project NeoCore Path: $ProjectNeocorePath"

    # Check for existing build directory
    if (-not (Assert-BuildPath -ProjectSrcPath $ProjectSrcPath -LogFile $logFile)) {
        return $false
    }

    # Calculate source NeoCore path early for all functions
    $sourceNeocorePath = (Resolve-Path "$PSScriptRoot\..\..\..").Path

    # Check manifest versions and migration requirements
    if (-not (Assert-Manifest -ProjectNeocorePath $ProjectNeocorePath -SourceNeocorePath $sourceNeocorePath -LogFile $logFile)) {
        return $false
    }

    # Check .gitignore configuration
    Assert-Gitignore -ProjectSrcPath $ProjectSrcPath -LogFile $logFile | Out-Null

    # Confirm user has backup
    Write-Host ""
    Write-Host "*** IMPORTANT - BACKUP CONFIRMATION ***" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host ""
    Write-Host "Before proceeding with migration, please confirm:" -ForegroundColor Yellow
    Write-Host "- You have created a backup of your entire project" -ForegroundColor White
    Write-Host "- The backup is stored in a safe location" -ForegroundColor White
    Write-Host "- You can restore from this backup if needed" -ForegroundColor White
    Write-Host ""
    Write-Host "Do you confirm you have a proper backup? (y/N): " -ForegroundColor Yellow -NoNewline
    $backupConfirm = Read-Host

    if ($backupConfirm -ne "y" -and $backupConfirm -ne "Y") {
        Write-Host ""
        Write-Host "Migration cancelled - Please create a backup first." -ForegroundColor Red
        Write-Log -File $logFile -Level "INFO" -Message "Migration cancelled by user - No backup confirmation"
        return $false
    }

    Write-Host "Backup confirmed - Proceeding with migration..." -ForegroundColor Green
    Write-Log -File $logFile -Level "INFO" -Message "User confirmed backup availability"
    Write-Host ""

    # Get and compare project versions
    Write-Host "Analyzing project versions..." -ForegroundColor Cyan
    Write-Host ""

    $versions = Get-ProjectVersions -ProjectNeocorePath $ProjectNeocorePath -SourceNeocorePath $sourceNeocorePath -LogFile $logFile
    if ($null -eq $versions) {
        return $false
    }

    $comparisonResult = Compare-ProjectVersions -CurrentVersion $versions.Current -TargetVersion $versions.Target -LogFile $logFile

    # Handle comparison result
    switch ($comparisonResult) {
        "uptodate" { }
        "conflict" { return $false }
        "error" { return $false }
        "migrate" {
            Write-Host ""
            Write-Host "*** MIGRATION PROCESS ***" -ForegroundColor Yellow -BackgroundColor Black
            Write-Host ""
            Write-Host "The migration will now proceed with the following changes:" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "WARNING: The following files will be modified:" -ForegroundColor Red
            Write-Host "  - project.xml (will be rewritten to match NeoCore v3 format)" -ForegroundColor Yellow
            Write-Host "  - Makefile (will be overwritten with NeoCore v3 version)" -ForegroundColor Yellow
            Write-Host "  - NeoCore files will be copied (src-lib, manifest.xml, toolchain)" -ForegroundColor Yellow
            Write-Host "  - Obsolete files will be removed (.h and .s files no longer needed)" -ForegroundColor Yellow
            Write-Host ""
            Write-Log -File $logFile -Level "WARNING" -Message "Starting migration process - project.xml and Makefile will be rewritten, NeoCore files copied, obsolete files removed"

            # Copy NeoCore files (src-lib, toolchain, etc.)
            if (-not (Copy-NeocoreFiles -SourceNeocorePath $sourceNeocorePath -ProjectNeocorePath $ProjectNeocorePath -LogFile $logFile)) {
                Write-Host "Migration failed during NeoCore files copy" -ForegroundColor Red
                Write-Log -File $logFile -Level "ERROR" -Message "Migration failed during NeoCore files copy"
                return $false
            }

            # Overwrite Makefile with NeoCore v3 version
            if (-not (Copy-Makefile -ProjectSrcPath $ProjectSrcPath -SourceNeocorePath $sourceNeocorePath -LogFile $logFile)) {
                Write-Host "Migration failed during Makefile update" -ForegroundColor Red
                Write-Log -File $logFile -Level "ERROR" -Message "Migration failed during Makefile update"
                return $false
            }

            # Migrate project.xml to NeoCore v3 format
            if (-not (Write-ProjectXML -ProjectSrcPath $ProjectSrcPath -TargetVersion $versions.Target -LogFile $logFile)) {
                Write-Host "Migration failed during project.xml update" -ForegroundColor Red
                Write-Log -File $logFile -Level "ERROR" -Message "Migration failed during project.xml update"
                return $false
            }

            # Remove obsolete files
            if (-not (Remove-ObsoleteFiles -ProjectSrcPath $ProjectSrcPath -LogFile $logFile)) {
                Write-Host "Migration completed with warnings during obsolete files removal" -ForegroundColor Yellow
                Write-Log -File $logFile -Level "WARNING" -Message "Migration completed with warnings during obsolete files removal"
                # Continue execution - obsolete files removal failures are not critical
            }
        }
    }
    # Analyze C code for legacy patterns
    Write-Host ""
    if (-not (Analyze-CCodeLegacy -ProjectSrcPath $ProjectSrcPath -LogFile $logFile)) {
        Write-Host ""
        Write-Host "*** MANUAL REVIEW REQUIRED ***" -ForegroundColor Yellow -BackgroundColor Black
        Write-Host "Legacy code patterns were detected that require manual updates." -ForegroundColor Yellow
        Write-Host "Please review the analysis above and update your code accordingly." -ForegroundColor Yellow
        Write-Host "Migration files have been updated, but code changes are needed." -ForegroundColor Yellow
        Write-Log -File $logFile -Level "WARNING" -Message "Migration completed but manual code review required for legacy patterns"
    }
    Write-Host "Detailed log available at: $(Resolve-Path $logFile)" -ForegroundColor Cyan

    return $true
}

# Execute main function and handle result
$result = Main
if ($result) {
    exit 0
} else {
    exit 1
}
