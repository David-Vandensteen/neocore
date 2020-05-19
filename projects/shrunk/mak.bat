@echo off
set PROJECT=shrunk

set routine=..\..\scripts\mak-routines.bat
set backupPath=%path%

call %routine% :main %*
path=%backupPath%