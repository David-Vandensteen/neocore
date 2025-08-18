# Import required modules
. "$PSScriptRoot\..\write\log.ps1"

function Assert-Gitignore {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath,

        [Parameter(Mandatory=$true)]
        [string]$LogFile
    )

    Write-Host "Checking .gitignore configuration..." -ForegroundColor Cyan
    Write-Log -File $LogFile -Level "INFO" -Message "Starting .gitignore check"

    # Calculate project root (parent of src directory)
    $projectRoot = (Get-Item $ProjectSrcPath).Parent.FullName
    $gitignorePath = "$projectRoot\.gitignore"

    Write-Log -File $LogFile -Level "INFO" -Message "Checking .gitignore at: $gitignorePath"

    if (-not (Test-Path $gitignorePath)) {
        Write-Host "  .gitignore not found - this is optional" -ForegroundColor Yellow
        Write-Log -File $LogFile -Level "WARNING" -Message ".gitignore not found at: $gitignorePath"
        return $true  # Not having .gitignore is not a blocking error
    }

    try {
        $gitignoreContent = Get-Content -Path $gitignorePath -ErrorAction Stop
        $issuesFound = @()

        # Check for problematic patterns that should be fixed in v3
        foreach ($line in $gitignoreContent) {
            $trimmedLine = $line.Trim()

            # Skip empty lines and comments
            if ([string]::IsNullOrWhiteSpace($trimmedLine) -or $trimmedLine.StartsWith('#')) {
                continue
            }

            # Remove obsolete externs.h entry (no longer needed in v3)
            if ($trimmedLine -eq "externs.h") {
                $issuesFound += "'externs.h' entry found - should be removed in gitignore"
                continue
            }

            # Check for patterns that should be absolute paths
            if ($trimmedLine -eq "build/") {
                $issuesFound += "Line '$trimmedLine' should be '/build/' (absolute path from repository root)"
            }
            elseif ($trimmedLine -eq "dist/") {
                $issuesFound += "Line '$trimmedLine' should be '/dist/' (absolute path from repository root)"
            }
            elseif ($trimmedLine -eq "out/") {
                $issuesFound += "Line '$trimmedLine' should be '/out/' (absolute path from repository root)"
            }
        }

        if ($issuesFound.Count -gt 0) {
            Write-Host "  Issues found in .gitignore:" -ForegroundColor Yellow
            foreach ($issue in $issuesFound) {
                Write-Host "    - $issue" -ForegroundColor Red
                Write-Log -File $LogFile -Level "WARNING" -Message ".gitignore issue: $issue"
            }
            Write-Host ""
            Write-Host "  These issues should be manually fixed after migration." -ForegroundColor Yellow
            Write-Host "  Using absolute paths (starting with /) ensures patterns work correctly" -ForegroundColor Yellow
            Write-Host "  from any subdirectory in your repository." -ForegroundColor Yellow
            Write-Host ""

            Write-Log -File $LogFile -Level "WARNING" -Message ".gitignore check completed with $($issuesFound.Count) issues requiring manual review"
            return $true  # Don't block migration for gitignore issues
        } else {
            Write-Host "  .gitignore configuration looks good" -ForegroundColor Green
            Write-Log -File $LogFile -Level "SUCCESS" -Message ".gitignore check passed - no issues found"
            return $true
        }

    } catch {
        Write-Host "  Error reading .gitignore: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -File $LogFile -Level "ERROR" -Message "Error reading .gitignore: $($_.Exception.Message)"
        return $true  # Don't block migration for gitignore read errors
    }
}
