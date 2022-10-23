# TODO : patch buildChar with error level output
function Write-Sprite {
  param (
    [Parameter(Mandatory=$true)][String] $Format,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $XMLFile
  )
  Logger-Step -Message "compiling sprites"
  if ((Test-Path -Path $XMLFile) -eq $false) { Logger-Error -Message "$XMLFile not found" }

  Start-Process -File BuildChar.exe -NoNewWindow -ArgumentList($XMLFile) -Wait -RedirectStandardOutput "$($buildConfig.pathBuild)\sprite.log"

  Get-Content -Path "$($buildConfig.pathBuild)\sprite.log" -Force

  if (Select-String -Path "$($buildConfig.pathBuild)\sprite.log" -Pattern "Invalid dimension") { Logger-Error -Message "Invalid dimension" }
  if (Select-String -Path "$($buildConfig.pathBuild)\sprite.log" -Pattern "est pas valide") { Logger-Error -Message "Invalid parameter" }

  if ((Get-ChildItem -Path "." -Filter "*.*_reject.*" -Recurse -ErrorAction SilentlyContinue -Force).Length -ne 0) {
    Write-Host "Open reject *_reject file(s)" -ForegroundColor Red
    Write-Host "Fix asset and remove *_reject file(s) in your project before launch a new build ..." -ForegroundColor Red
    Logger-Error -Message "Sprite reject..."
  }


  & CharSplit.exe char.bin "-$Format" $OutputFile
  Remove-Item -Path char.bin -Force

  if ((Test-Path -Path "$OutputFile.$Format") -eq $true) {
    Logger-Success -Message "builded sprites is available to $OutputFile.$Format"
    Write-Host ""
  } else {
    Write-Host ("error - {0}.{1} was not generated" -f $OutputFile, $Format) -ForegroundColor Red
    exit 1
  }
}
