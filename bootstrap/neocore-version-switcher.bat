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

echo Git is available. Continuing...

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
    echo Usage: %~nx0 ^<version^> or %~nx0 --list
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

REM Check if git repository exists
if not exist "%GIT_REPO_PATH%\.git" (
    echo Cloning neocore repository...
    if not exist "%temp%\neocore" mkdir "%temp%\neocore"
    git clone %ORIGIN% "%GIT_REPO_PATH%"
    if %errorlevel% neq 0 (
        echo Error: Failed to clone repository.
        goto :end
    )
)

REM Fetch latest changes
echo Fetching latest changes...
git -C "%GIT_REPO_PATH%" fetch --all --tags
if %errorlevel% neq 0 (
    echo Error: Failed to fetch changes.
    goto :end
)

REM Checkout the specified version
echo Checking out %ARG1%...
git -C "%GIT_REPO_PATH%" checkout %ARG1%
if %errorlevel% neq 0 (
    echo Error: Failed to checkout %ARG1%.
    goto :end
)

echo Successfully switched to version: %ARG1%

echo Running upgrade script...
powershell -ExecutionPolicy Bypass -Command "& { . '%~dp0neocore-version-switcher\write\log.ps1'; . '%~dp0neocore-version-switcher\copy\files.ps1'; Copy-NeocoreFiles -SourceNeocorePath '%GIT_REPO_PATH%' -ProjectNeocorePath '%~dp0neocore' -LogFile '%~dp0upgrade.log' }"
set UPGRADE_ERROR=%errorlevel%
if %UPGRADE_ERROR% neq 0 (
    echo Error: Upgrade script failed.
    goto :end
)

echo Upgrade completed successfully.

:end
endlocal
