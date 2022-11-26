if "%1"=="" (
  powershell -ExecutionPolicy Bypass -File tester.ps1 -Rule "run:mame" -KillTime 30
) else (
  powershell -ExecutionPolicy Bypass -File tester.ps1 -Rule "run:mame" -KillTime %1
)