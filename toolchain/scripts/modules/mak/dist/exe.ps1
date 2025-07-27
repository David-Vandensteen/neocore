function MakDistExe {
  $resolvedBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  if ((Test-Path -Path "$resolvedBuildPath\tools\nsis-3.08") -eq $false) {
    if (-not (Install-NSIS)) { return $false }
  }
  if (-not (Build-ISO)) { return $false }
  if (-not (Build-Mame)) { return $false }
  if (-not (Build-EXE)) { return $false }
  return $true
}