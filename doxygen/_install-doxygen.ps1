function Download {
  param (
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $Path
  )
  Write-Host "Download - $URL $Path"
  $fileName = Split-Path $URL -leaf

  $start_time = Get-Date
  Invoke-WebRequest -URI $URL -Outfile $Path"\"$fileName
  Write-Host "Time taken - $((Get-Date).Subtract($start_time).Seconds) second(s)"
}

function Install-Component {
  param (
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $PathDownload,
    [Parameter(Mandatory=$true)][String] $PathInstall
  )
  $fileName = Split-Path -Path $URL -Leaf
  Write-Host "GET $fileName"
  Download -URL $URL -Path $PathDownload
  Expand-Archive -Path "$PathDownload\$fileName" -DestinationPath $PathInstall -Force -ErrorAction Stop

  Write-Host "  expanded $filename in $PathInstall" -ForegroundColor Yellow
  Write-Host ""

  Remove-Item -Path "$PathDownload\$fileName" -Force
}


Install-Component -URL "http://azertyvortex.free.fr/download/doxygen.zip" -PathDownload ..\build\spool -PathInstall "..\build\doxygen"
