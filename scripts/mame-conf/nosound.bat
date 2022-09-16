@echo off
set OUTFILE=%APPDATA%\neocore\mame-args.xml
echo ^<?xml version="1.0" encoding="UTF-8" ?^> > %OUTFILE%
echo ^<mame^> >> %OUTFILE%
echo   ^<args^>-window -sound none^</args^> >> %OUTFILE%
echo ^</mame^> >> %OUTFILE%
