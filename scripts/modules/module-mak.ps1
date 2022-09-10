Import-Module "..\..\scripts\modules\module-hash.ps1"
Import-Module "..\..\scripts\modules\module-emulators.ps1"
Import-Module "..\..\scripts\modules\module-iso.ps1"

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
  Write-Host "debug : env project - $env:project" -ForegroundColor Yellow
  Write-Host "debug : neodev - $env:neodev" -ForegroundColor Yellow
  Write-Host "debug : fileprg - $env:fileprg" -ForegroundColor Yellow
  & make -f $MakeFile
}

function Write-ISO {
  param (
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $SpriteFile,
    [Parameter(Mandatory=$true)][String] $PathISOBuildFolder,
    [Parameter(Mandatory=$true)][String] $PathCDTemplate,
    #[Parameter(Mandatory=$true)][String] $MKISOFSBin,
    [Parameter(Mandatory=$true)][String] $PathHash
  )
  if (-Not(Test-Path -Path $PathHash)) { mkdir -Path $PathHash }
  if (-Not(Test-Path -Path $PathISOBuildFolder)) { mkdir -Path $PathISOBuildFolder }
  if (-Not(Test-Path -Path $PathCDTemplate)) {
    Write-Host "error : $PathCDTemplate not found" -ForegroundColor Red
    exit 1
  }
  <#
  if (-Not(Test-Path -Path $MKISOFSBin)) {
    Write-Host "error : $MKISOFSBin not found" -ForegroundColor Red
    exit 1
  }
  #>
  if (-Not(Test-Path -Path $PRGFile)) {
    Write-Host "error : $PRGFile not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $SpriteFile)) {
    Write-Host "error : $SpriteFile not found" -ForegroundColor Red
    exit 1
  }

  $rt = Compare-ApplyHash -File $PRGFile -PathHash $PathHash
  if ($rt -eq $true) {
    Write-Host "debug : build iso is not required" -ForegroundColor Yellow
  }
  if ($rt -eq $false) {
    Write-Host "debug : build iso is not required" -ForegroundColor Yellow
  }
  Copy-Item -Path "$PathCDTemplate\*" -Destination $PathISOBuildFolder -Recurse -Force
  Copy-Item -Path $PRGFile -Destination "$PathISOBuildFolder\DEMO.PRG" -Force
  Copy-Item -Path $SpriteFile -Destination "$PathISOBuildFolder\DEMO.SPR" -Force

  #& $MKISOFSBin -o "$PathOutFolder\$ProjectName.iso"
  New-IsoFile -Source $PathISOBuildFolder -Path $OutputFile -Force
}

function Write-Sprite {
  param (
    [Parameter(Mandatory=$true)][String] $Format,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $PathHash,
    [Parameter(Mandatory=$true)][String] $XMLFile
  )
  Write-Host "sprite rule"
  $rt = Set-HashSprites -XMLFile $XMLFile -Path $PathHash
  if ($rt -eq $true) {
    Write-Host "debug : build sprite is not required" -ForegroundColor Yellow
  }
  if ($rt -eq $false) {
    Write-Host "debug : build sprite is required" -ForegroundColor Yellow
    & BuildChar.exe $XMLFile
    & CharSplit.exe char.bin $Format $OutputFile
    Remove-Item -Path char.bin -Force
  }
}