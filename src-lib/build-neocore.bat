@echo off
set backupPath=%path%
set NEODEV=build\neodev-sdk

if exist ..\..\build set NEODEV=..\..\build\neodev-sdk
if exist ..\build set NEODEV=..\build\neodev-sdk
if exist build set NEODEV=build\neodev-sdk

if not exist %NEODEV% echo SDK not found
if not exist %NEODEV% echo build a program before compiling neocore lib
if not exist %NEODEV% echo SDK is needed
if not exist %NEODEV% echo building a program will install the needed SDK and dependencies
if not exist %NEODEV% exit 1

path=%NEODEV%\m68k\bin;build\bin;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0\

set error=0
@echo on
make -f Makefile %1 %2 %3
if %errorlevel% neq 0 (
  @echo off
  set error=%errorlevel%
)
@echo off
path=%backupPath%
exit /b %error%
