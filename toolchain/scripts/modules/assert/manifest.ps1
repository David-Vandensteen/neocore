function Assert-Manifest {
  Write-Host "Assert manifest" -ForegroundColor Yellow

  if ($Rule -ne "clean:build") {
    $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
    if ((Test-Path -Path "$projectBuildPath\manifest.xml") -eq $false) {
      if (Test-Path -Path $projectBuildPath) {
        Write-Host "manifest not found : remove build cache" -ForegroundColor Blue
        Write-Host "Please, remove $projectBuildPath to rebuild neocore"
        Write-Host "You can use mak clean:build"
        exit 1
      }
    }

    if (Test-Path -Path "$projectBuildPath\manifest.xml") {
      $neocorePath = Get-TemplatePath -Path $Config.project.neocorePath
      $manifestSource = "$neocorePath\manifest.xml"
      $manifestCache = "$projectBuildPath\manifest.xml"
      Write-Host "source : $manifestSource"
      Write-Host "cache : $manifestCache"
      if ((Compare-FileHash -SrcFile $manifestSource -DestFile $manifestCache) -eq $false) {
        Write-Host "manifest has changed : remove build cache" -ForegroundColor Blue
        Write-Host "Please, remove $projectBuildPath to rebuild neocore"
        Write-Host "You can use mak clean:build"
        exit 1
      }
    }

    Assert-ManifestDependencies
    Write-Host "manifest is compliant" -ForegroundColor Green
  }
}
