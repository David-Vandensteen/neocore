function Build-Program {
  Write-Host "Build Program" -ForegroundColor Cyan
  Assert-BuildProgram
  $projectBuildPath = Resolve-TemplatePath -Path $Config.project.buildPath
  $prgFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).prg"
  $prgFile = Get-TemplatePath -Path $prgFile
  $buildPath = Get-TemplatePath -Path $Config.project.buildPath
  $buildPathName = Get-TemplatePath -Path "$projectBuildPath\$($Config.project.name)"

  robocopy .\ "$buildPathName" /e /xf * | Out-Null

  # DEBUG: Show compiler configuration
  Write-Host "=== Compiler Configuration Debug ===" -ForegroundColor Magenta
  Write-Host "Compiler name: $($Config.project.compiler.name)" -ForegroundColor Gray
  Write-Host "Compiler version: $($Config.project.compiler.version)" -ForegroundColor Gray
  Write-Host "Compiler path (raw): $($Config.project.compiler.path)" -ForegroundColor Gray
  if ($Config.project.compiler.path) {
    $resolvedPath = Get-TemplatePath -Path $Config.project.compiler.path
    Write-Host "Compiler path (resolved): $resolvedPath" -ForegroundColor Gray
    Write-Host "Path exists: $(Test-Path $resolvedPath)" -ForegroundColor Gray
  }
  Write-Host "===================================" -ForegroundColor Magenta

  $gccPath = $null  # Check if compiler version is specified and supported
  if ($Config.project.compiler.version -eq "2.95.2") {
    Write-Host "Using configured GCC 2.95.2 path..." -ForegroundColor Green
    $gccPath = Get-TemplatePath -Path $Config.project.compiler.path
    Write-Host "Resolved GCC path: $gccPath" -ForegroundColor Cyan
  } else {
    # Handle unspecified version or other versions
    if ([string]::IsNullOrEmpty($Config.project.compiler.version)) {
      Write-Host "No compiler version specified, using default configuration..." -ForegroundColor Yellow
    } else {
      Write-Warning "Unsupported compiler version: $($Config.project.compiler.version)"
      Write-Host "Attempting to use default path..." -ForegroundColor Yellow
    }

    # Try path from config first (regardless of version)
    if ($Config.project.compiler.path) {
      $configPath = Get-TemplatePath -Path $Config.project.compiler.path
      Write-Host "Trying configured path: $configPath" -ForegroundColor Cyan
      if (Test-Path $configPath) {
        $gccPath = $configPath
        Write-Host "Using GCC path from config: $gccPath" -ForegroundColor Green
      } else {
        Write-Warning "Configured GCC path does not exist: $configPath"
      }
    }

    # If still no path found, search in standard locations
    if (-not $gccPath) {
      Write-Host "Searching for GCC in standard locations..." -ForegroundColor Yellow
      $standardPaths = @(
        "$env:NEODEV\m68k\bin",
        "C:\neodev\m68k\bin",
        "C:\mingw\bin",
        "C:\msys64\usr\bin",
        "$env:ProgramFiles\mingw-w64\mingw64\bin",
        "$env:ProgramFiles(x86)\mingw-w64\mingw32\bin"
      )

      foreach ($path in $standardPaths) {
        Write-Host "  Checking: $path" -ForegroundColor Gray
        if (Test-Path $path) {
          # Check if gcc.exe exists in this path
          $gccExe = Join-Path $path "gcc.exe"
          if (Test-Path $gccExe) {
            $gccPath = $path
            Write-Host "Found GCC executable at: $gccExe" -ForegroundColor Green
            break
          } else {
            Write-Host "  Path exists but no gcc.exe found" -ForegroundColor Gray
          }
        } else {
          Write-Host "  Path does not exist" -ForegroundColor Gray
        }
      }

      # If still not found, try to find gcc.exe anywhere
      if (-not $gccPath) {
        Write-Host "Trying to locate gcc.exe using where command..." -ForegroundColor Yellow
        try {
          $whereResult = where.exe gcc 2>$null
          if ($whereResult) {
            $gccPath = Split-Path $whereResult[0] -Parent
            Write-Host "Found GCC using where command: $gccPath" -ForegroundColor Green
          }
        } catch {
          Write-Host "where command failed or gcc not in PATH" -ForegroundColor Gray
        }
      }
    }
  }

  # Verify that $gccPath is defined before continuing
  if (-not $gccPath) {
    Write-Error @"
Unable to find GCC path. Please check your configuration.

Current environment variables:
- NEODEV: $env:NEODEV
- PATH: $($env:PATH -split ';' | Where-Object { $_ -like '*gcc*' -or $_ -like '*mingw*' -or $_ -like '*msys*' })
"@
    return $false
  }

  if (-not (Test-Path $gccPath)) {
    Write-Error "Specified GCC path does not exist: $gccPath"
    return $false
  }

  Write-Program `
    -ProjectName $Config.project.name `
    -GCCPath $gccPath -PathNeoDev "$($buildPath)\neodev-sdk" `
    -MakeFile $Config.project.makefile `
    -PRGFile $prgFile `
    -BinPath "$($buildPath)\bin"
}
