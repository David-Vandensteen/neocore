function Assert-Config {
  param ([Parameter(Mandatory=$true)][xml] $Config)
  function Check-Manifest {
    param (
      [Parameter(Mandatory = $true)]
      [ValidateScript({Test-Path $_})]
      [string]$ManifestSource,

      [Parameter(Mandatory = $true)]
      [ValidateScript({Test-Path $_})]
      [string]$ManifestCache
  )
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\compare\filehash.ps1"
    Write-Host "check manifest" -ForegroundColor Yellow
    Write-Host "source : $ManifestSource"
    Write-Host "cache : $ManifestCache"
    if ((Compare-FileHash -SrcFile $ManifestSource -DestFile $ManifestCache) -eq $false) {
      return $false
    }
    return $true
  }

  function Check-XMLError {
    param ([Parameter(Mandatory=$true)][String] $Entry)
    Write-Host "error : xml $Entry not found" -ForegroundColor Red
    exit 1
  }

  function Check-PathError {
    param ([Parameter(Mandatory=$true)][String] $Path)
    Write-Host "error : $Path not found" -ForegroundColor Red
    exit 1
  }

  function Check-XML {
    if (-Not($Config.project.name)) { Check-XMLError -Entry "project.name" }
    if (-Not($Config.project.version)) { Check-XMLError -Entry "project.version" }
    if (-Not($Config.project.makefile)) { Check-XMLError -Entry "project.makefile" }
    if (-Not($Config.project.neocorePath)) { Check-XMLError -Entry "project.neocorePath" }
    if (-Not($Config.project.buildPath)) { Check-XMLError -Entry "project.buildPath" }
    if (-Not($Config.project.distPath)) { Check-XMLError -Entry "project.distPath" }
    if (-Not($Config.project.emulator)) { Check-XMLError -Entry "project.emulator" }
    if (-Not($Config.project.compiler)) { Check-XMLError -Entry "project.compiler" }
    if (-Not($Config.project.compiler.path)) { Check-XMLError -Entry "project.compiler.path" }
    if (-Not($Config.project.compiler.includePath)) { Check-XMLError -Entry "project.compiler.includePath" }
    if (-Not($Config.project.compiler.libraryPath)) { Check-XMLError -Entry "project.compiler.libraryPath" }
    if (-Not($Config.project.compiler.systemFile)) { Check-XMLError -Entry "project.compiler.systemFile" }

    if ($Config.project.sound) {
      if ($Config.project.sound.cdda) {
        if (-Not($Config.project.sound.cdda.dist.iso.format)) { Check-XMLError -Entry "project.sound.cdda.dist.iso.format" }
        if (-Not($Config.project.sound.cdda.tracks)) { Check-XMLError -Entry "project.sound.cdda.tracks" }
      }
    }
  }

  function Check-Path {
    if ((Test-Path -Path $Config.project.makefile) -eq $false) { Check-PathError -Path $Config.project.makefile }
    if ((Test-Path -Path $Config.project.neocorePath) -eq $false) { Check-PathError -Path $Config.project.neocorePath }
  }
  Write-Host "check config" -ForegroundColor Yellow
  Check-XML
  Check-Path
  if ((Test-Path -Path "$($Config.project.buildPath)\manifest.xml") -eq $false) {
    if (Test-Path -Path $Config.project.buildPath) {
      Write-Host "manifest not found : remove build cache" -ForegroundColor Blue
      Write-Host "Please, remove $(Resolve-Path -Path $Config.project.buildPath) to rebuild neocore"
      exit 1
    }
  }

  if (Test-Path -Path "$($Config.project.buildPath)\manifest.xml") {
    $checkManifest = Check-Manifest `
      -ManifestSource "$($Config.project.neocorePath)\manifest.xml" `
      -ManifestCache "$($Config.project.buildPath)\manifest.xml"

    if ($checkManifest -eq $false) {
      Write-Host "manifest has changed : remove build cache" -ForegroundColor Blue
      Write-Host "Please, remove $(Resolve-Path -Path $Config.project.buildPath) to rebuild neocore"
      exit 1
    }
  }

  Write-Host "config is compliant" -ForegroundColor Green
}
