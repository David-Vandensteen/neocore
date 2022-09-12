@echo off
set projectName="shrunk"
set builderScript="..\..\scripts\Builder-Manager.ps1"

if "%1"=="" (
  powershell -ExecutionPolicy Bypass -File %builderScript%  -ProjectName %projectName%
) else (
  powershell -ExecutionPolicy Bypass -File %builderScript% -ProjectName %projectName% -Rule %1
)