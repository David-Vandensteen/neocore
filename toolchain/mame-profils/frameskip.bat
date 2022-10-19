@echo off
set OUTFILE=..\..\build\mame-args.xml
echo ^<?xml version="1.0" encoding="UTF-8" ?^> > %OUTFILE%
echo ^<mame^> >> %OUTFILE%
echo   ^<args^>-window -sound none -frameskip 10^</args^> >> %OUTFILE%
echo ^</mame^> >> %OUTFILE%