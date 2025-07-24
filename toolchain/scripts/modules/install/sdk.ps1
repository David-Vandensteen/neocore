function Install-GCC {
  Param(
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $Destination
  )

  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $downloadPath = $(Resolve-TemplatePath -Path "$projectBuildPath\spool")
  if (-not $(Test-Path -Path $Destination)) {
    New-Item -Path $Destination -ItemType Directory -Force
    Install-Component -URL $URL -PathDownload $downloadPath -PathInstall $Destination
  }
}

function Install-SDK {
  $installPath = $(Resolve-TemplatePath -Path $Config.project.buildPath)
  $downloadPath = $(Resolve-TemplatePath -Path "$($Config.project.buildPath)\spool")
  $buildConfig

  Install-Component `
      -URL $Manifest.manifest.dependencies.neocoreBin.url `
      -PathDownload $downloadPath `
      -PathInstall $Manifest.manifest.dependencies.neocoreBin.path
  Install-Component `
    -URL $Manifest.manifest.dependencies.msys2Runtime.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.msys2Runtime.path
  Install-Component `
    -URL $Manifest.manifest.dependencies.findCommand.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.findCommand.path
  Install-Component `
    -URL $Manifest.manifest.dependencies.trCommand.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.trCommand.path
  Install-Component `
    -URL $Manifest.manifest.dependencies.datImage.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.datImage.path
  Install-Component `
    -URL $Manifest.manifest.dependencies.ngfxSoundBuilder.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.ngfxSoundBuilder.path
  Install-Component `
    -URL $Manifest.manifest.dependencies.datAnimatorFramer.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.datAnimatorFramer.path
  Install-Component `
    -URL $Manifest.manifest.dependencies.datBuildCharCharSplit.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.datBuildCharCharSplit.path
  Install-Component `
    -URL $Manifest.manifest.dependencies.chdman.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.chdman.path
  Install-Component `
    -URL $Manifest.manifest.dependencies.neodevSDK.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.neodevSDK.path
  Install-Component `
    -URL $Manifest.manifest.dependencies.neodevLib.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.neodevLib.path
  Install-Component `
    -URL $Manifest.manifest.dependencies.datLib.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.datLib.path
  Install-Component `
    -URL $Manifest.manifest.dependencies.systemFont.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.systemFont.path
  Install-Component `
    -URL $Manifest.manifest.dependencies.gcc.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.gcc.path

  Build-NeocoreLib
  $projectNeocorePath = Resolve-TemplatePath -Path $Config.project.neocorePath
  $manifestFile = "$projectNeocorePath\manifest.xml"

  Write-Host "Copying $manifestFile to $installPath" -ForegroundColor Cyan
  Copy-Item -Path $manifestFile $installPath -Force -ErrorAction Stop
}
