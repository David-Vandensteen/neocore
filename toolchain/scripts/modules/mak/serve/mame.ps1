function MakServeMame {
  While ($true) {
    Build-Sprite
    Build-Program
    Build-ISO
    Build-Mame
    Start-Mame
    Watch-Folder -Path "."
    Stop-Emulators
  }
}