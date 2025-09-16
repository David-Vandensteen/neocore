function Assert-ProjectGfxDatFixdataChardataFiles {
  param (
    [Parameter(Mandatory=$true)][xml] $ProjectConfig
  )

  Write-Host "=== ASSERT FIXDATA CHARDATA FILES ===" -ForegroundColor Magenta
  Write-Host "Asserting fixdata chardata files existence" -ForegroundColor Yellow

  # Check if fixdata exists in the project configuration
  if (-not $ProjectConfig.project.gfx.DAT.fixdata) {
    Write-Host "No fixdata configuration found - skipping fix files assertion" -ForegroundColor Cyan
    return $true
  }

  $fixDataNode = $ProjectConfig.project.gfx.DAT.fixdata.chardata
  if (-not $fixDataNode) {
    Write-Host "No fixdata chardata configuration found - skipping fix files assertion" -ForegroundColor Cyan
    return $true
  }

  $missingFiles = @()
  $checkedFiles = 0

  # Check files in fix elements
  $fixElements = $fixDataNode.SelectNodes("fix")
  Write-Host "Found $($fixElements.Count) fix elements to check" -ForegroundColor Cyan

  foreach ($fixElement in $fixElements) {
    $fileElement = $fixElement.SelectSingleNode("file")
    if ($fileElement -and $fileElement.InnerText) {
      $filePath = $fileElement.InnerText
      Write-Host "  Checking: $filePath" -ForegroundColor Gray

      # Simple path resolution for templates
      $resolvedPath = $filePath
      $resolvedPath = $resolvedPath.Replace("{{build}}", $(Get-TemplatePath -Path $ProjectConfig.project.buildPath))
      $resolvedPath = $resolvedPath.Replace("{{neocore}}", $(Get-TemplatePath -Path $ProjectConfig.project.neocorePath))
      $resolvedPath = $resolvedPath.Replace("{{name}}", $ProjectConfig.project.name)
      $resolvedPath = $resolvedPath.Replace('\', '/')

      if (-not (Test-Path -Path $resolvedPath)) {
        $missingFiles += $resolvedPath
        Write-Host "    ✗ Missing: $resolvedPath" -ForegroundColor Red
      } else {
        Write-Host "    ✓ Found: $resolvedPath" -ForegroundColor Green
      }
      $checkedFiles++
    }
  }

  # Report results
  if ($missingFiles.Count -gt 0) {
    Write-Host "" -ForegroundColor Red
    Write-Host "✗ Fix files assertion FAILED" -ForegroundColor Red
    Write-Host "Missing files:" -ForegroundColor Red
    foreach ($missingFile in $missingFiles) {
      Write-Host "  - $missingFile" -ForegroundColor Red
    }
    return $false
  }

  Write-Host "✓ All $checkedFiles fix files found successfully" -ForegroundColor Green
  return $true
}