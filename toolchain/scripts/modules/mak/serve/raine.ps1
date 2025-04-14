function MakServeRaine {
  While ($true) {
    Build-Sprite
    Build-Program
    Build-ISO
    Start-Raine
    Watch-Folder -Path "."
    Stop-Emulators
  }
}