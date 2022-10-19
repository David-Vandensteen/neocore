# TODO : patch buildChar with error level output
function Write-Sprite {
  param (
    [Parameter(Mandatory=$true)][String] $Format,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $XMLFile
  )
  Write-Host "compiling sprites" -ForegroundColor Yellow
  if ((Test-Path -Path $XMLFile) -eq $false) { Write-Host "error - $XMLFile not found" -ForegroundColor Red; exit 1 }

  Start-Process -File BuildChar.exe -NoNewWindow -ArgumentList($XMLFile) -Wait -RedirectStandardOutput "$PATH_BUILD\sprite.log"

  Get-Content -Path "$PATH_BUILD\sprite.log" -Force

  if (Select-String -Path "$PATH_BUILD\sprite.log" -Pattern "Invalid dimension") {
    Write-Host "error - Invalid dimension" -ForegroundColor Red
    exit 1
  }
  if (Select-String -Path "$PATH_BUILD\sprite.log" -Pattern "est pas valide") {
    Write-Host "error - Invalid parameter" -ForegroundColor Red
    exit 1
  }

  if ((Get-ChildItem -Path "." -Filter "*.*_reject.*" -Recurse -ErrorAction SilentlyContinue -Force).Length -ne 0) {
    Write-Host "Open reject *_reject file(s)" -ForegroundColor Red
    Write-Host "Fix asset and remove *_reject file(s) in your project before launch a new build ..." -ForegroundColor Red
    Write-Host "error - Sprite reject..." -ForegroundColor Red
    exit 1
  }


  & CharSplit.exe char.bin "-$Format" $OutputFile
  Remove-Item -Path char.bin -Force

  if ((Test-Path -Path "$OutputFile.$Format") -eq $true) {
    Write-Host "builded sprites is available to $OutputFile.$Format" -ForegroundColor Green
    Write-Host ""
  } else {
    Write-Host ("error - {0}.{1} was not generated" -f $OutputFile, $Format) -ForegroundColor Red
    exit 1
  }
}