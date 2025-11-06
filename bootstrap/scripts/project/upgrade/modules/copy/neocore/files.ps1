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

    # Directories to copy from neocore root
    $directoriesToCopy = @(
        "src-lib",
        "toolchain"
    )

    # Directories to copy from neocore/bootstrap to project root
    $bootstrapDirectoriesToCopy = @(
        "neocore-version-switcher"
    )

    # Files to copy at neocore root level
    $filesToCopy = @(
        "manifest.xml"
    )

    # Files to copy from neocore/bootstrap to project root
    $bootstrapFilesToCopy = @(
        "neocore-version-switcher.bat"
    )

    $copiedDirs = @()
    $copiedFiles = @()
    $errors = @()

    # Copy directories using robocopy for better reliability
    foreach ($dir in $directoriesToCopy) {
        $sourceDir = "$SourceNeocorePath\$dir"
        $targetDir = "$ProjectNeocorePath\$dir"

        if (Test-Path $sourceDir) {
            Write-Host "  Copying directory: $dir..." -ForegroundColor White

            # Remove target directory if it exists
            if (Test-Path $targetDir) {
                Remove-Item -Path $targetDir -Recurse -Force -ErrorAction Stop
                Write-Log -File $LogFile -Level "INFO" -Message "Removed existing directory: $targetDir"
            }

            # Use robocopy for reliable directory copying
            $robocopyArgs = @(
                $sourceDir,
                $targetDir,
                "/E",        # Copy subdirectories including empty ones
                "/R:0",      # Number of retries on failed copies (0 = no retry)
                "/W:0"       # Wait time between retries (0 seconds)
            )

            Write-Log -File $LogFile -Level "INFO" -Message "Running robocopy: $sourceDir -> $targetDir"
            $robocopyResult = & robocopy @robocopyArgs
            $robocopyExitCode = $LASTEXITCODE

            # Robocopy exit codes: 0-3 are success, 4+ are errors
            if ($robocopyExitCode -ge 4) {
                $errorMsg = "Failed to copy directory $dir (robocopy exit code: $robocopyExitCode)"
                Write-Host "  ERROR: $errorMsg" -ForegroundColor Red
                Write-Log -File $LogFile -Level "ERROR" -Message $errorMsg
                Write-Log -File $LogFile -Level "ERROR" -Message "NeoCore files copy failed - stopping migration"
                return $false
            } else {
                Write-Log -File $LogFile -Level "INFO" -Message "Successfully copied directory: $sourceDir -> $targetDir (exit code: $robocopyExitCode)"
                $copiedDirs += $dir
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
                Copy-Item -Path $sourceFile -Destination $targetFile -Force -ErrorAction Stop
                Write-Log -File $LogFile -Level "INFO" -Message "Copied file: $sourceFile -> $targetFile"
                $copiedFiles += $file

            } catch {
                $errorMsg = "Failed to copy file $file : $($_.Exception.Message)"
                Write-Host "  ERROR: $errorMsg" -ForegroundColor Red
                Write-Log -File $LogFile -Level "ERROR" -Message $errorMsg
                Write-Log -File $LogFile -Level "ERROR" -Message "NeoCore files copy failed - stopping migration"
                return $false
            }
        } else {
            $errorMsg = "Source file not found: $sourceFile"
            Write-Host "  WARNING: $errorMsg" -ForegroundColor Yellow
            Write-Log -File $LogFile -Level "WARNING" -Message $errorMsg
        }
    }

    # Copy bootstrap directories to project root
    foreach ($dir in $bootstrapDirectoriesToCopy) {
        $sourceDir = "$SourceNeocorePath\bootstrap\$dir"
        $targetDir = (Split-Path -Parent $ProjectNeocorePath) + "\$dir"  # Project root, not neocore subfolder

        if (Test-Path $sourceDir) {
            Write-Host "  Copying bootstrap directory: $dir..." -ForegroundColor White

            # Remove target directory if it exists
            if (Test-Path $targetDir) {
                Remove-Item -Path $targetDir -Recurse -Force -ErrorAction Stop
                Write-Log -File $LogFile -Level "INFO" -Message "Removed existing directory: $targetDir"
            }

            # Use robocopy for reliable directory copying
            $robocopyArgs = @(
                $sourceDir,
                $targetDir,
                "/E",        # Copy subdirectories including empty ones
                "/R:0",      # Number of retries on failed copies (0 = no retry)
                "/W:0"       # Wait time between retries (0 seconds)
            )

            Write-Log -File $LogFile -Level "INFO" -Message "Running robocopy: $sourceDir -> $targetDir"
            $robocopyResult = & robocopy @robocopyArgs
            $robocopyExitCode = $LASTEXITCODE

            # Robocopy exit codes: 0-3 are success, 4+ are errors
            if ($robocopyExitCode -ge 4) {
                $errorMsg = "Failed to copy bootstrap directory $dir (robocopy exit code: $robocopyExitCode)"
                Write-Host "  ERROR: $errorMsg" -ForegroundColor Red
                Write-Log -File $LogFile -Level "ERROR" -Message $errorMsg
                Write-Log -File $LogFile -Level "ERROR" -Message "NeoCore files copy failed - stopping migration"
                return $false
            } else {
                Write-Log -File $LogFile -Level "INFO" -Message "Successfully copied bootstrap directory: $sourceDir -> $targetDir (exit code: $robocopyExitCode)"
                $copiedDirs += "bootstrap\$dir"
            }
        } else {
            $errorMsg = "Source bootstrap directory not found: $sourceDir"
            Write-Host "  WARNING: $errorMsg" -ForegroundColor Yellow
            Write-Log -File $LogFile -Level "WARNING" -Message $errorMsg
        }
    }

    # Copy bootstrap files to project root
    foreach ($file in $bootstrapFilesToCopy) {
        $sourceFile = "$SourceNeocorePath\bootstrap\$file"
        $targetFile = (Split-Path -Parent $ProjectNeocorePath) + "\$file"  # Project root, not neocore subfolder

        if (Test-Path $sourceFile) {
            try {
                Write-Host "  Copying bootstrap file: $file..." -ForegroundColor White
                Copy-Item -Path $sourceFile -Destination $targetFile -Force -ErrorAction Stop
                Write-Log -File $LogFile -Level "INFO" -Message "Copied bootstrap file: $sourceFile -> $targetFile"
                $copiedFiles += "bootstrap\$file"

            } catch {
                $errorMsg = "Failed to copy bootstrap file $file : $($_.Exception.Message)"
                Write-Host "  ERROR: $errorMsg" -ForegroundColor Red
                Write-Log -File $LogFile -Level "ERROR" -Message $errorMsg
                Write-Log -File $LogFile -Level "ERROR" -Message "NeoCore files copy failed - stopping migration"
                return $false
            }
        } else {
            $errorMsg = "Source bootstrap file not found: $sourceFile"
            Write-Host "  WARNING: $errorMsg" -ForegroundColor Yellow
            Write-Log -File $LogFile -Level "WARNING" -Message $errorMsg
        }
    }

    # If we reach here, all copies were successful
    Write-Host "Successfully copied NeoCore files:" -ForegroundColor Green
    if ($copiedDirs.Count -gt 0) {
        Write-Host "  - Directories: $($copiedDirs -join ', ')" -ForegroundColor White
    }
    if ($copiedFiles.Count -gt 0) {
        Write-Host "  - Files: $($copiedFiles -join ', ')" -ForegroundColor White
    }
    Write-Log -File $LogFile -Level "SUCCESS" -Message "NeoCore files copy completed successfully"
    return $true
}
