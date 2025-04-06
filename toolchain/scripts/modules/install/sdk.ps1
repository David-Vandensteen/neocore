Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\install\component.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\build\neocore-lib.ps1"

function Install-GCC {
  Param(
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $Destination
  )

  $downloadPath = $(Resolve-Path $buildConfig.pathSpool)
  if (-not $(Test-Path -Path $Destination)) {
    New-Item -Path $Destination -ItemType Directory -Force
    Install-Component -URL $URL -PathDownload $downloadPath -PathInstall $Destination
  }
}

function Install-SDK {
  $installPath = $(Resolve-Path $buildConfig.pathNeocore)
  $downloadPath = $(Resolve-Path $buildConfig.pathSpool)
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
      -URL $Manifest.manifest.dependencies.neodevHeader.url `
      -PathDownload $downloadPath `
      -PathInstall $Manifest.manifest.dependencies.neodevHeader.path
    Install-Component `
      -URL $Manifest.manifest.dependencies.datLibHeader.url `
      -PathDownload $downloadPath `
      -PathInstall $Manifest.manifest.dependencies.datLibHeader.path
    Install-Component `
      -URL $Manifest.manifest.dependencies.system.url `
      -PathDownload $downloadPath `
      -PathInstall $Manifest.manifest.dependencies.system.path
    Install-Component `
      -URL $Manifest.manifest.dependencies.gcc.url `
      -PathDownload $downloadPath `
      -PathInstall $Manifest.manifest.dependencies.gcc.path
  } else {
    Install-Component -URL "$($buildConfig.baseURL)/neocore-bin.zip" -PathDownload $downloadPath -PathInstall $installPath
    Install-Component -URL "$($buildConfig.baseURL)/msys2-runtime.zip" -PathDownload $downloadPath -PathInstall "$installPath\bin"
    Install-Component -URL "$($buildConfig.baseURL)/find-command.zip" -PathDownload $downloadPath -PathInstall "$installPath\bin"
    Install-Component -URL "$($buildConfig.baseURL)/tr-command.zip" -PathDownload $downloadPath -PathInstall "$installPath\bin"
    Install-Component -URL "$($buildConfig.baseURL)/DATimage.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\tools"
    Install-Component -URL "$($buildConfig.baseURL)/NGFX_SoundBuilder_210808.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\tools"
    Install-Component -URL "$($buildConfig.baseURL)/animator.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\tools"
    Install-Component -URL "$($buildConfig.baseURL)/framer.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\tools"
    Install-Component -URL "$($buildConfig.baseURL)/NeoTools.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\bin"
    Install-Component -URL "$($buildConfig.baseURL)/buildchar.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\bin"
    Install-Component -URL "$($buildConfig.baseURL)/charSplit.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\bin"
    Install-Component -URL "$($buildConfig.baseURL)/chdman.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\bin"
    Install-Component -URL "$($buildConfig.baseURL)/neodev-sdk.zip" -PathDownload $downloadPath -PathInstall $installPath
    Install-Component -URL "$($buildConfig.baseURL)/neodev-lib.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\lib"
    Install-Component -URL "$($buildConfig.baseURL)/libDATlib.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\lib"
    Install-Component -URL "$($buildConfig.baseURL)/neodev-header.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\include"
    Install-Component -URL "$($buildConfig.baseURL)/DATlib-header.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\include"
    Install-Component -URL "$($buildConfig.baseURL)/system.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\system"

    Install-GCC -URL "$($buildConfig.baseURL)/gcc-2.95.2.zip" -Destination "$($installPath)\gcc\gcc-2.95.2"
  }

  #Install-Component -URL "$($buildConfig.baseURL)/MinGW-m68k-elf-13.1.0.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\gcc"

  Build-NeocoreLib
  $manifestFile = "$($Config.project.neocorePath)\manifest.xml"
  Copy-Item -Path $manifestFile $installPath -Force -ErrorAction Stop
  Copy-Item -Path "$($Config.project.neocorePath)\manifest.xml" $buildConfig.pathNeocore -Force -ErrorAction Stop
}
