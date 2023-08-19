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


rem set GCC_PATH=..\build\gcc\gcc-2.95.2
set GCC_PATH=..\build\gcc\MinGW-m68k-elf-13.1.0\bin

set INCLUDE_PATH=..\build\include
set LIBRARY_PATH=..\build\lib

if not exist %GCC_PATH% (
  echo %GCC_PATH% not found
  exit 1
)

if not exist %INCLUDE_PATH% (
  echo %INCLUDE_PATH% not found
  exit 1
)

if not exist %LIBRARY_PATH% (
  echo %LIBRARY_PATH% not found
  exit 1
)

path=%GCC_PATH%;%windir%;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0\

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
