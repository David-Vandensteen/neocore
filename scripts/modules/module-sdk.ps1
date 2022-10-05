Import-Module "..\..\scripts\modules\module-download.ps1"

function Install-Bin {
  param (
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $PathDownload,
    [Parameter(Mandatory=$true)][String] $PathInstall
  )
  Download -URL $URL -Path $PathDownload
  Expand-Archive -Path "$PathDownload\neocore-bin.zip" -DestinationPath $PathInstall -Force
  Remove-Item -Path "$PathDownload\neocore-bin.zip" -Force
}

function Install-Neodev {
  param (
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $PathDownload,
    [Parameter(Mandatory=$true)][String] $PathInstall
  )
  Download -URL $URL -Path $PathDownload
  Expand-Archive -Path "$PathDownload\neodev-sdk.zip" -DestinationPath $PathInstall -Force
  Remove-Item -Path "$PathDownload\neodev-sdk.zip" -Force
}

function Install-Neocore {
 pushd ..\..\
 Start-Process -File .\build-neocore.bat -Wait
 #& build-neocore.bat
 popd
}

function Install-SDK {
  Install-Bin -URL "http://azertyvortex.free.fr/download/neocore-bin.zip" -PathDownload "$env:TEMP\neocore" -PathInstall "$env:APPDATA\neocore"
  Install-Neodev -URL "http://azertyvortex.free.fr/download/neodev-sdk.zip" -PathDownload "$env:TEMP\neocore" -PathInstall "$env:APPDATA\neocore"
  Install-Neocore
}
