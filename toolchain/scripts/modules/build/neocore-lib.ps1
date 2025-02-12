function Build-NeocoreLib {
  $buildPath = $(Resolve-Path $buildConfig.pathNeocore)
 pushd "$($Config.project.neocorePath)\src-lib"
 .\build-neocore.bat `
  -gccPath $buildPath\gcc\gcc-2.95.2 `
  -includePath $buildPath\include `
  -libraryPath $buildPath\lib
 if ($LASTEXITCODE -ne 0) {
  popd
  Logger-Error -Message  "neocore lib was not builded"
  exit $LASTEXITCODE
 }
 Write-Host ""
 Write-Host "neocore lib was builded" -ForegroundColor Green
 Write-Host ""
 popd
}
