@echo off
if exist ..\..\..\build set OUTFILE=..\..\..\build\mame-args.xml
if exist ..\..\build set OUTFILE=..\..\build\mame-args.xml
if exist ..\build set OUTFILE=..\build\mame-args.xml
if exist buid set OUTFILE=build\mame-args.xml
echo %OUTFILE%

echo ^<?xml version="1.0" encoding="UTF-8" ?^> > %OUTFILE%
echo ^<mame^> >> %OUTFILE%
echo   ^<args^>-nowindow^</args^> >> %OUTFILE%
echo ^</mame^> >> %OUTFILE%