function Watch-Folder {
  param (
    [Parameter(Mandatory=$true)][String] $Path,
    [Int] $TimeoutSeconds = 300  # 5 minutes par défaut
  )

  if (-not (Test-Path -Path $Path)) {
    Write-Host "error - $Path not found" -ForegroundColor Red
    return $false
  }

  Write-Host "Waiting for changes in $Path (timeout: ${TimeoutSeconds}s)" -ForegroundColor Yellow

  try {
    $sizeLast = (Get-ChildItem -Path $Path | Measure-Object -Sum Length | Select-Object Count, Sum).Sum
    $sizeCurrent = $sizeLast
    $startTime = Get-Date

    Write-Host "Initial folder size: $sizeCurrent bytes" -ForegroundColor Cyan

    while ($sizeLast -eq $sizeCurrent) {
      Start-Sleep -Seconds 5

      # Vérification timeout
      $elapsed = (Get-Date) - $startTime
      if ($elapsed.TotalSeconds -gt $TimeoutSeconds) {
        Write-Host "Watch timeout reached after $($elapsed.TotalSeconds) seconds" -ForegroundColor Yellow
        return $false
      }

      try {
        $sizeCurrent = (Get-ChildItem -Path $Path | Measure-Object -Sum Length | Select-Object Count, Sum).Sum
      } catch {
        Write-Host "Error accessing path during watch: $($_.Exception.Message)" -ForegroundColor Red
        return $false
      }
    }

    Write-Host "Change detected in $Path" -ForegroundColor Green
    Write-Host "Previous size: $sizeLast bytes, New size: $sizeCurrent bytes" -ForegroundColor Cyan
    return $true

  } catch {
    Write-Host "Error initializing folder watch: $($_.Exception.Message)" -ForegroundColor Red
    return $false
  }
}