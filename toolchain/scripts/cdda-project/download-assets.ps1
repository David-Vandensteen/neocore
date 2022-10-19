# TODO : download command for project
Import-Module "..\..\toolchain\scripts\modules\module-download.ps1"

if ((Test-Path -Path "assets\sounds\cdda") -eq $false) {
  New-Item -Path "assets\sounds\cdda" -ItemType Directory
}

if ((Test-Path -Path "assets\sounds\cdda\Sweet_Mermaids.wav") -eq $false) {
  Download -URL "http://azertyvortex.free.fr/download/Sweet_Mermaids.wav" -Path "./assets/sounds/cdda"
}

if ((Test-Path -Path "assets\sounds\cdda\Level One.wav") -eq $false) {
  Download -URL "http://azertyvortex.free.fr/download/Level One.wav" -Path "./assets/sounds/cdda"
}

if ((Test-Path -Path "assets\sounds\cdda\The Moon - High Orbit.wav") -eq $false) {
  Download -URL "http://azertyvortex.free.fr/download/The Moon - High Orbit.wav" -Path "./assets/sounds/cdda"
}