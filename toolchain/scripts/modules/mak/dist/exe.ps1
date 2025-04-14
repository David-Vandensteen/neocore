function MakDistExe {
  if ((Test-Path -Path "$($Config.project.buildPath)\tools\nsis-3.08") -eq $false) { Install-NSIS }
  Build-Sprite
  Build-Program
  Build-ISO
  Build-Mame
  Build-EXE
}