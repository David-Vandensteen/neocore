function Write-Program {
  param (
    [Parameter(Mandatory=$true)][String] $MakeFile,
    [Parameter(Mandatory=$true)][String] $GCCPath,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $BinPath
  )
  Write-Host "Write Program" -ForegroundColor Cyan
  Write-Host "Assert write program" -ForegroundColor Yellow
  if (-Not(Assert-Program)) {
    Write-Host "Program assertion failed" -ForegroundColor Red
    return $false
  }

  Write-Host "Compiling program $PRGFile" -ForegroundColor Yellow

  $gccPath = Get-TemplatePath -Path $GCCPath
  $binPath = Get-TemplatePath -Path $BinPath
  $makeFile = Get-TemplatePath -Path $MakeFile
  $prgFile = Get-TemplatePath -Path $PRGFile
  $pathNeoDev = Get-TemplatePath -Path $PathNeoDev
  $projectName = Get-TemplatePath -Path $ProjectName
  $pathBuildName = Get-TemplatePath -Path "$($Config.project.buildPath)\$($Config.project.name)"
  $includePath = Resolve-TemplatePath -Path $Config.project.compiler.includePath
  $neocoreIncludePath = Resolve-TemplatePath -Path "$($Config.project.neocorePath)\src-lib"
  $libraryPath = Resolve-TemplatePath -Path $Config.project.compiler.libraryPath
  
  # Handle systemFile based on platform (defaulting to CD)
  $systemFile = ""
  if ($Config.project.compiler.systemFile.cd) {
    $systemFile = Resolve-TemplatePath -Path $Config.project.compiler.systemFile.cd
  } elseif ($Config.project.compiler.systemFile.cartridge) {
    $systemFile = Resolve-TemplatePath -Path $Config.project.compiler.systemFile.cartridge
  } else {
    Write-Host "Error: No system file configured for CD or cartridge" -ForegroundColor Red
    return $false
  }

  $env:PROJECT = $ProjectName
  $env:GCC_PATH = $gccPath

  $env:FILEPRG = $prgFile
  $env:PATHBUILD = $pathBuildName

  $Config.project.compiler

  $env:PROJECT_PATH = $(Resolve-TemplatePath -Path .)
  $env:INCLUDE_PATH = $includePath
  $env:NEOCORE_INCLUDE_PATH = $neocoreIncludePath
  $env:LIBRARY_PATH = $libraryPath
  $env:NEO_GEO_SYSTEM = $systemFile

  $env:path = "$gccPath;$binPath;$env:windir\System32;$env:windir\System32\WindowsPowerShell\v1.0\"

  Write-Host $env:path

  # TODO : debug exit code
  & make -f $MakeFile 2>&1 | Tee-Object -FilePath "$pathBuildName\gcc.log"
  $makeExitCode = $LASTEXITCODE

  if ($makeExitCode -ne 0) {
    Write-Host "Make failed with exit code $makeExitCode" -ForegroundColor Red
    return $false
  }

  if ((Test-Path -Path $prgFile) -eq $true) {
    Write-Host "Builded program $prgFile" -ForegroundColor Green
    Write-Host ""
    return $true
  } else {
    Write-Host "$prgFile was not generated" -ForegroundColor Red
    return $false
  }
}
