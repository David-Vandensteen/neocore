
function Get-HashFilePath {
  param (
    [Parameter(Mandatory=$true)][String] $File,
    [Parameter(Mandatory=$true)][String] $HashPath
  )
  $name = (Get-ChildItem $File).Name
  $hash = (Get-FileHash $File).Hash
  Write-Host "debug : hash $HashPath\$name-$hash.hash" -ForegroundColor Yellow
  return [String] "$HashPath\$name-$hash.hash"
}
function Get-Hash {
  param (
    [Parameter(Mandatory=$true)][String] $Path
  )
}

function Set-Hash {
  param (
    [Parameter(Mandatory=$true)][String] $Path
  )
}

function Compare-ApplyHash {
  param (
    [Parameter(Mandatory=$true)][String] $FilePath,
    [Parameter(Mandatory=$true)][String] $HashPath
  )
  $rt = $true
  $hashFilePath = Get-HashFilePath -File $FilePath -HashPath $HashPath
  If (-Not(Test-Path -Path $hashFilePath)) {
    New-Item -Path $hashFilePath -Force | Out-Null
    $rt = $false
  }
  return $rt
}

function Set-HashSprites {
  param (
    [Parameter(Mandatory=$true)][String] $XMLFile,
    [Parameter(Mandatory=$true)][String] $Path
  )
  if (-Not(Test-Path -Path $XMLFile)) {
    Write-Host "error : $XMLFile not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $Path)) {
    mkdir -Path $Path
  }

  Select-Xml -Path $XMLFile -XPath /chardata/scrl/file | ForEach-Object {
    $rt = Compare-ApplyHash -FilePath $_.Node.InnerXML -HashPath $Path
    if ($rt -eq $false) { return $false }
  }
  Select-Xml -Path $XMLFile -XPath /chardata/pict/file | ForEach-Object {
    $rt = Compare-ApplyHash -FilePath $_.Node.InnerXML -HashPath $Path
    if ($rt -eq $false) { return $false }
  }
  Select-Xml -Path $XMLFile -XPath /chardata/sprt/file | ForEach-Object {
    $rt = Compare-ApplyHash -FilePath $_.Node.InnerXML -HashPath $Path
    if ($rt -eq $false) { return $false }
  }
  return $rt
}