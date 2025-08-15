# Import required modules
. "$PSScriptRoot\..\get\manifest\version.ps1"
. "$PSScriptRoot\..\write\log.ps1"

function Assert-Manifest {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectNeocorePath,

        [Parameter(Mandatory=$false)]
        [string]$SourceNeocorePath = $null,

        [Parameter(Mandatory=$true)]
        [string]$LogFile
    )

    # Get current version from project
    $manifestPath = "$ProjectNeocorePath\manifest.xml"

    if (-not (Test-Path $manifestPath)) {
        Write-Host "Project manifest.xml not found: $manifestPath" -ForegroundColor Red
        Write-Log -File $LogFile -Level "ERROR" -Message "Project manifest.xml not found: $manifestPath"
        return $false
    }

    try {
        [xml]$projectManifest = Get-Content -Path $manifestPath
        $currentVersion = Get-ManifestVersion -ManifestXml $projectManifest -Information "Found current version" -LogFile $LogFile -ManifestPath $manifestPath
        if ($null -eq $currentVersion) {
            return $false
        }
    } catch {
        Write-Host "Failed to read project manifest.xml: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -File $LogFile -Level "ERROR" -Message "Failed to read project manifest.xml: $($_.Exception.Message)"
        return $false
    }

    # Get target version from source NeoCore
    if ($null -eq $SourceNeocorePath) {
        # Calculate path from the main script location as fallback
        $SourceNeocorePath = (Resolve-Path "$PSScriptRoot\..\..\..\..\..\..\..").Path
    }
    $sourceManifestPath = "$SourceNeocorePath\manifest.xml"

    if (-not (Test-Path $sourceManifestPath)) {
        Write-Host "Source manifest.xml not found: $sourceManifestPath" -ForegroundColor Red
        Write-Log -File $LogFile -Level "ERROR" -Message "Source manifest.xml not found: $sourceManifestPath"
        return $false
    }

    try {
        [xml]$sourceManifest = Get-Content -Path $sourceManifestPath
        $targetVersion = Get-ManifestVersion -ManifestXml $sourceManifest -Information "Found target version" -LogFile $LogFile -ManifestPath $sourceManifestPath
        if ($null -eq $targetVersion) {
            return $false
        }
    } catch {
        Write-Host "Failed to read source manifest.xml: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -File $LogFile -Level "ERROR" -Message "Failed to read source manifest.xml: $($_.Exception.Message)"
        return $false
    }

    # Check minimum version support (must be >= 2.0.0)
    if (-not (Test-VersionGreaterOrEqual -Version $currentVersion -MinVersion "2.0.0")) {
        Write-Host ""
        Write-Host "*** UNSUPPORTED VERSION ***" -ForegroundColor Red -BackgroundColor Black
        Write-Host ""
        Write-Host "This migration script only supports NeoCore v2.0.0 and above." -ForegroundColor Red
        Write-Host "Current project version: $currentVersion" -ForegroundColor Yellow
        Write-Host "Minimum supported version: 2.0.0" -ForegroundColor Green
        Write-Host ""
        Write-Log -File $LogFile -Level "ERROR" -Message "Unsupported version $currentVersion (minimum: 2.0.0)"
        return $false
    }

    # Check if already migrated to target version
    if (Test-VersionGreaterOrEqual -Version $currentVersion -MinVersion $targetVersion) {
        Write-Host ""
        Write-Host "Project is already migrated to version $targetVersion or higher." -ForegroundColor Green
        Write-Host "Current version: $currentVersion" -ForegroundColor White
        Write-Host ""
        Write-Log -File $LogFile -Level "INFO" -Message "Project already migrated to version $targetVersion or higher (current: $currentVersion)"
        return $false
    }

    Write-Host "Version check passed:" -ForegroundColor Green
    Write-Host "  Current version: $currentVersion" -ForegroundColor White
    Write-Host "  Target version: $targetVersion" -ForegroundColor White
    Write-Host ""

    Write-Log -File $LogFile -Level "SUCCESS" -Message "Version check passed: $currentVersion -> $targetVersion"
    return $true
}

function Test-VersionGreaterOrEqual {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Version,

        [Parameter(Mandatory=$true)]
        [string]$MinVersion
    )

    try {
        $ver = [System.Version]::Parse($Version)
        $minVer = [System.Version]::Parse($MinVersion)
        return $ver -ge $minVer
    } catch {
        return $false
    }
}
