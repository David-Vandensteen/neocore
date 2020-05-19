@echo off
set PROJECT=fixed-value

set routine=..\..\scripts\mak-routines.bat
set backupPath=%path%

call %routine% :main %*
path=%backupPath%