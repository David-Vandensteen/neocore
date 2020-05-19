@echo off
set PROJECT=test_image

set routine=..\..\scripts\mak-routines.bat
set backupPath=%path%

call %routine% :main %*
path=%backupPath%