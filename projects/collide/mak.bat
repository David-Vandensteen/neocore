@echo off
set PROJECT=collide

set routine=..\..\scripts\mak-routines.bat
set backupPath=%path%

call %routine% :main %*
path=%backupPath%