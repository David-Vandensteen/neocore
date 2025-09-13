function Assert-BuildPath {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath,

        [Parameter(Mandatory=$true)]
        [string]$LogFile
    )

    # Check for existing build directory
    $projectRootPath = (Get-Item $ProjectSrcPath).Parent.FullName
    $buildPath = "$projectRootPath\build"

    if (Test-Path $buildPath) {
        Write-Host ""
        Write-Host "*** BUILD DIRECTORY EXISTS ***" -ForegroundColor Red -BackgroundColor Black
        Write-Host ""
        Write-Host "A build directory already exists and must be removed before migration." -ForegroundColor Red
        Write-Host "Build directory: $buildPath" -ForegroundColor Yellow
        Write-Host ""
        Write-Log -File $LogFile -Level "ERROR" -Message "Migration stopped: Build directory exists at $buildPath"
        return $false
    }

    Write-Log -File $LogFile -Level "INFO" -Message "Build directory check passed: $buildPath does not exist"
    return $true
}
