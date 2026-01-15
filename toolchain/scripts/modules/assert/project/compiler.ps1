function Assert-ProjectCompiler {
  # Remove deprecated compiler.version if it exists
  if ($Config.project.compiler.version) {
    Write-Host "Removing deprecated compiler.version from project.xml..." -ForegroundColor Yellow
    $projectXmlPath = "project.xml"

    if (Test-Path -Path $projectXmlPath) {
      [xml]$xmlContent = Get-Content -Path $projectXmlPath

      if ($xmlContent.project.compiler.version) {
        $versionNode = $xmlContent.project.compiler.SelectSingleNode("version")
        if ($versionNode) {
          $versionNode.ParentNode.RemoveChild($versionNode) | Out-Null
          $xmlContent.Save((Resolve-Path $projectXmlPath).Path)
          Write-Host "Removed deprecated compiler.version from project.xml" -ForegroundColor Green

          # Reload the config
          [xml]$Config = Get-Content -Path $projectXmlPath
        }
      }
    }
  }

  # Remove deprecated compiler.name if it exists
  if ($Config.project.compiler.name) {
    Write-Host "Removing deprecated compiler.name from project.xml..." -ForegroundColor Yellow
    $projectXmlPath = "project.xml"

    if (Test-Path -Path $projectXmlPath) {
      [xml]$xmlContent = Get-Content -Path $projectXmlPath

      if ($xmlContent.project.compiler.name) {
        $nameNode = $xmlContent.project.compiler.SelectSingleNode("name")
        if ($nameNode) {
          $nameNode.ParentNode.RemoveChild($nameNode) | Out-Null
          $xmlContent.Save((Resolve-Path $projectXmlPath).Path)
          Write-Host "Removed deprecated compiler.name from project.xml" -ForegroundColor Green

          # Reload the config
          [xml]$Config = Get-Content -Path $projectXmlPath
        }
      }
    }
  }

  # Update compiler.path to new version
  $newPath = "{{build}}\gcc\gcc-13.2.0"
  if ($Config.project.compiler.path -ne $newPath) {
    Write-Host "Updating compiler.path to $newPath..." -ForegroundColor Yellow
    $projectXmlPath = "project.xml"

    if (Test-Path -Path $projectXmlPath) {
      [xml]$xmlContent = Get-Content -Path $projectXmlPath

      $xmlContent.project.compiler.path = $newPath
      $xmlContent.Save((Resolve-Path $projectXmlPath).Path)
      Write-Host "Updated compiler.path to $newPath" -ForegroundColor Green

      # Reload the config
      [xml]$Config = Get-Content -Path $projectXmlPath
    }
  }

  Write-Host "compiler config is compliant" -ForegroundColor Green
  return $true
}