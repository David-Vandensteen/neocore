function Write-Program {
  param (
    [Parameter(Mandatory=$true)][String] $MakeFile,
    [Parameter(Mandatory=$true)][String] $GCCPath,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $ProjectName
  )
  Logger-Step -Message "compiling program"
  if ((Test-Path -Path $MakeFile) -eq $false) { Logger-Error -Message "$MakeFile not found" }

  $env:PROJECT = $ProjectName
  #$env:NEODEV = $PathNeoDev
  #$env:NEODEV = "c:\temp\gcc\neocore"
  #$env:NEODEV = "c:\temp\gcc"

  $env:NEODEV = $GCCPath
  $env:FILEPRG = $PRGFile
  $env:PATHBUILD = $buildConfig.pathBuild

  $env:INCLUDE_PATH = "C:\temp\gcc\neocore\include"
  $env:LIBRARY_PATH = "C:\temp\gcc\neocore\lib"
  $env:NEO_GEO_SYSTEM = "C:\temp\gcc\neocore\system\neocd.x"

  $env:path = "$GCCPath;c:\temp\gcc\neocore\bin;$env:windir\System32;$env:windir\System32\WindowsPowerShell\v1.0\"

  Write-Host $env:path
  pause

  & make -f $MakeFile
  if ((Test-Path -Path $PRGFile) -eq $true) {
    Logger-Success "builded program is available to $PRGFile"
    Write-Host ""
  } else { Logger-Error -Message "error - $PRGFile was not generated" }
}
