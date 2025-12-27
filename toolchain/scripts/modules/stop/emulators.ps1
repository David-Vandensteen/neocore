function Stop-Emulators {
  try {


    $raineProcessName = if ($Config.project.emulator.raine.exeFile) {
        [System.IO.Path]::GetFileNameWithoutExtension($Config.project.emulator.raine.exeFile)
    } else { $null }
    $mameProcessName = if ($Config.project.emulator.mame.exeFile) {
        [System.IO.Path]::GetFileNameWithoutExtension($Config.project.emulator.mame.exeFile)
    } else { $null }

    # Filter out empty or null process names
    $processNames = @($mameProcessName, $raineProcessName) | Where-Object { $_ -and $_.Trim() -ne "" }

    Write-Host "Stopping emulators if needed..." -ForegroundColor Cyan
    Write-Host ($processNames -join ", ")

    if ($processNames.Count -gt 0) {
      # Check if any emulator processes are running
      $processes = Get-Process -Name $processNames -ErrorAction SilentlyContinue
      if ($processes) {
        Stop-Process -Name $processNames -Force -ErrorAction SilentlyContinue
        Write-Host "Stopped emulator processes" -ForegroundColor Green
      } else {
        Write-Host "No emulator processes running" -ForegroundColor Cyan
      }
    } else {
      Write-Host "No emulator process names to stop" -ForegroundColor Yellow
    }

    Write-Host ""
    return $true

  } catch {
    Write-Host "Error stopping emulators: $($_.Exception.Message)" -ForegroundColor Red
    return $false
  }
}
