@echo off
if not exist ..\build (
    echo Build directory does not exist. Please compile something first.
    exit /b 1
)
powershell -ExecutionPolicy Bypass -File _install-doxygen.ps1