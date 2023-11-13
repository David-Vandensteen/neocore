@echo off
if exist ..\..\..\build set OUTFILE=..\..\..\build\mame-args.xml
if exist ..\..\build set OUTFILE=..\..\build\mame-args.xml
if exist ..\build set OUTFILE=..\build\mame-args.xml
if exist buid set OUTFILE=build\mame-args.xml
echo %OUTFILE%

del %OUTFILE% /F /Q