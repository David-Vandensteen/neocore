function Stop-Emulators {
  try {
    $raineProcessName = [System.IO.Path]::GetFileNameWithoutExtension($Config.project.emulator.raine.exeFile)
    $mameProcessName = [System.IO.Path]::GetFileNameWithoutExtension($Config.project.emulator.mame.exeFile)

    Write-Host "Stopping emulators if needed..." -ForegroundColor Cyan
    Write-Host "$MameProcessName, $RaineProcessName"

    # Check if any emulator processes are running
    $processes = Get-Process -Name $MameProcessName, $RaineProcessName -ErrorAction SilentlyContinue

    if ($processes) {
      Stop-Process -Name $MameProcessName, $RaineProcessName -Force -ErrorAction SilentlyContinue
      Write-Host "Stopped emulator processes" -ForegroundColor Green
    } else {
      Write-Host "No emulator processes running" -ForegroundColor Cyan
    }

    Write-Host ""
    return $true

  } catch {
    Write-Host "Error stopping emulators: $($_.Exception.Message)" -ForegroundColor Red
    return $false
  }
}
