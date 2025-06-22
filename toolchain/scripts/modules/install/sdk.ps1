function Install-GCC {
  Param(
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $Destination
  )

  $downloadPath = $(Resolve-Path -Path "$($Config.project.buildPath)\spool")
  if (-not $(Test-Path -Path $Destination)) {
    New-Item -Path $Destination -ItemType Directory -Force
    Install-Component -URL $URL -PathDownload $downloadPath -PathInstall $Destination
  }
}

function Install-NeodevHeader {
  $installPath = $(Resolve-Path -Path $Config.project.buildPath)
  $necorePath = $(Resolve-Path -Path $Config.project.neocorePath)
  Write-Host "Installing neodev header files..." -ForegroundColor Yellow
  if (-not (Test-Path -Path $installPath\include)) {
    New-Item -Path $installPath\include -ItemType Directory -Force
  }
  Copy-Item -Path "$necorePath\src-lib\neodev\*" -Destination "$installPath\include\" -Recurse -Force
}

function Install-DATlibHeader {
  $installPath = $(Resolve-Path -Path $Config.project.buildPath)
  $necorePath = $(Resolve-Path -Path $Config.project.neocorePath)
  Write-Host "Installing DATlib header files..." -ForegroundColor Yellow
  if (-not (Test-Path -Path $installPath\include)) {
    New-Item -Path $installPath\include -ItemType Directory -Force
  }
  Copy-Item -Path "$necorePath\src-lib\datlib\*" -Destination "$installPath\include\" -Recurse -Force
}

function Install-System {
  $installPath = $(Resolve-Path -Path $Config.project.buildPath)
  $necorePath = $(Resolve-Path -Path $Config.project.neocorePath)
  Write-Host "Installing system files..." -ForegroundColor Yellow
  if (-not (Test-Path -Path $installPath\system)) {
    New-Item -Path $installPath\system -ItemType Directory -Force
  }
  Copy-Item -Path "$necorePath\src-lib\system\*" -Destination "$installPath\system\" -Recurse -Force
}


function Install-SDK {
  $installPath = $(Resolve-Path -Path $Config.project.buildPath)
  $downloadPath = $(Resolve-Path -Path "$($Config.project.buildPath)\spool")
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
    Install-NeodevHeader
    Install-DATlibHeader
    Install-System
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

  #Install-Component -URL "$($BaseURL)/MinGW-m68k-elf-13.1.0.zip" -PathDownload $downloadPath -PathInstall "$($installPath)\gcc"

  Build-NeocoreLib
  $manifestFile = "$($Config.project.neocorePath)\manifest.xml"
  Copy-Item -Path $manifestFile $installPath -Force -ErrorAction Stop
  Copy-Item -Path "$($Config.project.neocorePath)\manifest.xml" $Config.project.buildPath -Force -ErrorAction Stop
}
