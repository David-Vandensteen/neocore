function Build-Program {
  Write-Host "Build Program" -ForegroundColor Cyan
  if (-Not(Assert-BuildProgram)) {
    Write-Host "Build program assertion failed" -ForegroundColor Red
    return $false
  }
  $projectBuildPath = Resolve-TemplatePath -Path $Config.project.buildPath
  if (-not $projectBuildPath) {
    Write-Host "Failed to resolve build path: $($Config.project.buildPath)" -ForegroundColor Red
    return $false
  }
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
    # /njh /njs = no job header/summary (cleaner output)
    $robocopyOutput = robocopy .\ "$buildPathName" /e /njh /njs 2>&1
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

  # Copy CRT files using configured crtPath
  Write-Host "Copying CRT runtime files..." -ForegroundColor Cyan
  $crtPath = Resolve-TemplatePath -Path $Config.project.compiler.crtPath
  if ([string]::IsNullOrEmpty($crtPath)) {
    Write-Error "CRT path is not specified in project configuration. Please add <crtPath> element in <compiler> section."
    return $false
  }
  Write-Host "  Source: $crtPath" -ForegroundColor Gray
  Write-Host "  Destination: $buildPathName" -ForegroundColor Gray

  try {
    if (-not (Test-Path $crtPath)) {
      throw "CRT source directory not found: $crtPath"
    }

    # Copy CRT files to build directory
    $crtCopyOutput = robocopy "$crtPath" "$buildPathName" *.* /e /njh /njs 2>&1
    $crtCopyExitCode = $LASTEXITCODE



    # Robocopy exit codes: 0-7 are success, 8+ are errors
    if ($crtCopyExitCode -gt 7) {
      Write-Warning "CRT files copy completed with warnings/errors (exit code: $crtCopyExitCode)"
      Write-Host "Robocopy output:" -ForegroundColor Yellow
      $crtCopyOutput | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    } else {
      Write-Host "  CRT files copied successfully" -ForegroundColor Green
      if ($crtCopyExitCode -gt 0) {
        Write-Host "  (Robocopy exit code: $crtCopyExitCode - some files processed)" -ForegroundColor Gray
      }
    }

    # Customize CRT files with project-specific values
    $crt0File = "$buildPathName\crt0_cd.s"
    if (Test-Path $crt0File) {
      Write-Host "Customizing CRT file with project name..." -ForegroundColor Cyan

      # Ensure project name is exactly 16 characters with padding
      $projectName = $Config.project.name
      if ($projectName.Length -gt 16) {
        $projectName = $projectName.Substring(0, 16)
        Write-Warning "  Project name truncated to 16 characters: '$projectName'"
      } elseif ($projectName.Length -lt 16) {
        $projectName = $projectName.PadRight(16, ' ')
        Write-Host "  Project name padded to 16 characters: '$projectName'" -ForegroundColor Gray
      }

      $crtContent = Get-Content $crt0File -Raw
      $crtContent = $crtContent -replace '/\*project_name\*/', $projectName
      Set-Content -Path $crt0File -Value $crtContent -NoNewline
      Write-Host "  Replaced /*project_name*/ with '$projectName' in crt0_cd.s" -ForegroundColor Green
    }
  } catch {
    Write-Error "Failed to copy CRT files: $_"
    return $false
  }

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

  Write-Host "Calling Write-Program..." -ForegroundColor Cyan

  # Create a temporary file to capture the return status
  $statusFile = "$buildPath\build_status.tmp"
  if (Test-Path $statusFile) { Remove-Item $statusFile -Force }

  Write-Program `
    -ProjectName $Config.project.name `
    -GCCPath $gccPath -PathNeoDev "$($buildPath)\neodev-sdk" `
    -MakeFile $Config.project.makefile `
    -PRGFile $prgFile `
    -BinPath "$($buildPath)\bin" `
    -StatusFile $statusFile | Out-Null

  $result = $false
  if (Test-Path $statusFile) {
    $statusContent = Get-Content $statusFile
    $result = ($statusContent -eq "SUCCESS")
    Remove-Item $statusFile -Force
  }

  # Check .gitignore configuration after successful build
  if ($result) {
    $projectSrc = (Get-Location).Path
    Assert-Gitignore -ProjectSrc $projectSrc | Out-Null
  }

  return $result
}
