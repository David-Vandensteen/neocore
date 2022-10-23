function Write-Program {
  param (
    [Parameter(Mandatory=$true)][String] $MakeFile,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $ProjectName
  )
  Logger-Step -Message "compiling program"
  if ((Test-Path -Path $MakeFile) -eq $false) { Logger-Error -Message "$MakeFile not found" }

  $env:PROJECT = $ProjectName
  $env:NEODEV = $PathNeoDev
  $env:FILEPRG = $PRGFile
  $env:PATHBUILD = $buildConfig.pathBuild

  & make -f $MakeFile
  if ((Test-Path -Path $PRGFile) -eq $true) {
    Logger-Success "builded program is available to $PRGFile"
    Write-Host ""
  } else { Logger-Error -Message "error - $PRGFile was not generated" }
}
