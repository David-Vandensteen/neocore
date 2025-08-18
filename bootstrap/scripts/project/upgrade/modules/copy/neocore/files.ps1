function Copy-NeocoreFiles {
    param (
        [Parameter(Mandatory=$true)]
        [string]$SourceNeocorePath,

        [Parameter(Mandatory=$true)]
        [string]$ProjectNeocorePath,

        [Parameter(Mandatory=$true)]
        [string]$LogFile
    )

    Write-Host "Copying NeoCore files..." -ForegroundColor Cyan
    Write-Log -File $LogFile -Level "INFO" -Message "Starting NeoCore files copy"

    # Directories to copy
    $directoriesToCopy = @(
        "src-lib",
        "toolchain"
    )

    # Files to copy at root level
    $filesToCopy = @(
        "manifest.xml"
    )

    $copiedDirs = @()
    $copiedFiles = @()
    $errors = @()

    # Copy directories
    foreach ($dir in $directoriesToCopy) {
        $sourceDir = "$SourceNeocorePath\$dir"
        $targetDir = "$ProjectNeocorePath\$dir"

        if (Test-Path $sourceDir) {
            try {
                Write-Host "  Copying directory: $dir..." -ForegroundColor White

                # Remove target directory if it exists
                if (Test-Path $targetDir) {
                    Remove-Item -Path $targetDir -Recurse -Force
                    Write-Log -File $LogFile -Level "INFO" -Message "Removed existing directory: $targetDir"
                }

                # Copy source directory to target
                Copy-Item -Path $sourceDir -Destination $targetDir -Recurse -Force
                Write-Log -File $LogFile -Level "INFO" -Message "Copied directory: $sourceDir -> $targetDir"
                $copiedDirs += $dir

            } catch {
                $errorMsg = "Failed to copy directory $dir : $($_.Exception.Message)"
                Write-Host "  ERROR: $errorMsg" -ForegroundColor Red
                Write-Log -File $LogFile -Level "ERROR" -Message $errorMsg
                $errors += $errorMsg
            }
        } else {
            $errorMsg = "Source directory not found: $sourceDir"
            Write-Host "  WARNING: $errorMsg" -ForegroundColor Yellow
            Write-Log -File $LogFile -Level "WARNING" -Message $errorMsg
        }
    }

    # Copy individual files
    foreach ($file in $filesToCopy) {
        $sourceFile = "$SourceNeocorePath\$file"
        $targetFile = "$ProjectNeocorePath\$file"

        if (Test-Path $sourceFile) {
            try {
                Write-Host "  Copying file: $file..." -ForegroundColor White
                Copy-Item -Path $sourceFile -Destination $targetFile -Force
                Write-Log -File $LogFile -Level "INFO" -Message "Copied file: $sourceFile -> $targetFile"
                $copiedFiles += $file

            } catch {
                $errorMsg = "Failed to copy file $file : $($_.Exception.Message)"
                Write-Host "  ERROR: $errorMsg" -ForegroundColor Red
                Write-Log -File $LogFile -Level "ERROR" -Message $errorMsg
                $errors += $errorMsg
            }
        } else {
            $errorMsg = "Source file not found: $sourceFile"
            Write-Host "  WARNING: $errorMsg" -ForegroundColor Yellow
            Write-Log -File $LogFile -Level "WARNING" -Message $errorMsg
        }
    }

    # Report results
    if ($errors.Count -eq 0) {
        Write-Host "Successfully copied NeoCore files:" -ForegroundColor Green
        if ($copiedDirs.Count -gt 0) {
            Write-Host "  - Directories: $($copiedDirs -join ', ')" -ForegroundColor White
        }
        if ($copiedFiles.Count -gt 0) {
            Write-Host "  - Files: $($copiedFiles -join ', ')" -ForegroundColor White
        }
        Write-Log -File $LogFile -Level "SUCCESS" -Message "NeoCore files copy completed successfully"
        return $true
    } else {
        Write-Host "NeoCore copy completed with errors:" -ForegroundColor Yellow
        foreach ($error in $errors) {
            Write-Host "  - $error" -ForegroundColor Red
        }
        Write-Log -File $LogFile -Level "WARNING" -Message "NeoCore files copy completed with $($errors.Count) errors"
        return $false
    }
}
