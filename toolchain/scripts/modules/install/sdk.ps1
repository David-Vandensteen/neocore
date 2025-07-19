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

  if ($Manifest.manifest.dependencies) { # TODO : make it mandatory in neocore v3
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
      -URL $Manifest.manifest.dependencies.animator.url `
      -PathDownload $downloadPath `
      -PathInstall $Manifest.manifest.dependencies.animator.path
    Install-Component `
      -URL $Manifest.manifest.dependencies.framer.url `
      -PathDownload $downloadPath `
      -PathInstall $Manifest.manifest.dependencies.framer.path
    Install-Component `
      -URL $Manifest.manifest.dependencies.neoTools.url `
      -PathDownload $downloadPath `
      -PathInstall $Manifest.manifest.dependencies.neoTools.path
    Install-Component `
      -URL $Manifest.manifest.dependencies.buildChar.url `
      -PathDownload $downloadPath `
      -PathInstall $Manifest.manifest.dependencies.buildChar.path
    Install-Component `
      -URL $Manifest.manifest.dependencies.charSplit.url `
      -PathDownload $downloadPath `
      -PathInstall $Manifest.manifest.dependencies.charSplit.path
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
  } else {
    Install-Component -URL "$($BaseURL)/neocore-bin.zip" -PathDownload $downloadPath -PathInstall $installPath
    Install-Component -URL "$($BaseURL)/msys2-runtime.zip" -PathDownload $downloadPath -PathInstall "$installPath\bin"
    Install-Component -URL "$($BaseURL)/find-command.zip" -PathDownload $downloadPath -PathInstall "$installPath\bin"
    Install-Component -URL "$($BaseURL)/tr-command.zip" -PathDownload $downloadPath -PathInstall "$installPath\bin"
    Install-Component -URL "$($BaseURL)/DATimage.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\tools"
    Install-Component -URL "$($BaseURL)/NGFX_SoundBuilder_210808.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\tools"
    Install-Component -URL "$($BaseURL)/animator.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\tools"
    Install-Component -URL "$($BaseURL)/framer.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\tools"
    Install-Component -URL "$($BaseURL)/NeoTools.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\bin"
    Install-Component -URL "$($BaseURL)/buildchar.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\bin"
    Install-Component -URL "$($BaseURL)/charSplit.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\bin"
    Install-Component -URL "$($BaseURL)/chdman.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\bin"
    Install-Component -URL "$($BaseURL)/neodev-sdk.zip" -PathDownload $downloadPath -PathInstall $installPath
    Install-Component -URL "$($BaseURL)/neodev-lib.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\lib"
    Install-Component -URL "$($BaseURL)/libDATlib.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\lib"
    Install-Component -URL "$($BaseURL)/neodev-header.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\include"
    Install-Component -URL "$($BaseURL)/DATlib-header.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\include"
    Install-Component -URL "$($BaseURL)/system.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\system"

    Install-GCC -URL "$($BaseURL)/gcc-2.95.2.zip" -Destination "$($installPath)\gcc\gcc-2.95.2"
  }

  Build-NeocoreLib
  $projectNeocorePath = Resolve-TemplatePath -Path $Config.project.neocorePath
  $manifestFile = "$projectNeocorePath\manifest.xml"

  Write-Host "Copying $manifestFile to $installPath" -ForegroundColor Cyan
  Copy-Item -Path $manifestFile $installPath -Force -ErrorAction Stop

  # TODO : refactor this
  # Write-Host "Copying $manifestFile to $projectBuildPath" -ForegroundColor Cyan
  # Copy-Item -Path "$($Config.project.neocorePath)\manifest.xml" $Config.project.buildPath -Force -ErrorAction Stop
}
