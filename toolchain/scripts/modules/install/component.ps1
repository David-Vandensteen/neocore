Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\start\download.ps1"

function Install-Component {
  param (
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $PathDownload,
    [Parameter(Mandatory=$true)][String] $PathInstall
  )

  if (-not($(Test-Path -Path $PathInstall))) {
    Write-Host "  create $PathInstall" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $PathInstall
  }

  $fileName = Split-Path -Path $URL -Leaf
  $pathDownload = Resolve-Path -Path $PathDownload
  $pathInstall = Resolve-Path -Path $PathInstall

  Write-Host "GET $fileName" -ForegroundColor Blue
  Start-Download -URL $URL -Path $pathDownload

  if (-not($(Test-Path -Path "$pathDownload\$fileName"))) {
    Write-Host "  error : download failed" -ForegroundColor Red
    exit 1
  }

  Expand-Archive -Path "$pathDownload\$fileName" -DestinationPath $pathInstall -Force -ErrorAction Stop

  Write-Host "  expanded $filename $pathInstall" -ForegroundColor Yellow
  Write-Host ""

  Remove-Item -Path "$pathDownload\$fileName" -Force
}