@echo off
set PROJECT=sprite
set backupPath=%path%
set NEODEV=%appdata%\neocore\neodev-sdk
path=%NEODEV%\m68k\bin;%appdata%\neocore\bin;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0\
@echo on
make -f ..\Makefile %1 %2 %3
@echo off
if %errorlevel% neq 0 (
    @echo off
    path=%backupPath%
    exit /b %errorlevel%
)
@echo off
path=%backupPath%
