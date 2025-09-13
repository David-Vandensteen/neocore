function Assert-Program {
  $gccPath = Get-TemplatePath -Path $GCCPath
  $binPath = Get-TemplatePath -Path $BinPath
  $makeFile = Get-TemplatePath -Path $MakeFile
  $pathNeoDev = Get-TemplatePath -Path $PathNeoDev
  $includePath = Resolve-TemplatePath -Path $Config.project.compiler.includePath
  $neocoreIncludePath = Resolve-TemplatePath -Path "$($Config.project.neocorePath)\src-lib"
  $libraryPath = Resolve-TemplatePath -Path $Config.project.compiler.libraryPath

  # Handle systemFile based on platform (defaulting to CD)
  $systemFile = ""
  if ($Config.project.compiler.systemFile.cd) {
    $systemFile = Resolve-TemplatePath -Path $Config.project.compiler.systemFile.cd
  } elseif ($Config.project.compiler.systemFile.cartridge) {
    $systemFile = Resolve-TemplatePath -Path $Config.project.compiler.systemFile.cartridge
  }

  Write-Host "Assert program" -ForegroundColor Yellow
  Write-Host "includePath: $includePath" -ForegroundColor Yellow
  Write-Host "neocoreIncludePath: $neocoreIncludePath" -ForegroundColor Yellow
  if (-Not(Test-Path -Path $gccPath) -or $gccPath -eq "") {
    Write-Host "error : $gccPath not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Test-Path -Path $binPath) -or $binPath -eq "") {
    Write-Host "error : $binPath not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Test-Path -Path $makeFile) -or $makeFile -eq "") {
    Write-Host "error : $makeFile not found" -ForegroundColor Red
    return $false
  }
  if (-not $includePath -or $includePath -eq "" -or -Not(Test-Path -Path $includePath)) {
    Write-Host "Error: $includePath not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Test-Path -Path $neocoreIncludePath)) {
    Write-Host "error : $neocoreIncludePath not found" -ForegroundColor Red
    return $false
  }
  if (-not $libraryPath -or $libraryPath -eq "" -or -Not(Test-Path -Path $libraryPath)) {
    Write-Host "error : $libraryPath not found" -ForegroundColor Red
    return $false
  }
  if ($systemFile -and -Not(Test-Path -Path $systemFile)) {
    Write-Host "error : $systemFile not found" -ForegroundColor Red
    return $false
  }

  Write-Host "Program assertion completed successfully" -ForegroundColor Green
  return $true
}
