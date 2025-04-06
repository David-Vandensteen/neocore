function Stop-Emulators {
  $raineProcessName = [System.IO.Path]::GetFileNameWithoutExtension($Config.project.emulator.raine.exeFile)
  $mameProcessName = [System.IO.Path]::GetFileNameWithoutExtension($Config.project.emulator.mame.exeFile)

  Write-Host "Stopping emulators if needed..." -ForegroundColor Blue
  Write-Host "$MameProcessName, $RaineProcessName"
  Stop-Process -Name $MameProcessName, $RaineProcessName -Force -ErrorAction SilentlyContinue
  Write-Host ""
}
