function Write-Log {
    param (
        [Parameter(Mandatory=$true)]
        [string]$File,

        [Parameter(Mandatory=$true)]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message
    )

    # Get timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Format log entry
    $logEntry = "[$timestamp] [$Level] $Message"

    # Write to file
    try {
        # Append to log file
        Add-Content -Path $File -Value $logEntry -Encoding UTF8
    } catch {
        # Silent failure - log function should not interfere with script execution
    }
}
