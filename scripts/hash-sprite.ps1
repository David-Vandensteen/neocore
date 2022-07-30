Param(
  [String] $xmlFile,
  [String] $hashPath
)

$global:exitCode = 0

function GetHashFilePath($file) {
  $name = (Get-ChildItem $file).Name
  $hash = (Get-FileHash $file).Hash
  return [String] "$hashPath\$name-$hash.hash"
}

function CompareAndApply($file) {
  $hashFilePath = GetHashFilePath $file
  If (-Not (Test-Path -Path $hashFilePath)) {
    New-Item -Path $hashFilePath -Force
    $global:exitCode = 1
  }
}

function Parse {
  Select-Xml -Path $xmlFile -XPath /chardata/scrl/file | ForEach-Object { CompareAndApply $_.Node.InnerXML }
  Select-Xml -Path $xmlFile -XPath /chardata/pict/file | ForEach-Object { CompareAndApply $_.Node.InnerXML }
  Select-Xml -Path $xmlFile -XPath /chardata/sprt/file | ForEach-Object { CompareAndApply $_.Node.InnerXML }
}

function Main {
  If ((Test-Path -Path $hashPath) -eq $false) { mkdir $hashPath }
  If ((Test-Path -Path $xmlFile) -eq $false) {
    Write-Host "$xmlFile not found"
    Exit 2
  }
  Parse
}

Main
Exit $global:exitCode
