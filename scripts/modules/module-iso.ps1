Import-Module "..\..\scripts\modules\module-download.ps1"

function Install-CDTemplate {
  param (
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $PathDonwload,
    [Parameter(Mandatory=$true)][String] $PathInstall
  )
  Download -URL $URL -Path $PathDonwload
  Expand-Archive -Path "$PathDonwload\neobuild-cd_template.zip" -DestinationPath $PathInstall
  Remove-Item -Path "$PathDonwload\neobuild-cd_template.zip" -Force
}

function Write-ISO {
  param (
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $SpriteFile,
    [Parameter(Mandatory=$true)][String] $PathISOBuildFolder,
    [Parameter(Mandatory=$true)][String] $PathCDTemplate
  )
  if ((Test-Path -Path $PathCDTemplate) -eq $false) {
    Install-CDTemplate -URL "http://azertyvortex.free.fr/download/neobuild-cd_template.zip" -PathDonwload "$env:TEMP\neocore" -PathInstall "$env:APPDATA\neocore"
  }
  Write-Host "compiling ISO" -ForegroundColor Yellow
  if (Test-Path -Path $PathISOBuildFolder) { Remove-Item $PathISOBuildFolder -Recurse -Force }
  if (-Not(Test-Path -Path $PathISOBuildFolder)) { mkdir -Path $PathISOBuildFolder | Out-Null }
  if (-Not(Test-Path -Path $PathCDTemplate)) {
    Write-Host "error - $PathCDTemplate not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $PRGFile)) {
    Write-Host "error - $PRGFile not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $SpriteFile)) {
    Write-Host "error - $SpriteFile not found" -ForegroundColor Red
    exit 1
  }
  Copy-Item -Path "$PathCDTemplate\*" -Destination $PathISOBuildFolder -Recurse -Force
  Copy-Item -Path $PRGFile -Destination "$PathISOBuildFolder\DEMO.PRG" -Force
  Copy-Item -Path $SpriteFile -Destination "$PathISOBuildFolder\DEMO.SPR" -Force

  & mkisofs.exe -o $OutputFile -pad $PathISOBuildFolder

  if ((Test-Path -Path $OutputFile) -eq $true) {
    Write-Host "builded ISO is available to $OutputFile" -ForegroundColor Green
    Write-Host ""
  } else {
    Write-Host "error - $OutputFile was not generated" -ForegroundColor Red
    exit 1
  }
}
