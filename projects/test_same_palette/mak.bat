@echo off
set PROJECT=test_same_palette

set routine=..\..\scripts\mak-routines.bat
set backupPath=%path%

call %routine% :main %*
path=%backupPath%