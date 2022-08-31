function Stop-Emulators {
  Write-Host "Stop emulator if needed"
  Stop-Process -Name mame64, raine32 -Force -ErrorAction SilentlyContinue
}
