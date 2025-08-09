# Migration-Logging.ps1
# Centralized logging functions for migration process

# Global variables for logging
$script:MigrationLogPath = ""
$script:MigrationStartTime = Get-Date

function Initialize-MigrationLogging {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath
    )

    $script:MigrationLogPath = "$ProjectSrcPath\..\migration.log"
    $script:MigrationStartTime = Get-Date

    # Test log file creation immediately
    try {
        "=== Migration Log Started at $($script:MigrationStartTime) ===" | Out-File -FilePath $script:MigrationLogPath -Encoding UTF8
        Write-Host "Log file initialized: $script:MigrationLogPath" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "ERROR: Cannot create log file at $script:MigrationLogPath" -ForegroundColor Red
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Write-MigrationLog {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [ValidateSet("INFO", "WARN", "ERROR", "SUCCESS")]
        [string]$Level = "INFO",

        [switch]$ShowOnConsole
    )

    if ([string]::IsNullOrEmpty($script:MigrationLogPath)) {
        Write-Warning "Migration logging not initialized. Call Initialize-MigrationLogging first."
        return
    }

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"

    # Write to log file
    try {
        $logDir = Split-Path -Parent $script:MigrationLogPath
        if (-not (Test-Path -Path $logDir)) {
            New-Item -ItemType Directory -Path $logDir -Force | Out-Null
        }
        $logEntry | Out-File -FilePath $script:MigrationLogPath -Append -Encoding UTF8
    } catch {
        Write-Warning "Could not write to log file '$script:MigrationLogPath': $($_.Exception.Message)"
    }

    # Optionally show on console
    if ($ShowOnConsole) {
        $color = switch ($Level) {
            "ERROR" { "Red" }
            "WARN" { "Yellow" }
            "SUCCESS" { "Green" }
            default { "White" }
        }
        Write-Host "[$Level] $Message" -ForegroundColor $color
    }
}

function Show-Error {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )

    Write-MigrationLog -Message "FATAL: $Message" -Level "ERROR" -ShowOnConsole
    exit 1
}

function Get-MigrationLogPath {
    return $script:MigrationLogPath
}
