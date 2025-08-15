function Get-ProjectVersions {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectNeocorePath,

        [Parameter(Mandatory=$false)]
        [string]$SourceNeocorePath = $null,

        [Parameter(Mandatory=$true)]
        [string]$LogFile
    )

    # Get current project version
    $projectManifestPath = "$ProjectNeocorePath\manifest.xml"

    try {
        [xml]$projectManifest = Get-Content -Path $projectManifestPath
        $currentVersion = Get-ManifestVersion -ManifestXml $projectManifest -Information "Current project version" -LogFile $LogFile -ManifestPath $projectManifestPath
        if ($null -eq $currentVersion) {
            return $null
        }
    } catch {
        Write-Host "ERROR: Failed to read project manifest: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -File $LogFile -Level "ERROR" -Message "Failed to read project manifest: $($_.Exception.Message)"
        return $null
    }

    # Get target NeoCore version
    if ($null -eq $SourceNeocorePath) {
        # Calculate path from the main script location
        $SourceNeocorePath = (Resolve-Path "$PSScriptRoot\..\..\..\..\..\..\..").Path
    }
    $sourceManifestPath = "$SourceNeocorePath\manifest.xml"

    try {
        [xml]$sourceManifest = Get-Content -Path $sourceManifestPath
        $targetVersion = Get-ManifestVersion -ManifestXml $sourceManifest -Information "Target NeoCore version" -LogFile $LogFile -ManifestPath $sourceManifestPath
        if ($null -eq $targetVersion) {
            return $null
        }
    } catch {
        Write-Host "ERROR: Failed to read source manifest: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -File $LogFile -Level "ERROR" -Message "Failed to read source manifest: $($_.Exception.Message)"
        return $null
    }

    # Return both versions as a hashtable
    return @{
        Current = $currentVersion
        Target = $targetVersion
    }
}
