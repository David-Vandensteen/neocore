@echo off

set name="undefined"
set projectPath="undefined"
set force="false"

:initial
if "%1"=="" goto done
echo              %1
set aux=%1
if "%aux%"=="-force" (
  set force="true"
)
if "%aux:~0,1%"=="-" (
   set nome=%aux:~1,250%
) else (
   set "%nome%=%1"
   set nome=
)
shift
goto initial
:done

echo name : %name%
echo projectPath : %projectPath%

if %name%=="undefined" goto arguments_error
if %projectPath%=="undefined" goto arguments_error

if %force%=="true" (
  echo force
  powershell -ExecutionPolicy Bypass -File _create.ps1 -Name %name% -Path %projectPath% -Force
) else (
  echo no force
  powershell -ExecutionPolicy Bypass -File _create.ps1 -Name %name% -Path %projectPath%%
)
goto end

:arguments_error
echo missing arguments
echo ex : create -name myGame -projectPath c:\myGame

:end
