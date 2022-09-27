@echo off
rem set projectName="CDDA"
set projectSetting="project.xml"
set builderScript="..\..\scripts\Builder-Manager.ps1"

rem if "%1"=="" (
rem   powershell -ExecutionPolicy Bypass -File %builderScript%  -ProjectName %projectName%
rem ) else (
rem   powershell -ExecutionPolicy Bypass -File %builderScript% -ProjectName %projectName% -Rule %1
rem )

if "%1"=="" (
  powershell -ExecutionPolicy Bypass -File %builderScript%  -ConfigFile %projectSetting%
) else (
  powershell -ExecutionPolicy Bypass -File %builderScript% -ConfigFile %projectSetting% -Rule %1
)