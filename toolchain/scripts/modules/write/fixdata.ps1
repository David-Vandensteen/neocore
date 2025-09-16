function Write-FixdataXML {
  param(
    [Parameter(Mandatory=$true)][String] $InputFile,
    [Parameter(Mandatory=$true)][String] $OutputFile
  )

  try {
    $xmlDoc = New-Object System.Xml.XmlDocument
    $xmlDoc.Load($InputFile)

    $fixDataNode = $xmlDoc.SelectSingleNode("//fixdata/chardata")

    if ($null -eq $fixDataNode) {
      Write-Host "Error: fixdata/chardata node not found in $InputFile" -ForegroundColor Red
      return $false
    }

    $xmlContent = $fixDataNode.OuterXml
    $xmlContent = $xmlContent.Replace("{{build}}", $(Get-TemplatePath -Path $Config.project.buildPath))
    $xmlContent = $xmlContent.Replace("{{neocore}}", $(Get-TemplatePath -Path $Config.project.neocorePath))
    $xmlContent = $xmlContent.Replace("{{name}}", $Config.project.name)

    $newXmlDoc = New-Object System.Xml.XmlDocument
    $newXmlDoc.LoadXml($xmlContent)

    Write-Host "Saving fix data to $OutputFile" -ForegroundColor Cyan
    $newXmlDoc.Save($OutputFile)
    return $true
  }
  catch {
    Write-Host "Error processing fixdata XML: $($_.Exception.Message)" -ForegroundColor Red
    return $false
  }
}

function Write-Fix {
  param (
    [Parameter(Mandatory=$true)][String] $XMLFile
  )
  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $buildPathProject = "$projectBuildPath\$($Config.project.name)"
  Write-Host "Compiling fix data" -ForegroundColor Yellow

  # Assert that all fix files exist before attempting to build
  Write-Host "=== ASSERT FIXDATA CHARDATA FILES ===" -ForegroundColor Magenta
  Write-Host "Asserting fixdata chardata files existence" -ForegroundColor Yellow

  if ($Config.project.gfx.DAT.fixdata) {
    $fixDataNode = $Config.project.gfx.DAT.fixdata.chardata
    if ($fixDataNode) {
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
          $resolvedPath = $resolvedPath.Replace("{{build}}", $(Get-TemplatePath -Path $Config.project.buildPath))
          $resolvedPath = $resolvedPath.Replace("{{neocore}}", $(Get-TemplatePath -Path $Config.project.neocorePath))
          $resolvedPath = $resolvedPath.Replace("{{name}}", $Config.project.name)
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
        Write-Host "Fixdata chardata files assertion failed - cannot proceed with build" -ForegroundColor Red
        return $false
      }

      Write-Host "✓ All $checkedFiles fix files found successfully" -ForegroundColor Green
    }
  }

  if ((Test-Path -Path $XMLFile) -eq $false) {
    Write-Host "$XMLFile not found" -ForegroundColor Red
    return $false
  }

  Write-Host "Running BuildChar on $XMLFile" -ForegroundColor Cyan

  # Check if BuildChar.exe exists in PATH or current directory
  $buildCharPath = Get-Command "BuildChar.exe" -ErrorAction SilentlyContinue
  if (-not $buildCharPath) {
    Write-Host "Error: BuildChar.exe not found in PATH or current directory" -ForegroundColor Red
    Write-Host "Please ensure SDK is properly installed" -ForegroundColor Yellow
    return $false
  }

  & BuildChar.exe $XMLFile 2>&1 | Tee-Object -FilePath "$buildPathProject\fix.log"
  $buildCharExitCode = $LASTEXITCODE

  if ($buildCharExitCode -ne 0) {
    Write-Host "BuildChar.exe failed with exit code $buildCharExitCode" -ForegroundColor Red
    return $false
  }

  if (Select-String -Path "$buildPathProject\fix.log" -Pattern "System.IO.DirectoryNotFoundException") {
    Write-Host "Error: Check your file paths in the XML configuration" -ForegroundColor Red
    return $false
  }

  Write-Host "Fix data compiled successfully" -ForegroundColor Green
  return $true
}