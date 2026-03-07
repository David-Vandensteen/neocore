function Assert-ProjectCompiler {
  param ([Parameter(Mandatory=$true)][xml] $Config)

  if (-Not($Config.project.compiler.path)) {
    throw "project.compiler.path not found in project.xml"
  }
  if (-Not($Config.project.compiler.includePath)) {
    throw "project.compiler.includePath not found in project.xml"
  }
  if (-Not($Config.project.compiler.libraryPath)) {
    throw "project.compiler.libraryPath not found in project.xml"
  }
  if (-Not($Config.project.compiler.crtPath)) {
    throw "project.compiler.crtPath not found in project.xml"
  }
  if (-Not($Config.project.compiler.systemFile)) {
    throw "project.compiler.systemFile not found in project.xml"
  } else {
    if (-Not(Assert-ProjectCompilerSystemFile)) {
      throw "Project system file assertion failed"
    }
  }

  # Remove deprecated compiler.name
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

  # Remove deprecated compiler.version
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
}
