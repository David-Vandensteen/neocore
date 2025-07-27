function Install-GCC {
  Param(
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $Destination
  )

  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $downloadPath = $(Resolve-TemplatePath -Path "$projectBuildPath\spool")
  if (-not $(Test-Path -Path $Destination)) {
    New-Item -Path $Destination -ItemType Directory -Force
    if (-not (Install-Component -URL $URL -PathDownload $downloadPath -PathInstall $Destination)) {
      Write-Host "Failed to install component from $URL" -ForegroundColor Red
      return $false
    }
  }
}

function Install-SDK {
  $installPath = $(Resolve-TemplatePath -Path $Config.project.buildPath)
  $downloadPath = $(Resolve-TemplatePath -Path "$($Config.project.buildPath)\spool")
  $buildConfig

  if (-not (Install-Component `
      -URL $Manifest.manifest.dependencies.neocoreBin.url `
      -PathDownload $downloadPath `
      -PathInstall $Manifest.manifest.dependencies.neocoreBin.path)) {
    Write-Host "Failed to install neocoreBin component" -ForegroundColor Red
    return $false
  }
  if (-not (Install-Component `
    -URL $Manifest.manifest.dependencies.msys2Runtime.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.msys2Runtime.path)) {
    Write-Host "Failed to install msys2Runtime component" -ForegroundColor Red
    return $false
  }
  if (-not (Install-Component `
    -URL $Manifest.manifest.dependencies.findCommand.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.findCommand.path)) {
    Write-Host "Failed to install findCommand component" -ForegroundColor Red
    return $false
  }
  if (-not (Install-Component `
    -URL $Manifest.manifest.dependencies.trCommand.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.trCommand.path)) {
    Write-Host "Failed to install trCommand component" -ForegroundColor Red
    return $false
  }
  if (-not (Install-Component `
    -URL $Manifest.manifest.dependencies.datImage.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.datImage.path)) {
    Write-Host "Failed to install datImage component" -ForegroundColor Red
    return $false
  }
  if (-not (Install-Component `
    -URL $Manifest.manifest.dependencies.ngfxSoundBuilder.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.ngfxSoundBuilder.path)) {
    Write-Host "Failed to install ngfxSoundBuilder component" -ForegroundColor Red
    return $false
  }
  if (-not (Install-Component `
    -URL $Manifest.manifest.dependencies.datAnimatorFramer.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.datAnimatorFramer.path)) {
    Write-Host "Failed to install datAnimatorFramer component" -ForegroundColor Red
    return $false
  }
  if (-not (Install-Component `
    -URL $Manifest.manifest.dependencies.datBuildCharCharSplit.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.datBuildCharCharSplit.path)) {
    Write-Host "Failed to install datBuildCharCharSplit component" -ForegroundColor Red
    return $false
  }
  if (-not (Install-Component `
    -URL $Manifest.manifest.dependencies.chdman.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.chdman.path)) {
    Write-Host "Failed to install chdman component" -ForegroundColor Red
    return $false
  }
  if (-not (Install-Component `
    -URL $Manifest.manifest.dependencies.neodevLib.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.neodevLib.path)) {
    Write-Host "Failed to install neodevLib component" -ForegroundColor Red
    return $false
  }
  if (-not (Install-Component `
    -URL $Manifest.manifest.dependencies.datLib.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.datLib.path)) {
    Write-Host "Failed to install datLib component" -ForegroundColor Red
    return $false
  }
  if (-not (Install-Component `
    -URL $Manifest.manifest.dependencies.systemFont.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.systemFont.path)) {
    Write-Host "Failed to install systemFont component" -ForegroundColor Red
    return $false
  }
  if (-not (Install-Component `
    -URL $Manifest.manifest.dependencies.gcc.url `
    -PathDownload $downloadPath `
    -PathInstall $Manifest.manifest.dependencies.gcc.path)) {
    Write-Host "Failed to install gcc component" -ForegroundColor Red
    return $false
  }

  if (-not (Build-NeocoreLib)) {
    Write-Host "Failed to build Neocore library" -ForegroundColor Red
    return $false
  }
  $projectNeocorePath = Resolve-TemplatePath -Path $Config.project.neocorePath
  $manifestFile = "$projectNeocorePath\manifest.xml"

  Write-Host "Copying $manifestFile to $installPath" -ForegroundColor Cyan
  try {
    Copy-Item -Path $manifestFile $installPath -Force -ErrorAction Stop
    Write-Host "SDK installation completed successfully" -ForegroundColor Green
    return $true
  } catch {
    Write-Host "Failed to copy manifest file: $($_.Exception.Message)" -ForegroundColor Red
    return $false
  }
}
