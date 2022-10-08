@echo off
set projectSetting="config\project.xml"
set builderScript="..\..\scripts\Builder-Manager.ps1"

if "%1"=="" (
  powershell -ExecutionPolicy Bypass -File %builderScript%  -ConfigFile %projectSetting%
) else (
  powershell -ExecutionPolicy Bypass -File %builderScript% -ConfigFile %projectSetting% -Rule %1
)