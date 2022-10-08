function Write-Program {
  param (
    [Parameter(Mandatory=$true)][String] $MakeFile,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $ProjectName
  )
  Write-Host "compiling program" -ForegroundColor Yellow
  if ((Test-Path -Path $MakeFile) -eq $false) { Write-Host "error - $MakeFile not found" -ForegroundColor Red; exit 1 }

  $env:PROJECT = $ProjectName
  $env:NEODEV = $PathNeoDev
  $env:FILEPRG = $PRGFile
  & make -f $MakeFile
  if ((Test-Path -Path $PRGFile) -eq $true) {
    Write-Host "builded program is available to $PRGFile" -ForegroundColor Green
    Write-Host ""
  } else {
    Write-Host "error - $PRGFile was not generated" -ForegroundColor Red
    exit 1
  }
}
