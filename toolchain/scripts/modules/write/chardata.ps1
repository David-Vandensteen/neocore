function Parse-Error {
  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $buildPathProject = "$projectBuildPath\$($Config.project.name)"
  Get-Content -Path "$buildPathProject\sprite.log" -Force

  if (Select-String -Path "$buildPathProject\sprite.log" -Pattern "System.IO.DirectoryNotFoundException") {
    Write-Host "Error: Directory not found - Check your file paths in the XML configuration" -ForegroundColor Red
    return $false
  }

  if (Select-String -Path "$buildPathProject\sprite.log" -Pattern "Invalid dimension") {
    Write-Host "Invalid dimension" -ForegroundColor Red
    return $false
  }
  if (Select-String -Path "$buildPathProject\sprite.log" -Pattern "est pas valide") {
    Write-Host "Invalid parameter" -ForegroundColor Red
    return $false
  }

  if ((Get-ChildItem -Path "." -Filter "*.*_reject.*" -Recurse -ErrorAction SilentlyContinue -Force).Length -ne 0) {
    Write-Host "Open reject *_reject file(s)" -ForegroundColor Red
    Write-Host "Fix asset and remove *_reject file(s) in your project before launch a new build ..." -ForegroundColor Red
    Write-Host "Sprite reject..." -ForegroundColor Red
    return $false
  }

  return $true
}

function Write-ChardataXML {
  param(
    [Parameter(Mandatory=$true)][String] $InputFile,
    [Parameter(Mandatory=$true)][String] $OutputFile
  )

  $xmlDoc = New-Object System.Xml.XmlDocument
  $xmlDoc.Load($InputFile)

  $charDataNode = $xmlDoc.SelectSingleNode("//chardata")

  if ($charDataNode -eq $null) {
    Write-Host "No chardata node found in XML" -ForegroundColor Red
    return $false
  }

  $xmlContent = $charDataNode.OuterXml
  $xmlContent = $xmlContent.Replace("{{build}}", $(Get-TemplatePath -Path $Config.project.buildPath))
  $xmlContent = $xmlContent.Replace("{{neocore}}", $(Get-TemplatePath -Path $Config.project.neocorePath))
  $xmlContent = $xmlContent.Replace("{{name}}", $Config.project.name)

  $newXmlDoc = New-Object System.Xml.XmlDocument
  try {
    $newXmlDoc.LoadXml($xmlContent)
    $newXmlDoc.Save($OutputFile)
    return $true
  } catch {
    Write-Host "Failed to save CharData XML: $($_.Exception.Message)" -ForegroundColor Red
    return $false
  }
}

function Write-Sprite {
  param (
    [Parameter(Mandatory=$true)][String] $Format,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $XMLFile
  )
  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $buildPathProject = "$projectBuildPath\$($Config.project.name)"

  Write-Host "Compiling sprites" -ForegroundColor Yellow
  if ((Test-Path -Path $XMLFile) -eq $false) {
    Write-Host "$XMLFile not found" -ForegroundColor Red
    return $false
  }

  & BuildChar.exe $XMLFile 2>&1 | Tee-Object -FilePath "$buildPathProject\sprite.log"
  if (-not (Parse-Error)) {
    return $false
  }

  if ($Config.project.gfx.DAT.chardata.setup.PSObject.Properties.Name -contains "charfile" -and $Config.project.gfx.DAT.chardata.setup.charfile) {
    $charfile = Get-TemplatePath -Path $Config.project.gfx.DAT.chardata.setup.charfile
  } else {
    $charfile = "char.bin"
  }

  $projectBuildPath = Get-TemplatePath -Path $projectBuildPath
  $projectBuildPath = "$projectBuildPath\$($Config.project.name)"
  $projectName = $Config.project.name

  if (Test-Path -Path "$projectBuildPath\$($projectName).cd") {
    Remove-Item -Path "$projectBuildPath\$($projectName).cd" -Force
  }

  & CharSplit.exe $charfile "-$Format" $OutputFile
  Remove-Item -Path $charfile -Force
  Rename-Item -Path "$projectBuildPath\$($projectName).SPR" `
    -NewName "$($projectName).cd" -Force

  if ((Test-Path -Path "$OutputFile.$Format") -eq $true) {
    Write-Host "Builded sprites $OutputFile.$Format" -ForegroundColor Green
    Write-Host ""
    return $true
  } else {
    Write-Host ("error - {0}.{1} was not generated" -f $OutputFile, $Format) -ForegroundColor Red
    return $false
  }
}
