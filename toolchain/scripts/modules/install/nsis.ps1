Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\install\component.ps1"

function Install-NSIS {
  $installPath = $(Resolve-Path $buildConfig.pathNeocore)
  $downloadPath = $(Resolve-Path $buildConfig.pathSpool)

  Install-Component -URL "$($buildConfig.baseURL)/retro-game-winpacker/nsis-3.08.zip" -PathDownload $downloadPath -PathInstall "$installPath\tools"
}
