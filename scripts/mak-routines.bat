call %*

:init
set backupPath=%path%
set NEODEV=%appdata%\neocore\neodev-sdk
path=%NEODEV%\m68k\bin;%appdata%\neocore\bin;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0\
set error=0
exit /b 0

:init-sprite
if exist chardata.xml (
  if not exist palettes.s echo. > palettes.s
  if not exist maps.s echo. > maps.s
)
exit /b 0

:make
@echo on
make -f ..\Makefile %*
if %errorlevel% neq 0 (
  @echo off
  set error=%errorlevel%
)
@echo off
exit /b %error%

:getOriginalPath
echo %backupPath%
exit /b 0

:main
call :init
call :init-sprite
call :make %*
exit /b %error%