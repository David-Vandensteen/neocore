Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\start\download.ps1"

function Install-Component {
  param (
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $PathDownload,
    [Parameter(Mandatory=$true)][String] $PathInstall
  )
  $fileName = Split-Path -Path $URL -Leaf
  Logger-Info -Message "GET $fileName"
  Start-Download -URL $URL -Path $PathDownload
  if (-not($(Test-Path -Path "$PathDownload\$fileName"))) {
    Write-Host "  error : download failed" -ForegroundColor Red
    exit 1
  }
  Expand-Archive -Path "$PathDownload\$fileName" -DestinationPath $PathInstall -Force -ErrorAction Stop

  Write-Host "  expanded $filename in $PathInstall" -ForegroundColor Yellow
  Write-Host ""

  Remove-Item -Path "$PathDownload\$fileName" -Force
}