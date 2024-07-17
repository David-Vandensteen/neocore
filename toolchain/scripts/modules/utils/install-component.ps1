Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\utils\download.ps1"

function Install-Component {
  param (
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $PathDownload,
    [Parameter(Mandatory=$true)][String] $PathInstall
  )
  $fileName = Split-Path -Path $URL -Leaf
  Logger-Info -Message "GET $fileName"
  Download -URL $URL -Path $PathDownload
  Expand-Archive -Path "$PathDownload\$fileName" -DestinationPath $PathInstall -Force -ErrorAction Stop

  Write-Host "  expanded $filename in $PathInstall" -ForegroundColor Yellow
  Write-Host ""

  Remove-Item -Path "$PathDownload\$fileName" -Force
}