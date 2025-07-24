function Write-FixdataXML {
  param(
    [Parameter(Mandatory=$true)][String] $InputFile,
    [Parameter(Mandatory=$true)][String] $OutputFile
  )

  $xmlDoc = New-Object System.Xml.XmlDocument
  $xmlDoc.Load($InputFile)

  $fixDataNode = $xmlDoc.SelectSingleNode("//fixdata/chardata")

  $xmlContent = $fixDataNode.OuterXml
  $xmlContent = $xmlContent.Replace("{{build}}", $(Get-TemplatePath -Path $Config.project.buildPath))
  $xmlContent = $xmlContent.Replace("{{neocore}}", $(Get-TemplatePath -Path $Config.project.neocorePath))
  $xmlContent = $xmlContent.Replace("{{name}}", $(Get-TemplatePath -Path $Config.project.name))

  $newXmlDoc = New-Object System.Xml.XmlDocument
  $newXmlDoc.LoadXml($xmlContent)

  Write-Host "Saving fix data to $OutputFile" -ForegroundColor Cyan
  $newXmlDoc.Save($OutputFile)
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
    exit 1
  }

  Write-Host "Running BuildChar on $XMLFile" -ForegroundColor Cyan

  & BuildChar.exe $XMLFile 2>&1 | Tee-Object -FilePath "$buildPathProject\fix.log"
  $buildCharExitCode = $LASTEXITCODE

  if ($buildCharExitCode -ne 0) {
    Write-Host "BuildChar.exe failed with exit code $buildCharExitCode" -ForegroundColor Red
    exit $buildCharExitCode
  }

  if (Select-String -Path "$buildPathProject\fix.log" -Pattern "System.IO.DirectoryNotFoundException") {
    Write-Host "Error: Check your file paths in the XML configuration" -ForegroundColor Red
    exit 1
  }

  Write-Host "Fix data compiled successfully" -ForegroundColor Green
}