
function Get-HashFilePath {
  param (
    [Parameter(Mandatory=$true)][String] $File,
    [Parameter(Mandatory=$true)][String] $PathHash
  )
  $name = (Get-ChildItem $File).Name
  $hash = (Get-FileHash $File).Hash
  Write-Host "debug : hash $PathHash\$name-$hash.hash" -ForegroundColor Yellow
  return [String] "$PathHash\$name-$hash.hash"
}
function Get-Hash {
  param (
    [Parameter(Mandatory=$true)][String] $Path
  )
}

function Compare-ApplyHash {
  param (
    [Parameter(Mandatory=$true)][String] $File,
    [Parameter(Mandatory=$true)][String] $PathHash
  )
  $rt = $true
  $hashFilePath = Get-HashFilePath -File $File -PathHash $PathHash
  If (-Not(Test-Path -Path $hashFilePath)) {
    New-Item -Path $hashFilePath -Force | Out-Null
    $rt = $false
  }
  return $rt
}

function Set-HashSprites {
  # TODO : test if bin output "char.bin" exist else build is required
  param (
    [Parameter(Mandatory=$true)][String] $XMLFile,
    [Parameter(Mandatory=$true)][String] $Path
  )
  if (-Not(Test-Path -Path $XMLFile)) {
    Write-Host "error : $XMLFile not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $Path)) { mkdir -Path $Path }

  Select-Xml -Path $XMLFile -XPath /chardata/scrl/file | ForEach-Object {
    $rt = Compare-ApplyHash -File $_.Node.InnerXML -PathHash $Path
    if ($rt -eq $false) { return $false }
  }
  Select-Xml -Path $XMLFile -XPath /chardata/pict/file | ForEach-Object {
    $rt = Compare-ApplyHash -File $_.Node.InnerXML -PathHash $Path
    if ($rt -eq $false) { return $false }
  }
  Select-Xml -Path $XMLFile -XPath /chardata/sprt/file | ForEach-Object {
    $rt = Compare-ApplyHash -File $_.Node.InnerXML -PathHash $Path
    if ($rt -eq $false) { return $false }
  }
  return $rt
}