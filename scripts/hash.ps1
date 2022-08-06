Param(
  [String] $file,
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
    New-Item -Path $hashFilePath -Force | Out-Null
    $global:exitCode = 1
  }
}

function Main {
  If ((Test-Path -Path $hashPath) -eq $false) { mkdir $hashPath | Out-Null }
  If ((Test-Path -Path $file) -eq $false) {
    Exit 2
  }
  CompareAndApply $file
}

Main
Exit $global:exitCode
