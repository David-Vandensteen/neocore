function Write-Program {
  param (
    [Parameter(Mandatory=$true)][String] $MakeFile,
    [Parameter(Mandatory=$true)][String] $GCCPath,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $BinPath
  )
  Write-Host "Compiling program $PRGFile" -ForegroundColor Yellow
  if ((Test-Path -Path $MakeFile) -eq $false) {
    Write-Host "$MakeFile not found" -ForegroundColor Red
    exit 1
  }

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

  & make -f $MakeFile > "$($Config.project.buildPath)\$($Config.project.name)\gcc.log" 2>&1
  & type "$($Config.project.buildPath)\$($Config.project.name)\gcc.log"
  if ((Test-Path -Path $PRGFile) -eq $true) {
    Write-Host "Builded program $PRGFile" -ForegroundColor Green
    Write-Host ""
  } else {
    Write-Host "$PRGFile was not generated" -ForegroundColor Red
    exit 1
  }
}
