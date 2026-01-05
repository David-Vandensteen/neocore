echo %1 | findstr /i "raine" >nul
IF %ERRORLEVEL%==0 (
  ECHO Raine is not supported for this sample
  EXIT /B 1
)

if "%1"=="" (
  powershell -ExecutionPolicy Bypass -File mak.ps1
) else (
  powershell -ExecutionPolicy Bypass -File mak.ps1 %1
)