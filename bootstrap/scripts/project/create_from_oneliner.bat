@echo off
setlocal

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
echo.

set /p NAME="Project name: "
set PROJECT_PATH=%CD%
set TIMESTAMP=%DATE:~-4%%DATE:~3,2%%DATE:~0,2%-%TIME::=%
set TIMESTAMP=%TIMESTAMP:~0,14%
set "CLONE_PATH=%TEMP%\neocore\git\%RANDOM%-%TIMESTAMP%"

git clone --depth 1 https://github.com/David-Vandensteen/neocore.git "%CLONE_PATH%"
if errorlevel 1 goto error

pushd "%CLONE_PATH%"
git pull
popd

pushd "%CLONE_PATH%\bootstrap\scripts\project"
call create.bat -name %NAME% -projectPath %PROJECT_PATH% -force
set CREATE_RESULT=%ERRORLEVEL%
popd

rmdir /S /Q "%CLONE_PATH%"
if %CREATE_RESULT% neq 0 goto error

echo.
echo Project created successfully in %PROJECT_PATH%
echo Next steps: cd src ^&^& mak.bat sprite ^&^& mak.bat ^&^& mak.bat run:mame
endlocal
exit /b 0

:error
echo.
echo Error: Project creation failed
endlocal
exit /b 1