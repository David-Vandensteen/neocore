@echo off
set PROJECT=hello

set routine=..\..\scripts\mak-routines.bat
set backupPath=%path%

call %routine% :main %*
set path=%backupPath%
