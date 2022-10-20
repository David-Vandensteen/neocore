@echo off
rem TODO : parmetric folder bin & neodev
rem set backupPath=%path%
rem set NEODEV=..\build\neodev-sdk
rem path=%NEODEV%\m68k\bin;build\bin;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0\
set error=0
@echo on
make -f Makefile %1 %2 %3
if %errorlevel% neq 0 (
  @echo off
  set error=%errorlevel%
)
@echo off
rem path=%backupPath%
exit /b %error%
