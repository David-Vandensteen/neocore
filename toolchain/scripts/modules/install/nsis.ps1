Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\install\component.ps1"

function Install-NSIS {
  $installPath = $(Resolve-Path $buildConfig.pathNeocore)
  $downloadPath = $(Resolve-Path $buildConfig.pathSpool)

  if ($Manifest.manifest.dependencies.nsis.url) {
    Install-Component `
      -URL $Manifest.manifest.dependencies.nsis.url `
      -PathDownload $downloadPath `
      -PathInstall $Manifest.manifest.dependencies.nsis.path
  } else {
    Install-Component -URL "$($buildConfig.baseURL)/retro-game-winpacker/nsis-3.08.zip" -PathDownload $downloadPath -PathInstall "$installPath\tools"
  }
}
