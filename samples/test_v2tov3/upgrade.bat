@echo off
echo ==============================================
echo NeoCore v2 to v3 Migration Test Script
echo ==============================================

:: Clean up any existing test project
if exist %temp%\test_v2tov3 (
    echo Cleaning up existing test project...
    rd /s /q %temp%\test_v2tov3
)

:: Create a fresh v3 project (this creates the base structure)
echo.
echo Creating fresh v3 project for testing...
cd ..\..\bootstrap\scripts\project
call create.bat -name test_v2tov3 -projectPath %temp%\test_v2tov3

if %errorlevel% neq 0 (
    echo Error: Failed to create test project
    pause
    exit /b 1
)

:: Now copy our v2 test files over the v3 template to simulate a v2 project
echo.
echo Copying v2 test files to simulate migration scenario...
cd ..\..\..\samples\test_v2tov3

:: Copy our v2 manifest.xml to project root (to simulate v2 project)
copy /y manifest.xml %temp%\test_v2tov3\

:: Copy our v2 project.xml and main.c to src folder
copy /y project.xml %temp%\test_v2tov3\src\
copy /y main.c %temp%\test_v2tov3\src\

:: Run the migration script
echo.
echo Running v2 to v3 migration script...
cd ..\..\bootstrap\scripts\project
call upgrade.bat -projectSrcPath %temp%\test_v2tov3\src -projectNeocorePath %temp%\test_v2tov3\neocore

if %errorlevel% neq 0 (
    echo Error: Migration script failed
    pause
    exit /b 1
)

:: Return to test directory
cd ..\..\..\samples\test_v2tov3

echo.
echo ==============================================
echo Migration test completed!
echo.
echo Test project location: %temp%\test_v2tov3
echo.
echo To verify migration:
echo   1. Check manifest.xml version
echo   2. Check project.xml compatibility
echo   3. Try building: cd "%temp%\test_v2tov3\src" ^&^& mak.ps1
echo ==============================================
pause
