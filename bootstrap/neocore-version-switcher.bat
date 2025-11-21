@echo off
setlocal enabledelayedexpansion

REM Verify if git command is available
where git >nul 2>nul
if %errorlevel% neq 0 (
  echo Error: Git command not found.
  echo Please install Git and make sure it's in your PATH.
  pause
  exit /b 1
)

echo Git is available.
echo Continuing...

set "ARG1=%~1"
set "ARG2=%~2"
set "NEOCORE_VERSION_SWITCHER_SPOOL=neocore-version-switcher-spool"

REM Check if argument is provided
if "%ARG1%"=="" (
  echo Error: No version specified.
  echo Usage: %~nx0 ^<version or branch^> 
  echo or %~nx0 --list
  goto :end
)

if not "%ARG2%"=="no_update" (
  echo Downloading latest version of the script...
  echo.
  set "LATEST_SCRIPT_URL=https://raw.githubusercontent.com/David-Vandensteen/neocore/master/bootstrap/neocore-version-switcher.bat"  
  set "LATEST_SCRIPT_COPY_FILES_URL=https://raw.githubusercontent.com/David-Vandensteen/neocore/master/bootstrap/neocore-version-switcher/copy/files.ps1"
  set "LATEST_SCRIPT_WRITE_LOG_URL=https://raw.githubusercontent.com/David-Vandensteen/neocore/master/bootstrap/neocore-version-switcher/write/log.ps1"

  set "LATEST_SCRIPT=neocore-version-switcher-latest-spool.bat"

  REM Download PowerShell scripts first
  if exist !NEOCORE_VERSION_SWITCHER_SPOOL! rd /s /q !NEOCORE_VERSION_SWITCHER_SPOOL!

  if exist !NEOCORE_VERSION_SWITCHER_SPOOL! (
    echo error: Failed to remove existing !NEOCORE_VERSION_SWITCHER_SPOOL! directory.
    goto :cleanup
  )

  if not exist !NEOCORE_VERSION_SWITCHER_SPOOL! mkdir !NEOCORE_VERSION_SWITCHER_SPOOL!
  if not exist !NEOCORE_VERSION_SWITCHER_SPOOL!\copy mkdir !NEOCORE_VERSION_SWITCHER_SPOOL!\copy
  if not exist !NEOCORE_VERSION_SWITCHER_SPOOL!\write mkdir !NEOCORE_VERSION_SWITCHER_SPOOL!\write

  echo Downloading latest copy/files.ps1...
  curl -L --max-time 30 --connect-timeout 10 !LATEST_SCRIPT_COPY_FILES_URL! -o "!NEOCORE_VERSION_SWITCHER_SPOOL!\copy\files.ps1"
  if !errorlevel! neq 0 (
    echo Error: Failed to download latest copy/files.ps1.
    goto :cleanup
  )
  echo Downloading latest write/log.ps1...
  curl -L --max-time 30 --connect-timeout 10 !LATEST_SCRIPT_WRITE_LOG_URL! -o "!NEOCORE_VERSION_SWITCHER_SPOOL!\write\log.ps1"
  if !errorlevel! neq 0 (
    echo Error: Failed to download latest write/log.ps1.
    goto :cleanup
  )

  if not exist !NEOCORE_VERSION_SWITCHER_SPOOL!\copy\files.ps1 (
    echo Error: copy/files.ps1 does not exist after download.
    goto :cleanup
  )

  if not exist !NEOCORE_VERSION_SWITCHER_SPOOL!\write\log.ps1 (
    echo Error: write/log.ps1 does not exist after download.
    goto :cleanup
  )

  REM Download and execute updated script
  curl -L --max-time 30 --connect-timeout 10 !LATEST_SCRIPT_URL! -o "!LATEST_SCRIPT!"
  if !errorlevel! equ 0 (
    if "%ARG1%"=="" (
      call "!LATEST_SCRIPT!" no_update
    ) else (
      call "!LATEST_SCRIPT!" %* no_update
    )
    set SCRIPT_ERROR=!errorlevel!
    move "!LATEST_SCRIPT!" "%~f0"
    if exist "!LATEST_SCRIPT!" del "!LATEST_SCRIPT!"
    exit /b !SCRIPT_ERROR!
  ) else (
    echo Error: Failed to download latest version.
    goto :cleanup
  )
)

set "ORIGIN=https://github.com/David-Vandensteen/neocore.git"

REM Check if the first argument is --list
if "%ARG1%"=="--list" (
  echo Listing available neocore versions...
  echo.
  echo Branches:
  for /f "tokens=3* delims=/" %%a in ('git ls-remote --heads --refs %ORIGIN%') do (
    if "%%b"=="" (echo   %%a) else (echo   %%a/%%b)
  )
  echo Tags:
  for /f "tokens=3* delims=/" %%a in ('git ls-remote --tags --refs %ORIGIN%') do (
    if "%%b"=="" (echo   %%a) else (echo   %%a/%%b)
  )
  echo.
  goto :cleanup
)

set TIMESTAMP=%DATE:~-4%%DATE:~3,2%%DATE:~0,2%-%TIME::=%
set TIMESTAMP=%TIMESTAMP:~0,14%
set "GIT_REPO_PATH=%TEMP%\neocore\git\%TIMESTAMP%-%RANDOM%"

REM Clean up old temporary git repositories
if exist "%TEMP%\neocore\git" (
  echo Cleaning up old temporary repositories...
  rd /s /q "%TEMP%\neocore\git"
)

if not exist "%TEMP%\neocore" mkdir "%TEMP%\neocore"
if not exist "%TEMP%\neocore\git" mkdir "%TEMP%\neocore\git"

mkdir "%GIT_REPO_PATH%"
if %errorlevel% neq 0 (
  echo Error: Failed to create temporary directory.
  goto :cleanup
)

REM Verify if the version exists in tags or branches
set "VERSION_FOUND="
for /f "tokens=3* delims=/" %%a in ('git ls-remote --tags --refs %ORIGIN%') do (
  if "%%b"=="" (
    if "%%a"=="%ARG1%" set "VERSION_FOUND=tag"
  ) else (
    if "%%a/%%b"=="%ARG1%" set "VERSION_FOUND=tag"
  )
)
for /f "tokens=3* delims=/" %%a in ('git ls-remote --heads --refs %ORIGIN%') do (
  if "%%b"=="" (
    if "%%a"=="%ARG1%" set "VERSION_FOUND=branch"
  ) else (
    if "%%a/%%b"=="%ARG1%" set "VERSION_FOUND=branch"
  )
)

if not defined VERSION_FOUND (
  echo Error: Version '%ARG1%' not found in tags or branches.
  echo Use '%~nx0 --list' to see available versions.
  goto :cleanup
)

echo Switching to version: %ARG1% ^(!VERSION_FOUND!^)

REM Clean up existing repository if it exists
if exist "%GIT_REPO_PATH%" (
  echo Cleaning up existing repository...
  rd /s /q "%GIT_REPO_PATH%"
)

REM Clone the repository
echo Cloning neocore repository...
git clone --branch %ARG1% --depth 1 %ORIGIN% "%GIT_REPO_PATH%"
if %errorlevel% neq 0 (
  echo Error: Failed to clone repository.
  goto :cleanup
)

echo Successfully switched to version: %ARG1%

REM Clean up existing neocore folder
if exist "%~dp0neocore" (
  echo Removing existing neocore folder...
  rd /s /q "%~dp0neocore"
)

echo Running upgrade script...
powershell -ExecutionPolicy Bypass -Command "& { . '%~dp0!NEOCORE_VERSION_SWITCHER_SPOOL!\write\log.ps1'; . '%~dp0!NEOCORE_VERSION_SWITCHER_SPOOL!\copy\files.ps1'; Copy-NeocoreFiles -SourceNeocorePath '%GIT_REPO_PATH%' -ProjectNeocorePath '%~dp0neocore' -LogFile '%~dp0upgrade.log' }"
set UPGRADE_ERROR=%errorlevel%
if %UPGRADE_ERROR% neq 0 (
  echo Error: Upgrade script failed.
  goto :cleanup
)

goto :cleanup

:cleanup
REM Clean up temporary directories
if exist %NEOCORE_VERSION_SWITCHER_SPOOL% rd /s /q %NEOCORE_VERSION_SWITCHER_SPOOL%
if defined GIT_REPO_PATH (
  if exist "%GIT_REPO_PATH%" rd /s /q "%GIT_REPO_PATH%"
)

REM Remove at NeoCore v4
if exist neocore-version-switcher rd /s /q neocore-version-switcher

:end
endlocal
