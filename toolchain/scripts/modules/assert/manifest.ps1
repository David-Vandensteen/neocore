Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\compare\filehash.ps1"

function Assert-Manifest {
  param (
    [Parameter(Mandatory = $true)]
    [ValidateScript({Test-Path $_})]
    [string]$ManifestSource,

    [Parameter(Mandatory = $true)]
    [ValidateScript({Test-Path $_})]
    [string]$ManifestCache
)
  Write-Host "assert manifest" -ForegroundColor Yellow
  if ((Test-Path -Path "$($Config.project.buildPath)\manifest.xml") -eq $false) {
    if (Test-Path -Path $Config.project.buildPath) {
      Write-Host "manifest not found : remove build cache" -ForegroundColor Blue
      Write-Host "Please, remove $(Resolve-Path -Path $Config.project.buildPath) to rebuild neocore"
      exit 1
    }
  }
  Write-Host "source : $ManifestSource"
  Write-Host "cache : $ManifestCache"
  if ((Compare-FileHash -SrcFile $ManifestSource -DestFile $ManifestCache) -eq $false) {
    Write-Host "manifest has changed : remove build cache" -ForegroundColor Blue
    Write-Host "Please, remove $(Resolve-Path -Path $Config.project.buildPath) to rebuild neocore"
    exit 1
  }
  Write-Host "manifest is compliant" -ForegroundColor Green
}
