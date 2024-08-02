@echo off
set backupPath=%path%
set NEODEV=build\neodev-sdk

set gccPath="undefined"
set includePath="undefined"
set libraryPath="undefined"

:initial
if "%1"=="" goto done
echo              %1
set aux=%1
if "%aux:~0,1%"=="-" (
   set nome=%aux:~1,250%
) else (
   set "%nome%=%1"
   set nome=
)
shift
goto initial
:done

echo %gccPath%
echo %includePath%
echo %libraryPath%

if %gccPath%=="undefined" goto arguments_error
if %includePath%=="undefined" goto arguments_error
if %libraryPath%=="undefined" goto arguments_erro

set INCLUDE_PATH=%includePath%
set LIBRARY_PATH=%libraryPath%

if not exist %gccPath% (
  echo %gccPath% not found
  exit 1
)

if not exist %includePath% (
  echo %includePath% not found
  exit 1
)

if not exist %libraryPath% (
  echo %libraryPath% not found
  exit 1
)

path=%gccPath%;%windir%;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0\

set error=0
@echo on
copy /y neocore.h %includePath%
make -f Makefile %1 %2 %3
if %errorlevel% neq 0 (
  @echo off
  set error=%errorlevel%
)
@echo off
path=%backupPath%
exit /b %error%

:arguments_error
echo missing arguments
echo ex : build-neocore -gccPath ..\build\gcc\gcc-2.95.2 -includePath ..\build\include -libraryPath ..\build\include²
