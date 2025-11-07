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

  # Directories to copy to neocore folder
  $directoriesToCopy = @(
    @{ Name = "src-lib"; SourcePath = "$SourceNeocorePath\src-lib"; TargetPath = "$ProjectNeocorePath\src-lib" },
    @{ Name = "toolchain"; SourcePath = "$SourceNeocorePath\toolchain"; TargetPath = "$ProjectNeocorePath\toolchain" }
  )

  # Directories to copy to project root (parent of neocore folder)
  $projectRootPath = Split-Path -Parent $ProjectNeocorePath
  $rootDirectoriesToCopy = @(
    @{ Name = "neocore-version-switcher"; SourcePath = "$SourceNeocorePath\bootstrap\neocore-version-switcher"; TargetPath = "$projectRootPath\neocore-version-switcher" }
  )

  # Files to copy to neocore folder
  $filesToCopy = @(
    @{ Name = "manifest.xml"; SourcePath = "$SourceNeocorePath\manifest.xml"; TargetPath = "$ProjectNeocorePath\manifest.xml" }
  )

  # Files to copy to project root (parent of neocore folder)
  $rootFilesToCopy = @(
    @{ Name = "neocore-version-switcher.bat"; SourcePath = "$SourceNeocorePath\bootstrap\neocore-version-switcher.bat"; TargetPath = "$projectRootPath\neocore-version-switcher.bat" }
  )

  $copiedDirs = @()
  $copiedFiles = @()
  $errors = @()

  # Helper function to copy directories
  function Copy-Directory {
    param($dirInfo, $logFile)
    
    $dir = $dirInfo.Name
    $sourceDir = $dirInfo.SourcePath
    $targetDir = $dirInfo.TargetPath

    if (Test-Path $sourceDir) {
      Write-Host "  Copying directory: $dir..." -ForegroundColor White

      # Remove target directory if it exists
      if (Test-Path $targetDir) {
        Remove-Item -Path $targetDir -Recurse -Force -ErrorAction Stop
        Write-Log -File $logFile -Level "INFO" -Message "Removed existing directory: $targetDir"
      }

      # Use robocopy for reliable directory copying
      $robocopyArgs = @(
        $sourceDir,
        $targetDir,
        "/E",        # Copy subdirectories including empty ones
        "/R:0",      # Number of retries on failed copies (0 = no retry)
        "/W:0"       # Wait time between retries (0 seconds)
      )

      Write-Log -File $logFile -Level "INFO" -Message "Running robocopy: $sourceDir -> $targetDir"
      $robocopyResult = & robocopy @robocopyArgs
      $robocopyExitCode = $LASTEXITCODE

      # Robocopy exit codes: 0-3 are success, 4+ are errors
      if ($robocopyExitCode -ge 4) {
        $errorMsg = "Failed to copy directory $dir (robocopy exit code: $robocopyExitCode)"
        Write-Host "  ERROR: $errorMsg" -ForegroundColor Red
        Write-Log -File $logFile -Level "ERROR" -Message $errorMsg
        Write-Log -File $logFile -Level "ERROR" -Message "NeoCore files copy failed - stopping migration"
        return $null
      } else {
        Write-Log -File $logFile -Level "INFO" -Message "Successfully copied directory: $sourceDir -> $targetDir (exit code: $robocopyExitCode)"
        return $dir
      }
    } else {
      $infoMsg = "Directory '$dir' not available in this version (skipping)"
      Write-Host "  INFO: $infoMsg" -ForegroundColor Gray
      Write-Log -File $logFile -Level "INFO" -Message "$infoMsg - Source: $sourceDir"
      return $null
    }
  }

  # Helper function to copy files
  function Copy-SingleFile {
    param($fileInfo, $logFile)
    
    $file = $fileInfo.Name
    $sourceFile = $fileInfo.SourcePath
    $targetFile = $fileInfo.TargetPath

    if (Test-Path $sourceFile) {
      try {
        Write-Host "  Copying file: $file..." -ForegroundColor White
        Copy-Item -Path $sourceFile -Destination $targetFile -Force -ErrorAction Stop
        Write-Log -File $logFile -Level "INFO" -Message "Copied file: $sourceFile -> $targetFile"
        return $file
      } catch {
        $errorMsg = "Failed to copy file $file : $($_.Exception.Message)"
        Write-Host "  ERROR: $errorMsg" -ForegroundColor Red
        Write-Log -File $logFile -Level "ERROR" -Message $errorMsg
        Write-Log -File $logFile -Level "ERROR" -Message "NeoCore files copy failed - stopping migration"
        return $null
      }
    } else {
      $infoMsg = "File '$file' not available in this version (skipping)"
      Write-Host "  INFO: $infoMsg" -ForegroundColor Gray
      Write-Log -File $logFile -Level "INFO" -Message "$infoMsg - Source: $sourceFile"
      return $null
    }
  }

  # Copy directories to neocore folder
  foreach ($dirInfo in $directoriesToCopy) {
    $result = Copy-Directory -dirInfo $dirInfo -logFile $LogFile
    if ($result -eq $null -and (Test-Path $dirInfo.SourcePath)) {
      return $false
    }
    if ($result) { $copiedDirs += $result }
  }

  # Copy directories to project root
  foreach ($dirInfo in $rootDirectoriesToCopy) {
    $result = Copy-Directory -dirInfo $dirInfo -logFile $LogFile
    if ($result -eq $null -and (Test-Path $dirInfo.SourcePath)) {
      return $false
    }
    if ($result) { $copiedDirs += $result }
  }

  # Copy files to neocore folder
  foreach ($fileInfo in $filesToCopy) {
    $result = Copy-SingleFile -fileInfo $fileInfo -logFile $LogFile
    if ($result -eq $null -and (Test-Path $fileInfo.SourcePath)) {
      return $false
    }
    if ($result) { $copiedFiles += $result }
  }

  # Copy files to project root
  foreach ($fileInfo in $rootFilesToCopy) {
    $result = Copy-SingleFile -fileInfo $fileInfo -logFile $LogFile
    if ($result -eq $null -and (Test-Path $fileInfo.SourcePath)) {
      return $false
    }
    if ($result) { $copiedFiles += $result }
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
