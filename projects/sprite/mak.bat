@echo off
set PROJECT=sprite

set routine=..\..\scripts\mak-routines.bat
call %routine% :main %*
set error=%errorlevel%
path=%backupPath%
exit /b %error%
