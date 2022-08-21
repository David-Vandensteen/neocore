function Get-Hash {
  param (
    [String] $Path
  )
}

function Set-Hash {
  param (
    [String] $Path
  )
}

function Compare-ApplyHash {
  param (
    [String] $Path
  )
}

function Set-HashSprites {
  param (
    [String] $XMLFile,
    [String] $HashPath
  )
  if (-Not(Test-Path -Path $XMLFile)) {
    Write-Host "error : $XMLFile not found"
    exit 1
  }

  if (-Not(Test-Path -Path $HashPath)) { mkdir -Path $HashPath }

  Select-Xml -Path $XMLFile -XPath /chardata/scrl/file | ForEach-Object { Compare-ApplyHash -FilePath $_.Node.InnerXML }
  Select-Xml -Path $XMLFile -XPath /chardata/pict/file | ForEach-Object { Compare-ApplyHash -FilePath $_.Node.InnerXML }
  Select-Xml -Path $XMLFile -XPath /chardata/sprt/file | ForEach-Object { Compare-ApplyHash -FilePath $_.Node.InnerXML }
}