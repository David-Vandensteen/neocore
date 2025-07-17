function Build-NeocoreLib {
  $buildPath = $(Resolve-Path -Path $Config.project.buildPath)
  $srcLibPath = $(Resolve-Path -Path "$($Config.project.neocorePath)\src-lib")
  $includePath = $(Resolve-Path -Path "$($Config.project.neocorePath)\src-lib\include")

  Assert-BuildNeocoreLib

  pushd $srcLibPath
  .\build-neocore.bat `
    -gccPath $buildPath\gcc\gcc-2.95.2 `
    -includePath $includePath `
    -libraryPath $buildPath\lib
  if ($LASTEXITCODE -ne 0) {
    popd
    Write-Host "Neocore lib was not builded" -ForegroundColor Red
    exit $LASTEXITCODE
  }
  Write-Host ""
  Write-Host "Neocore lib was builded" -ForegroundColor Green
  Write-Host ""
  popd
}
