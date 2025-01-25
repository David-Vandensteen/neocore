function Show-Version {
  Write-Host ""
  Write-Host "----------------------------------------"
  Write-Host ""
  Write-Host "project name : $($Config.project.name)"
  Write-Host "project version : $($Config.project.version)"
  Write-Host "gcc version : $($Config.project.compiler.version)"

  [xml]$manifestRoot = (Get-Content -Path "$($config.project.buildPath)\manifest.xml")
  $manifestPath = "$($Config.project.buildPath)\manifest.xml"

  if (Test-Path -Path $manifestPath) {
    [xml]$manifestRoot = Get-Content -Path $manifestPath
    if ($manifestRoot.manifest -and $manifestRoot.manifest.version) {
      $neocoreVersion = $manifestRoot.manifest.version
      Write-Host "neocore version : $neocoreVersion"
    } else {
      Write-Host "error : 'manifest.version' not found" -ForegroundColor Red
    }
  } else {
    Write-Host "error : manifest.xml not found" -ForegroundColor Red
  }
}