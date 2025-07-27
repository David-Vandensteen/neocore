function MakServeMame {
  While ($true) {
    if (-not (Build-Sprite)) { return $false }
    if (-not (Build-Program)) { return $false }
    if (-not (Build-ISO)) { return $false }
    if (-not (Build-Mame)) { return $false }
    if (-not (Start-Mame)) { return $false }
    Watch-Folder -Path "."
    Stop-Emulators
  }
}