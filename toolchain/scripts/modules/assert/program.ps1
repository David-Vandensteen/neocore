function Assert-Program {
  $gccPath = Get-TemplatePath -Path $GCCPath
  $binPath = Get-TemplatePath -Path $BinPath
  $makeFile = Get-TemplatePath -Path $MakeFile
  $pathNeoDev = Get-TemplatePath -Path $PathNeoDev
  $includePath = Resolve-TemplatePath -Path $Config.project.compiler.includePath
  $libraryPath = Resolve-TemplatePath -Path $Config.project.compiler.libraryPath
  $systemFile = Resolve-TemplatePath -Path $Config.project.compiler.systemFile

  Write-Host "includePath: $includePath" -ForegroundColor Yellow
  if (-Not(Test-Path -Path $gccPath) -or $gccPath -eq "") {
    Write-Host "error : $gccPath not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $binPath) -or $binPath -eq "") {
    Write-Host "error : $binPath not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $makeFile) -or $makeFile -eq "") {
    Write-Host "error : $makeFile not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $pathNeoDev) -or $pathNeoDev -eq "") {
    Write-Host "error : $pathNeoDev not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $includePath)) {
    Write-Host "error : $includePath not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $libraryPath)) {
    Write-Host "error : $libraryPath not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $systemFile)) {
    Write-Host "error : $systemFile not found" -ForegroundColor Red
    exit 1
  }
}