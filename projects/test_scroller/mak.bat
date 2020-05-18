@echo off
set PROJECT=test_scroller
set backupPath=%path%
set NEODEV=%appdata%\neocore\neodev-sdk
path=%NEODEV%\m68k\bin;%appdata%\neocore\bin;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0\
set error=0
if exist chardata.xml (
  if not exist palettes.s echo. > palettes.s
  if not exist maps.s echo. > maps.s
)
@echo on
make -f ..\Makefile %1 %2 %3
if %errorlevel% neq 0 (
  @echo off
  set error=%errorlevel%
)
@echo off
path=%backupPath%
