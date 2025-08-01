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

  # Check for outdated common_crt0_cd.s version
  if (-Not(Assert-CRT0Version)) {
    return $false
  }

  Write-Host "Program assertion completed successfully" -ForegroundColor Green
  return $true
}

function Assert-CRT0Version {
  $crt0File = "common_crt0_cd.s"

  if (-Not(Test-Path -Path $crt0File)) {
    Write-Host "Warning: $crt0File not found, skipping version check" -ForegroundColor Yellow
    return $true
  }

  Write-Host "Checking $crt0File version..." -ForegroundColor Yellow

  $content = Get-Content -Path $crt0File -Raw

  # Check for modern version markers
  $hasVBLCallBack = $content -match "VBL_callBack"
  $hasVBLSkipCallBack = $content -match "VBL_skipCallBack"
  $hasPaddingSection = $content -match "\.word\s+0xffff"

  # Check for old version marker (flush interrupts before TInextTable init)
  $hasOldOrder = $content -match "move\.b\s+#7,\s+0x3C000C.*move\.l\s+#0,\s+TInextTable"

  if (-not $hasVBLCallBack -or -not $hasVBLSkipCallBack -or -not $hasPaddingSection -or $hasOldOrder) {
    Write-Host "" -ForegroundColor Red
    Write-Host "===============================================" -ForegroundColor Red
    Write-Host "ERROR: Outdated common_crt0_cd.s detected!" -ForegroundColor Red
    Write-Host "===============================================" -ForegroundColor Red
    Write-Host "" -ForegroundColor Red
    Write-Host "Your project is using an outdated version of common_crt0_cd.s" -ForegroundColor Red
    Write-Host "that is not compatible with NeoCore v3" -ForegroundColor Red
    Write-Host "" -ForegroundColor Red
    Write-Host "Missing features in your version:" -ForegroundColor Yellow
    if (-not $hasVBLCallBack) { Write-Host "  - VBL_callBack initialization" -ForegroundColor Yellow }
    if (-not $hasVBLSkipCallBack) { Write-Host "  - VBL_skipCallBack initialization" -ForegroundColor Yellow }
    if (-not $hasPaddingSection) { Write-Host "  - Memory padding section" -ForegroundColor Yellow }
    if ($hasOldOrder) { Write-Host "  - Incorrect initialization order" -ForegroundColor Yellow }
    Write-Host "" -ForegroundColor Red
    Write-Host "Solution:" -ForegroundColor Green
    Write-Host "  Copy the updated common_crt0_cd.s from the bootstrap template" -ForegroundColor Green
    Write-Host "     (from bootstrap/standalone/)" -ForegroundColor Green
    Write-Host "Build halted to prevent runtime issues." -ForegroundColor Red
    Write-Host "===============================================" -ForegroundColor Red
    return $false
  }

  Write-Host "[OK] common_crt0_cd.s version is up-to-date" -ForegroundColor Green
  return $true
}
