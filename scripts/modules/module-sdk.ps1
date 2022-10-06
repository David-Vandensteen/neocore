Import-Module "..\..\scripts\modules\module-install-component.ps1"

function Install-Neocore {
 pushd ..\..\
 .\build-neocore.bat
 popd
}

function Install-SDK {
  Install-Component -URL "http://azertyvortex.free.fr/download/neocore-bin.zip" -PathDownload "$env:TEMP\neocore" -PathInstall "$env:APPDATA\neocore"
  Install-Component -URL "http://azertyvortex.free.fr/download/neodev-sdk.zip" -PathDownload "$env:TEMP\neocore" -PathInstall "$env:APPDATA\neocore"
  Install-Neocore
}
