function Get-ManifestVersion {
    param (
        [Parameter(Mandatory=$true)]
        [xml]$ManifestXml,

        [Parameter(Mandatory=$true)]
        [string]$Information,

        [Parameter(Mandatory=$true)]
        [string]$LogFile,

        [Parameter(Mandatory=$false)]
        [string]$ManifestPath = "Unknown"
    )

    try {
        if ($ManifestXml.manifest -and $ManifestXml.manifest.version) {
            $version = $ManifestXml.manifest.version
            Write-Host $Information": $version" -ForegroundColor White
            Write-Log -File $LogFile -Level "INFO" -Message "$Information`: $version"
            return $version
        } else {
            Write-Host "Invalid manifest.xml format:" -ForegroundColor Red
            Write-Host "  Expected: <manifest><version>X.X.X</version></manifest>" -ForegroundColor Yellow
            if ($ManifestPath -ne "Unknown") {
                Write-Host "  File: $ManifestPath" -ForegroundColor Yellow
            }
            Write-Log -File $LogFile -Level "ERROR" -Message "Invalid manifest.xml format: $ManifestPath - Missing manifest.version element"
            return $null
        }
    } catch {
        Write-Host "Failed to parse manifest.xml: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -File $LogFile -Level "ERROR" -Message "Failed to parse manifest.xml: $($_.Exception.Message)"
        return $null
    }
}
