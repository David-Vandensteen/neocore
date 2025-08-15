function Copy-Makefile {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath,

        [Parameter(Mandatory=$true)]
        [string]$SourceNeocorePath,

        [Parameter(Mandatory=$true)]
        [string]$LogFile
    )

    Write-Host "Updating Makefile..." -ForegroundColor Cyan
    Write-Log -File $LogFile -Level "INFO" -Message "Starting Makefile update"

    $sourceMakefile = "$SourceNeocorePath\bootstrap\standalone\Makefile"
    $targetMakefile = "$ProjectSrcPath\Makefile"

    # Check if source Makefile exists
    if (-not (Test-Path $sourceMakefile)) {
        $errorMsg = "Source Makefile not found: $sourceMakefile"
        Write-Host "  ERROR: $errorMsg" -ForegroundColor Red
        Write-Log -File $LogFile -Level "ERROR" -Message $errorMsg
        return $false
    }

    try {
        # Copy Makefile from source to target
        Copy-Item -Path $sourceMakefile -Destination $targetMakefile -Force
        Write-Host "  Makefile updated successfully" -ForegroundColor Green
        Write-Log -File $LogFile -Level "SUCCESS" -Message "Makefile updated from: $sourceMakefile to: $targetMakefile"
        return $true

    } catch {
        $errorMsg = "Failed to update Makefile: $($_.Exception.Message)"
        Write-Host "  ERROR: $errorMsg" -ForegroundColor Red
        Write-Log -File $LogFile -Level "ERROR" -Message $errorMsg
        return $false
    }
}
