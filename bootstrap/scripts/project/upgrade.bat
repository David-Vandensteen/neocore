@echo off

set projectSrcPath="undefined"
set projectNeocorePath="undefined"

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

echo projectSrcPath : %projectSrcPath%
echo projectNeocorePath : %projectNeocorePath%

if %projectSrcPath%=="undefined" goto arguments_error
if %projectNeocorePath%=="undefined" goto arguments_error

powershell -ExecutionPolicy Bypass -File _upgrade.ps1 -ProjectSrcPath %projectSrcPath% -ProjectNeocorePath %projectNeocorePath%%
goto end

:arguments_error
echo missing arguments
echo ex : upgrade -projectSrcPath c:\myGame\src -projectNeocorePath c:\myGame\neocore

:end
