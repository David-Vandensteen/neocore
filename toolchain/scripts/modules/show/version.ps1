function Show-Version {
  try {
    Write-Host ""
    Write-Host "----------------------------------------"
    Write-Host ""
    Write-Host "project name : $($Config.project.name)"
    Write-Host "project version : $($Config.project.version)"
    Write-Host "gcc version : $($Config.project.compiler.version)"

    $buildPath = Get-TemplatePath -Path $Config.project.buildPath
    $manifestPath = Join-Path $buildPath "manifest.xml"

    if (Test-Path -Path $manifestPath) {
      try {
        [xml]$manifestRoot = Get-Content -Path $manifestPath -ErrorAction Stop
        if ($manifestRoot.manifest -and $manifestRoot.manifest.version) {
          $neocoreVersion = $manifestRoot.manifest.version
          Write-Host "neocore version : $neocoreVersion"
        } else {
          Write-Host "warning : 'manifest.version' not found in XML structure" -ForegroundColor Yellow
        }
      } catch {
        Write-Host "error parsing manifest.xml: $($_.Exception.Message)" -ForegroundColor Red
        return $false
      }
    } else {
      Write-Host "warning : manifest.xml not found at $manifestPath" -ForegroundColor Yellow
    }

    Write-Host ""
    return $true

  } catch {
    Write-Host "Error displaying version information: $($_.Exception.Message)" -ForegroundColor Red
    return $false
  }
}