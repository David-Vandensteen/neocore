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

  # Directories to copy (with custom source paths if needed)
  $directoriesToCopy = @(
    @{ Name = "src-lib"; SourcePath = "$SourceNeocorePath\src-lib" },
    @{ Name = "toolchain"; SourcePath = "$SourceNeocorePath\toolchain" },
    @{ Name = "neocore-version-switcher"; SourcePath = "$SourceNeocorePath\bootstrap\neocore-version-switcher" }
  )

  # Files to copy at root level (with custom source paths if needed)
  $filesToCopy = @(
    @{ Name = "manifest.xml"; SourcePath = "$SourceNeocorePath\manifest.xml" },
    @{ Name = "neocore-version-switcher.bat"; SourcePath = "$SourceNeocorePath\bootstrap\neocore-version-switcher.bat" }
  )

  $copiedDirs = @()
  $copiedFiles = @()
  $errors = @()

  # Copy directories using robocopy for better reliability
  foreach ($dirInfo in $directoriesToCopy) {
    $dir = $dirInfo.Name
    $sourceDir = $dirInfo.SourcePath
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
      $infoMsg = "Directory '$dir' not available in this version (skipping)"
      Write-Host "  INFO: $infoMsg" -ForegroundColor Gray
      Write-Log -File $LogFile -Level "INFO" -Message "$infoMsg - Source: $sourceDir"
    }
  }

  # Copy individual files
  foreach ($fileInfo in $filesToCopy) {
    $file = $fileInfo.Name
    $sourceFile = $fileInfo.SourcePath
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
      $infoMsg = "File '$file' not available in this version (skipping)"
      Write-Host "  INFO: $infoMsg" -ForegroundColor Gray
      Write-Log -File $LogFile -Level "INFO" -Message "$infoMsg - Source: $sourceFile"
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
