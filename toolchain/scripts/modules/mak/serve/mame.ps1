function MakServeMame {
  While ($true) {
    if (-not (Build-Sprite)) { return $false }
    if (-not (Build-Program)) { return $false }
    if (-not (Build-ISO)) { return $false }
    if (-not (Build-Mame)) { return $false }
    if (-not (Start-Mame)) { return $false }

    # Watch for changes with timeout
    if (-not (Watch-Folder -Path "." -TimeoutSeconds 1800)) {  # 30 minutes timeout
      Write-Host "Watch timeout or error - stopping serve mode" -ForegroundColor Yellow
      return $true  # Exit gracefully on timeout
    }

    Stop-Emulators
  }
}