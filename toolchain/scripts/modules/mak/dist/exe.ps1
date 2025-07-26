function MakDistExe {
  $resolvedBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  if ((Test-Path -Path "$resolvedBuildPath\tools\nsis-3.08") -eq $false) { Install-NSIS }
  Build-ISO
  Build-Mame
  Build-EXE
}