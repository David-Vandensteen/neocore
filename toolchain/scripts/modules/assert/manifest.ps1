function Assert-Manifest {
  param (
    [Parameter(Mandatory = $true)]
    [ValidateScript({Test-Path $_})]
    [string]$ManifestSource,

    [Parameter(Mandatory = $true)]
    [ValidateScript({Test-Path $_})]
    [string]$ManifestCache
)
  if ($Rule -ne "clean:build") {
    Write-Host "Assert manifest" -ForegroundColor Yellow
    if ((Test-Path -Path "$($Config.project.buildPath)\manifest.xml") -eq $false) {
      if (Test-Path -Path $Config.project.buildPath) {
        Write-Host "manifest not found : remove build cache" -ForegroundColor Blue
        Write-Host "Please, remove $(Resolve-TemplatePath -Path $Config.project.buildPath) to rebuild neocore"
        Write-Host "You can use mak clean:build"
        exit 1
      }
    }
    Write-Host "source : $ManifestSource"
    Write-Host "cache : $ManifestCache"
    if ((Compare-FileHash -SrcFile $ManifestSource -DestFile $ManifestCache) -eq $false) {
      Write-Host "manifest has changed : remove build cache" -ForegroundColor Blue
      Write-Host "Please, remove $(Resolve-TemplatePath -Path $Config.project.buildPath) to rebuild neocore"
      Write-Host "You can use mak clean:build"
      exit 1
    }

    Assert-ManifestDependencies
    Write-Host "manifest is compliant" -ForegroundColor Green
  }
}
