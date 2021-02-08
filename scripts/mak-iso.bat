@echo off
if "%1"=="" goto :error
if "%2"=="" goto :error

%appdata%\neocore\bin\mkisofs.exe -o %2 -pad %1

goto :end

:error
echo mak-iso folder iso-file

:end