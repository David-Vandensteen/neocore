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

REM Constants
set "ORIGIN=https://github.com/David-Vandensteen/neocore.git"
set "GIT_REPO_PATH=%temp%\neocore\git"

REM Get the first argument
set "ARG1=%~1"

REM Check if the first argument is --list
if "%ARG1%"=="--list" (
  echo Listing available neocore versions...
  echo.
  echo Tags:
  for /f "tokens=3* delims=/" %%a in ('git ls-remote --tags --refs %ORIGIN%') do (
    if "%%b"=="" (echo   %%a) else (echo   %%a/%%b)
  )
  echo.
  echo Branches:
  for /f "tokens=3* delims=/" %%a in ('git ls-remote --heads --refs %ORIGIN%') do (
    if "%%b"=="" (echo   %%a) else (echo   %%a/%%b)
  )
  goto :end
)

REM Check if argument is provided
if "%ARG1%"=="" (
  echo Error: No version specified.
  echo Usage: %~nx0 ^<version or branch^> 
  echo or %~nx0 --list
  goto :end
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
  goto :end
)

echo Switching to version: %ARG1% ^(!VERSION_FOUND!^)

REM Clean up existing repository if it exists
if exist "%GIT_REPO_PATH%" (
  echo Cleaning up existing repository...
  rd /s /q "%GIT_REPO_PATH%"
)

REM Clone the repository
echo Cloning neocore repository...
if not exist "%temp%\neocore" mkdir "%temp%\neocore"
git clone %ORIGIN% "%GIT_REPO_PATH%"
if %errorlevel% neq 0 (
  echo Error: Failed to clone repository.
  goto :end
)

REM Checkout the specified version
echo Checking out %ARG1%...
git -C "%GIT_REPO_PATH%" checkout %ARG1%
if %errorlevel% neq 0 (
  echo Error: Failed to checkout %ARG1%.
  goto :end
)

REM Pull latest changes if it's a branch
if "!VERSION_FOUND!"=="branch" (
  echo Pulling latest changes from branch %ARG1%...
  git -C "%GIT_REPO_PATH%" pull
  if %errorlevel% neq 0 (
    echo Error: Failed to pull latest changes.
    goto :end
  )
)

echo Successfully switched to version: %ARG1%

REM Clean up existing neocore folder
if exist "%~dp0neocore" (
  echo Removing existing neocore folder...
  rd /s /q "%~dp0neocore"
)

echo Running upgrade script...
powershell -ExecutionPolicy Bypass -Command "& { . '%~dp0neocore-version-switcher\write\log.ps1'; . '%~dp0neocore-version-switcher\copy\files.ps1'; Copy-NeocoreFiles -SourceNeocorePath '%GIT_REPO_PATH%' -ProjectNeocorePath '%~dp0neocore' -LogFile '%~dp0upgrade.log' }"
set UPGRADE_ERROR=%errorlevel%
if %UPGRADE_ERROR% neq 0 (
  echo Error: Upgrade script failed.
  goto :end
)

echo Upgrade completed successfully.

REM Create a temporary script to update this script after it exits (only if files exist in the version)
if exist "%GIT_REPO_PATH%\bootstrap\neocore-version-switcher.bat" (
  echo Updating version switcher script...
  set "TEMP_UPDATER=%temp%\update_neocore_switcher_%random%.bat"
  (
    echo @echo off
    echo timeout /t 2 /nobreak ^>nul
    echo if exist "%GIT_REPO_PATH%\bootstrap\neocore-version-switcher.bat" copy /Y "%GIT_REPO_PATH%\bootstrap\neocore-version-switcher.bat" "%~f0" ^>nul
    echo if exist "%GIT_REPO_PATH%\bootstrap\neocore-version-switcher" ^(
    echo   if exist "%~dp0neocore-version-switcher" rd /s /q "%~dp0neocore-version-switcher"
    echo   xcopy /E /I /Y /Q "%GIT_REPO_PATH%\bootstrap\neocore-version-switcher" "%~dp0neocore-version-switcher" ^>nul
    echo ^)
    echo del "%%~f0" ^& exit
  ) > "!TEMP_UPDATER!"
  start "" "!TEMP_UPDATER!"
) else (
  echo Version switcher not available in version %ARG1% - keeping current version
)

:end
endlocal
