Import-Module "..\..\scripts\modules\module-hash.ps1"
Import-Module "..\..\scripts\modules\module-emulators.ps1"

function Remove-Project {
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

function Write-Cue {

}

function Write-Program {
  param (
    [Parameter(Mandatory=$true)][String] $MakeFile,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $ProjectName
  )
  Write-Host "make rule"
  $env:PROJECT = $ProjectName
  $env:NEODEV = $PathNeoDev
  $env:FILEPRG = $PRGFile
  Write-Host "env project : $env:project"
  Write-Host "env neodev : $env:neodev"
  Write-Host "env fileprg : $env:fileprg"
  & make -f $MakeFile
}

function Write-ISO {

}

function Write-Zip {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName
  )
}

function Write-Sprite {
  param (
    [Parameter(Mandatory=$true)][String] $PathHash,
    [Parameter(Mandatory=$true)][String] $XMLFile
  )
  Write-Host "sprite rule"
  $rt = Set-HashSprites -XMLFile $XMLFile -Path $PathHash
  If ($rt -eq $true) {
    Write-Host "debug : build sprite is not required" -ForegroundColor Yellow
  }
  if ($rt -eq $false) {
    Write-Host "debug : build sprite is required" -ForegroundColor Yellow
    & BuildChar.exe $XMLFile
  }
}