set FILE=Makefile

call %*

:init
set NEODEV=%appdata%\neocore\neodev-sdk
path=%NEODEV%\m68k\bin;%appdata%\neocore\bin;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0\
exit /b 0

:init-sprite
if exist chardata.xml (
  if not exist palettes.s echo. > palettes.s
  if not exist maps.s echo. > maps.s
)
exit /b 0

:make
@echo on
if not exist Makefile set FILE=..\Makefile

make -f %FILE% %*
if %errorlevel% neq 0 (
  pause
)
@echo off
exit /b %errorlevel%

:main
if "%1"=="run" (
  if "%2"=="raine" (
    %appdata%\neocore\raine\raine32.exe
    goto :end
  )
)
call :init
call :init-sprite
call :make %*

:end
exit /b 0