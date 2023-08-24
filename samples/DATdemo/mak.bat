if "%1"=="" (
  powershell -ExecutionPolicy Bypass -File mak.ps1
) else (
  powershell -ExecutionPolicy Bypass -File mak.ps1 %1
)