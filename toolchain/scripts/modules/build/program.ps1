function Build-Program {
  Write-Host "Build Program" -ForegroundColor Cyan
  Assert-BuildProgram
  $projectBuildPath = Resolve-TemplatePath -Path $Config.project.buildPath
  $prgFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).prg"
  $prgFile = Get-TemplatePath -Path $prgFile
  $buildPath = Get-TemplatePath -Path $Config.project.buildPath
  $buildPathName = Get-TemplatePath -Path "$projectBuildPath\$($Config.project.name)"

  # FIX: Proper robocopy error handling instead of silent | Out-Null
  Write-Host "Copying project files to build directory..." -ForegroundColor Cyan
  Write-Host "  Source: $(Get-Location)" -ForegroundColor Gray
  Write-Host "  Destination: $buildPathName" -ForegroundColor Gray

  try {
    # Create destination directory if it doesn't exist
    if (-not (Test-Path $buildPathName)) {
      New-Item -Path $buildPathName -ItemType Directory -Force | Out-Null
      Write-Host "  Created build directory: $buildPathName" -ForegroundColor Green
    }

    # Run robocopy with proper error handling
    # /e = copy subdirectories including empty ones
    # /xf * = exclude all files (copy directory structure only)
    # /njh /njs = no job header/summary (cleaner output)
    $robocopyOutput = robocopy .\ "$buildPathName" /e /xf * /njh /njs 2>&1
    $robocopyExitCode = $LASTEXITCODE

    # Robocopy exit codes: 0-7 are success, 8+ are errors
    if ($robocopyExitCode -gt 7) {
      Write-Warning "Robocopy completed with warnings/errors (exit code: $robocopyExitCode)"
      Write-Host "Robocopy output:" -ForegroundColor Yellow
      $robocopyOutput | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }

      # Check if destination was created despite warnings
      if (-not (Test-Path $buildPathName)) {
        throw "Failed to create build directory structure"
      }
    } else {
      Write-Host "  Directory structure copied successfully" -ForegroundColor Green
      if ($robocopyExitCode -gt 0) {
        Write-Host "  (Robocopy exit code: $robocopyExitCode - some files/folders processed)" -ForegroundColor Gray
      }
    }
  } catch {
    Write-Error "Failed to copy project files: $_"
    return $false
  }

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

  $gccPath = $null

  # Validate required compiler configuration
  if ([string]::IsNullOrEmpty($Config.project.compiler.path)) {
    Write-Error "Compiler path is not specified in project configuration. Please add <path> element in <compiler> section."
    return $false
  }

  if ([string]::IsNullOrEmpty($Config.project.compiler.version)) {
    Write-Error "Compiler version is not specified in project configuration. Please add <version> element in <compiler> section."
    return $false
  }

  # Resolve the configured GCC path
  Write-Host "Using configured GCC compiler..." -ForegroundColor Green
  Write-Host "  Version: $($Config.project.compiler.version)" -ForegroundColor Cyan
  Write-Host "  Path (template): $($Config.project.compiler.path)" -ForegroundColor Gray

  $gccPath = Get-TemplatePath -Path $Config.project.compiler.path
  Write-Host "  Path (resolved): $gccPath" -ForegroundColor Cyan

  # Verify the resolved path exists
  if (-not (Test-Path $gccPath)) {
    Write-Error @"
Configured GCC path does not exist: $gccPath

Please check:
1. Your project.xml compiler configuration
2. That the GCC toolchain is installed at the specified location
3. That template variables {{build}} and {{neocore}} resolve correctly

Raw path from config: $($Config.project.compiler.path)
Resolved path: $gccPath
"@
    return $false
  }

  Write-Host "  GCC path validated successfully" -ForegroundColor Green

  Write-Program `
    -ProjectName $Config.project.name `
    -GCCPath $gccPath -PathNeoDev "$($buildPath)\neodev-sdk" `
    -MakeFile $Config.project.makefile `
    -PRGFile $prgFile `
    -BinPath "$($buildPath)\bin"
}
