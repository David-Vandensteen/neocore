@echo off
rem TODO : parmetric folder bin & neodev
set backupPath=%path%
set NEODEV=build\neodev-sdk
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
