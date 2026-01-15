function Build-NeocoreLib {
  $buildPath = $(Resolve-TemplatePath -Path $Config.project.buildPath)
  $srcLibPath = $(Resolve-TemplatePath -Path "$($Config.project.neocorePath)\src-lib")
  $includePath = $(Resolve-TemplatePath -Path "$($Config.project.neocorePath)\src-lib\include")

  if (-Not(Assert-BuildNeocoreLib)) {
    Write-Host "Neocore lib build assertion failed" -ForegroundColor Red
    return $false
  }

  pushd $srcLibPath
  .\build-neocore.bat
  if ($LASTEXITCODE -ne 0) {
    popd
    Write-Host "Neocore lib was not builded" -ForegroundColor Red
    return $false
  }
  Write-Host ""
  Write-Host "Neocore lib was builded" -ForegroundColor Green
  Write-Host ""
  popd
  return $true
}
