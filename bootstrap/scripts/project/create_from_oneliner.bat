@echo off
setlocal
set /p NAME="Project name: "
set PROJECT_PATH=%CD%
set TMPDIR=%TEMP%\neocore-%RANDOM%
git clone --quiet --depth 1 https://github.com/David-Vandensteen/neocore.git "%TMPDIR%"
if errorlevel 1 goto error
pushd "%TMPDIR%"
git pull --quiet
popd
pushd "%TMPDIR%\bootstrap\scripts\project"
call create.bat -name %NAME% -projectPath %PROJECT_PATH% -force
set CREATE_RESULT=%ERRORLEVEL%
popd
rmdir /S /Q "%TMPDIR%"
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