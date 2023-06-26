Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-download.ps1"

function Install-Component {
  param (
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $PathDownload,
    [Parameter(Mandatory=$true)][String] $PathInstall
  )
  $fileName = Split-Path -Path $URL -Leaf
  Logger-Info -Message "GET $fileName"
  Download -URL $URL -Path $PathDownload
  Expand-Archive -Path "$PathDownload\$fileName" -DestinationPath $PathInstall -Force
  Remove-Item -Path "$PathDownload\$fileName" -Force
}