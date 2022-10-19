rem TODO : make a custom makefile without neocore link
@echo off
set projectSetting="project.xml"
set builderScript="..\..\toolchain\scripts\Builder-Manager.ps1"

if "%1"=="" (
  powershell -ExecutionPolicy Bypass -File %builderScript%  -ConfigFile %projectSetting%
) else (
  powershell -ExecutionPolicy Bypass -File %builderScript% -ConfigFile %projectSetting% -Rule %1
)