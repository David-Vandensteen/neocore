@echo off

set projectSetting=project.xml

for /d %%i in (..\..) do set neocorePath=%%~fi

cd /d %neocorePath%
powershell -ExecutionPolicy Bypass -File bootstrap\scripts\project\mak.ps1 -ProjectSetting %projectSetting% %*
