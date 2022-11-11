function Stop-Emulators {
  Logger-Info -Message "stop emulator if needed"
  Stop-Process -Name mame64, raine32 -Force -ErrorAction SilentlyContinue
  Write-Host ""
}
