function Normalize-Version {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Version
    )

    # Remove common suffixes like -rc, -alpha, -beta, etc.
    $normalizedVersion = $Version -replace '-.*$', ''

    # Ensure the version has at least 3 parts (major.minor.patch)
    $parts = $normalizedVersion.Split('.')
    while ($parts.Length -lt 3) {
        $normalizedVersion += '.0'
        $parts = $normalizedVersion.Split('.')
    }

    return $normalizedVersion
}

function Compare-ProjectVersions {
    param (
        [Parameter(Mandatory=$true)]
        [string]$CurrentVersion,

        [Parameter(Mandatory=$true)]
        [string]$TargetVersion,

        [Parameter(Mandatory=$true)]
        [string]$LogFile
    )

    try {
        # Normalize versions before parsing
        $normalizedCurrentVersion = Normalize-Version -Version $CurrentVersion
        $normalizedTargetVersion = Normalize-Version -Version $TargetVersion

        $currentVer = [System.Version]::Parse($normalizedCurrentVersion)
        $targetVer = [System.Version]::Parse($normalizedTargetVersion)

        if ($currentVer -lt $targetVer) {
            Write-Host ""
            Write-Host "*** MIGRATION REQUIRED ***" -ForegroundColor Green -BackgroundColor Black
            Write-Host ""
            Write-Host "Your project needs to be migrated:" -ForegroundColor Yellow
            Write-Host "  Current version: $CurrentVersion" -ForegroundColor Red
            Write-Host "  Target version:  $TargetVersion" -ForegroundColor Green
            Write-Host ""
            Write-Host "Migration will update your project to use NeoCore v$TargetVersion" -ForegroundColor White
            Write-Log -File $LogFile -Level "INFO" -Message "Migration required: $CurrentVersion -> $TargetVersion"
            return "major"
        } elseif ($currentVer -eq $targetVer) {
            Write-Host ""
            Write-Host "*** PROJECT XML UP TO DATE ***" -ForegroundColor Green -BackgroundColor Black
            Write-Host ""
            Write-Host "Your project XML is already using the target version:" -ForegroundColor Green
            Write-Host "  Current version: $CurrentVersion" -ForegroundColor Green
            Write-Host "  Target version:  $TargetVersion" -ForegroundColor Green
            Write-Host ""
            Write-Log -File $LogFile -Level "INFO" -Message "Project XML already at target version: $CurrentVersion"
            return "minor"
        } else {
            Write-Host ""
            Write-Host "*** VERSION CONFLICT ***" -ForegroundColor Red -BackgroundColor Black
            Write-Host ""
            Write-Host "Your project version is newer than the target:" -ForegroundColor Red
            Write-Host "  Current version: $CurrentVersion" -ForegroundColor Yellow
            Write-Host "  Target version:  $TargetVersion" -ForegroundColor Red
            Write-Host ""
            Write-Host "Cannot downgrade. Please use a newer NeoCore version." -ForegroundColor Red
            Write-Log -File $LogFile -Level "ERROR" -Message "Version conflict: Cannot downgrade from $CurrentVersion to $TargetVersion"
            return "conflict"
        }
    } catch {
        Write-Host "ERROR: Failed to parse version numbers: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -File $LogFile -Level "ERROR" -Message "Failed to parse version numbers: $($_.Exception.Message)"
        return "error"
    }
}
