@echo off
set PROJECT=test_animated_sprite_physic

set routine=..\..\scripts\mak-routines.bat
set backupPath=%path%

call %routine% :main %*
path=%backupPath%