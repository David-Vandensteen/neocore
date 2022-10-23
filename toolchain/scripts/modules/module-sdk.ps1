Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-install-component.ps1"

function Install-Neocore {
 #pushd $PATH_TOOLCHAIN\..\src-lib
 pushd "$($buildConfig.pathToolchain)\..\src-lib"
 .\build-neocore.bat
 if ($LASTEXITCODE -ne 0) {
  popd
  Logger-Error -Message  "lib neocore was not builded"
  exit $LASTEXITCODE
 }
 popd
}

function Install-SDK {
  Install-Component -URL "$($buildConfig.baseURL)/neocore-bin.zip" -PathDownload $buildConfig.pathSpool -PathInstall $buildConfig.pathNeocore
  Install-Component -URL "$($buildConfig.baseURL)/neodev-sdk.zip" -PathDownload $buildConfig.pathSpool -PathInstall $buildConfig.pathNeocore
  Install-Neocore
}
