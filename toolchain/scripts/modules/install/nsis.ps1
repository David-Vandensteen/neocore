function Install-NSIS {
  $installPath = $(Resolve-Path -Path $Config.project.buildPath)
  $downloadPath = $(Resolve-Path -Path "$($Config.project.buildPath)\spool")

  if ($Manifest.manifest.dependencies.nsis.url) {
    Install-Component `
      -URL $Manifest.manifest.dependencies.nsis.url `
      -PathDownload $downloadPath `
      -PathInstall $Manifest.manifest.dependencies.nsis.path
  } else {
    Install-Component -URL "$BaseURL/retro-game-winpacker/nsis-3.08.zip" -PathDownload $downloadPath -PathInstall "$installPath\tools"
  }
}
