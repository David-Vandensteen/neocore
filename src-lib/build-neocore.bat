@echo off
set backupPath=%path%
@REM set NEODEV=build\neodev-sdk

@REM if exist ..\..\build set NEODEV=..\..\build\neodev-sdk
@REM if exist ..\build set NEODEV=..\build\neodev-sdk
@REM if exist build set NEODEV=build\neodev-sdk

@REM if not exist %NEODEV% echo SDK not found
@REM if not exist %NEODEV% echo build a program before compiling neocore lib
@REM if not exist %NEODEV% echo SDK is needed
@REM if not exist %NEODEV% echo building a program will install the needed SDK and dependencies
@REM if not exist %NEODEV% exit 1

rem path=%NEODEV%\m68k\bin;build\bin;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0\

set NEODEV=c:\temp\gcc\neocore
rem path=c:\temp\gcc\sgdk\bin;%windir%;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0\
path=C:\temp\gcc\MinGW-m68k-elf-13.1.0\bin;%windir%;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0\

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
