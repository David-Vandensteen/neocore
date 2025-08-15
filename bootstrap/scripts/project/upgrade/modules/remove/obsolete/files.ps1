function Remove-ObsoleteFiles {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath,

        [Parameter(Mandatory=$true)]
        [string]$LogFile
    )

    Write-Host "Removing obsolete files..." -ForegroundColor Cyan
    Write-Log -File $LogFile -Level "INFO" -Message "Starting obsolete files removal"

    # List of obsolete files to remove
    $obsoleteFiles = @(
        @{ Path = "$ProjectSrcPath\externs.h"; Description = "Deprecated header file" },
        @{ Path = "$ProjectSrcPath\common_crt0_cd.s"; Description = "Deprecated assembly file - no longer needed in v3" },
        @{ Path = "$ProjectSrcPath\crt0_cd.s"; Description = "Deprecated assembly file - no longer needed in v3" }
    )

    $removedFiles = @()
    $errors = @()

    foreach ($fileInfo in $obsoleteFiles) {
        $filePath = $fileInfo.Path
        $fileName = Split-Path $filePath -Leaf

        if (Test-Path $filePath) {
            try {
                Write-Host "  Removing obsolete file: $fileName" -ForegroundColor White
                Remove-Item -Path $filePath -Force
                Write-Log -File $LogFile -Level "SUCCESS" -Message "Removed obsolete file: $filePath ($($fileInfo.Description))"
                $removedFiles += $fileName

            } catch {
                $errorMsg = "Failed to remove obsolete file $fileName : $($_.Exception.Message)"
                Write-Host "  ERROR: $errorMsg" -ForegroundColor Red
                Write-Log -File $LogFile -Level "ERROR" -Message $errorMsg
                $errors += $errorMsg
            }
        } else {
            Write-Log -File $LogFile -Level "INFO" -Message "Obsolete file not found (already removed): $filePath"
        }
    }

    # Report results
    if ($removedFiles.Count -gt 0) {
        Write-Host "Successfully removed obsolete files:" -ForegroundColor Green
        foreach ($file in $removedFiles) {
            Write-Host "  - $file" -ForegroundColor White
        }
    } else {
        Write-Host "No obsolete files found to remove" -ForegroundColor Green
    }

    if ($errors.Count -gt 0) {
        Write-Host "Errors occurred during obsolete files removal:" -ForegroundColor Yellow
        foreach ($error in $errors) {
            Write-Host "  - $error" -ForegroundColor Red
        }
        Write-Log -File $LogFile -Level "WARNING" -Message "Obsolete files removal completed with $($errors.Count) errors"
        return $false
    } else {
        Write-Log -File $LogFile -Level "SUCCESS" -Message "Obsolete files removal completed successfully. Removed $($removedFiles.Count) files."
        return $true
    }
}
