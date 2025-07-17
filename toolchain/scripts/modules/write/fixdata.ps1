function Write-FixdataXML {
  param(
    [Parameter(Mandatory=$true)][String] $InputFile,
    [Parameter(Mandatory=$true)][String] $OutputFile
  )

  $xmlDoc = New-Object System.Xml.XmlDocument
  $xmlDoc.Load($InputFile)

  $fixDataNode = $xmlDoc.SelectSingleNode("//fixdata/chardata")

  $newXmlDoc = New-Object System.Xml.XmlDocument

  $newNode = $newXmlDoc.ImportNode($fixDataNode, $true)
  $newXmlDoc.AppendChild($newNode)

  $newXmlDoc.Save($OutputFile)
}

function Write-Fix {
  param (
    [Parameter(Mandatory=$true)][String] $XMLFile
  )
  $buildPathProject = "$($Config.project.buildPath)\$($Config.project.name)"
  Write-Host "Compiling fix data" -ForegroundColor Yellow
  if ((Test-Path -Path $XMLFile) -eq $false) {
    Write-Host "$XMLFile not found" -ForegroundColor Red
    exit 1
  }

  Write-Host "Running BuildChar on $XMLFile" -ForegroundColor Cyan

  & BuildChar.exe $XMLFile | Tee-Object -FilePath "$buildPathProject\fix.log"
}