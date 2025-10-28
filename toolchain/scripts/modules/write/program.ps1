function Write-Program {
  param (
    [Parameter(Mandatory=$true)][String] $MakeFile,
    [Parameter(Mandatory=$true)][String] $GCCPath,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $BinPath,
    [String] $StatusFile
  )
  Write-Host "Compiling program $PRGFile" -ForegroundColor Yellow
  Write-Host "Assert write program" -ForegroundColor Yellow
  if (-Not(Assert-Program)) {
    Write-Host "Program assertion failed" -ForegroundColor Red
    return $false
  }

  Write-Host "Compiling program $PRGFile" -ForegroundColor Yellow

  $gccPath = Get-TemplatePath -Path $GCCPath
  $binPath = Get-TemplatePath -Path $BinPath
  $makeFile = Get-TemplatePath -Path $MakeFile
  $prgFile = Get-TemplatePath -Path $PRGFile
  $pathNeoDev = Get-TemplatePath -Path $PathNeoDev
  $projectName = Get-TemplatePath -Path $ProjectName
  $pathBuildName = Get-TemplatePath -Path "$($Config.project.buildPath)\$($Config.project.name)"
  $includePath = Resolve-TemplatePath -Path $Config.project.compiler.includePath
  $neocoreIncludePath = Resolve-TemplatePath -Path "$($Config.project.neocorePath)\src-lib"
  $libraryPath = Resolve-TemplatePath -Path $Config.project.compiler.libraryPath

  # Handle systemFile based on platform (defaulting to CD)
  $systemFile = ""
  if ($Config.project.compiler.systemFile.cd) {
    $systemFile = Resolve-TemplatePath -Path $Config.project.compiler.systemFile.cd
  } elseif ($Config.project.compiler.systemFile.cartridge) {
    $systemFile = Resolve-TemplatePath -Path $Config.project.compiler.systemFile.cartridge
  } else {
    Write-Host "Error: No system file configured for CD or cartridge" -ForegroundColor Red
    return $false
  }

  $env:PROJECT = $ProjectName
  $env:GCC_PATH = $gccPath

  $env:FILEPRG = $prgFile
  $env:PATHBUILD = $pathBuildName
  $env:PROJECT_PATH = $pathBuildName
  $env:INCLUDE_PATH = $includePath
  $env:NEOCORE_INCLUDE_PATH = $neocoreIncludePath
  $env:LIBRARY_PATH = $libraryPath
  $env:NEO_GEO_SYSTEM = $systemFile

  $env:path = "$gccPath;$binPath;$env:windir\System32;$env:windir\System32\WindowsPowerShell\v1.0\"

  Write-Host $env:path

  # Execute make with proper output handling
  Write-Host "Executing make command..." -ForegroundColor Cyan
  Write-Host "Command: make -f $MakeFile" -ForegroundColor Gray
  Write-Host "Log file: $pathBuildName\gcc.log" -ForegroundColor Gray
  Write-Host ""

  # Use Start-Process for better output handling
  $makeProcess = Start-Process -FilePath "make" -ArgumentList "-f", $MakeFile -NoNewWindow -PassThru -Wait -RedirectStandardOutput "$pathBuildName\gcc.log" -RedirectStandardError "$pathBuildName\gcc_error.log"
  $makeExitCode = $makeProcess.ExitCode

  Write-Host "Make exit code: $makeExitCode" -ForegroundColor Cyan

  # Display the output from the log file
  if (Test-Path "$pathBuildName\gcc.log") {
    Write-Host "Make output:" -ForegroundColor Yellow
    Get-Content "$pathBuildName\gcc.log" | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
  }

  # Display warnings and errors if any
  if (Test-Path "$pathBuildName\gcc_error.log") {
    $errorContent = Get-Content "$pathBuildName\gcc_error.log"
    if ($errorContent) {
      $warnings = $errorContent | Where-Object { $_ -match "warning:" }
      $errors = $errorContent | Where-Object { $_ -match "error:" }

      if ($warnings) {
        Write-Host "Make warnings:" -ForegroundColor Yellow
        $warnings | ForEach-Object { Write-Host "  $_" -ForegroundColor Yellow }
      }

      if ($errors) {
        Write-Host "Make errors:" -ForegroundColor Red
        $errors | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
      }

      # If there are other messages that are neither warnings nor errors
      $others = $errorContent | Where-Object { $_ -notmatch "warning:" -and $_ -notmatch "error:" }
      if ($others) {
        Write-Host "Make messages:" -ForegroundColor Cyan
        $others | ForEach-Object { Write-Host "  $_" -ForegroundColor Cyan }
      }
    }
  }

  if ($makeExitCode -ne 0) {
    Write-Host "Make failed with exit code $makeExitCode" -ForegroundColor Red
    if ($StatusFile) { "FAILURE" | Out-File -FilePath $StatusFile -Force }
    return $false
  } else {
    # Only check for output file if make succeeded
    if ((Test-Path -Path $prgFile) -eq $true) {
      # Check if there were warnings
      $warningCount = 0
      if (Test-Path "$pathBuildName\gcc_error.log") {
        $errorContent = Get-Content "$pathBuildName\gcc_error.log"
        $warningCount = ($errorContent | Where-Object { $_ -match "warning:" } | Measure-Object).Count
      }

      if ($warningCount -gt 0) {
        Write-Host "Builded program $prgFile (with $warningCount warning$(if($warningCount -gt 1){'s'}))" -ForegroundColor Yellow
      } else {
        Write-Host "Builded program $prgFile" -ForegroundColor Green
      }
      Write-Host ""

      # Assert legacy functions after successful build
      # Use the original project directory, not the build directory
      $originalProjectPath = (Get-Location).Path
      $legacyCheckResult = Assert-ProgramLegacy -ProjectPath $originalProjectPath
      Write-Host ""

      if ($StatusFile) { "SUCCESS" | Out-File -FilePath $StatusFile -Force }
      return $true
    } else {
      Write-Host "$prgFile was not generated" -ForegroundColor Red
      if ($StatusFile) { "FAILURE" | Out-File -FilePath $StatusFile -Force }
      return $false
    }
  }
}
