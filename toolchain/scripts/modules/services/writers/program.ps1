function Write-Program {
  param (
    [Parameter(Mandatory=$true)][String] $MakeFile,
    [Parameter(Mandatory=$true)][String] $GCCPath,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $BinPath
  )
  Logger-Step -Message "compiling program"
  if ((Test-Path -Path $MakeFile) -eq $false) { Logger-Error -Message "$MakeFile not found" }

  $env:PROJECT = $ProjectName
  $env:GCC_PATH = $GCCPath

  $env:FILEPRG = $PRGFile
  $env:PATHBUILD = $buildConfig.pathBuild

  $Config.project.compiler

  $env:PROJECT_PATH = $(Resolve-Path -Path .)
  $env:INCLUDE_PATH = $(Resolve-Path -Path $Config.project.compiler.includePath)
  $env:LIBRARY_PATH = $(Resolve-Path -Path $Config.project.compiler.libraryPath)
  $env:NEO_GEO_SYSTEM = $(Resolve-Path -Path $Config.project.compiler.systemFile)

  $env:path = "$GCCPath;$BinPath;$env:windir\System32;$env:windir\System32\WindowsPowerShell\v1.0\"

  Write-Host $env:path

  & make -f $MakeFile
  if ((Test-Path -Path $PRGFile) -eq $true) {
    Logger-Success "builded program is available at $PRGFile"
    Write-Host ""
  } else { Logger-Error -Message "error - $PRGFile was not generated" }
}
