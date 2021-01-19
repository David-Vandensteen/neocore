@echo off
if "%1"=="" goto :error
if "%2"=="" goto :error

%appdata%\neocore\bin\chdman.exe createcd -i "%1" -o "%2"

goto :end

:error
mak-chd cue-file chd-file

:end