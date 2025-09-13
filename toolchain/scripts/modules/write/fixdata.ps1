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