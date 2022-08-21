Import-Module "..\..\scripts\module-hash.ps1"
Import-Module "..\..\scripts\module-emulators.ps1"

function Make-Clean {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName
  )
  Write-Host "Clean $ProjectName"
  Write-Host "Remove $env:TEMP\neocore\$ProjectName"
  Stop-Emulators
  if (Test-Path -Path $env:TEMP\neocore\$ProjectName) { Get-ChildItem -Path $env:TEMP\neocore\$ProjectName -Recurse | Remove-Item -force -recurse }
  if (Test-Path -Path $env:TEMP\neocore\$ProjectName) { Remove-Item $env:TEMP\neocore\$ProjectName -Force }
}

function Set-EnvPath {
  param (
    [Parameter(Mandatory=$true)][String] $PathNeoDevBin,
    [Parameter(Mandatory=$true)][String] $PathNeocoreBin
  )
  $env:path = "$PathNeoDevBin;$PathNeocoreBin;$env:windir\System32;$env:windir\System32\WindowsPowerShell\v1.0\"
  Write-Host "Env Path: $env:path"
}

function Make-Cue {

}

function Make-Program {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $PathBuild
  )
  Write-Host "make rule"
  $env:project = $ProjectName
  $env:neodev = $PathNeoDev
  $env:neobuildtemp = $PathBuild

  & make -f ..\Makefile
}

function Make-ISO {

}

function Make-Zip {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName
  )
}

function Make-Sprite {
  param (
    [Parameter(Mandatory=$true)][String] $HashPath,
    [Parameter(Mandatory=$true)][String] $XMLFile
  )
  Write-Host "sprite rule"
  Set-HashSprites -XMLFile $XMLFile -HashPath "$HashPath\hash"
  & BuildChar.exe "chardata.xml"
}