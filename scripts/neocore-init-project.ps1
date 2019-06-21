$projectName = Read-Host "Project name "

function createFolder([String] $_item){
  if( !(Test-path($_item))){
    Write-Host "Create : $_item"
    New-Item -ItemType Directory -Force -Path $_item
  }
}

function copyFile([boolean] $_exit, [String] $_src, [String] $_dest){
  Write-Host "Copy : $_src $_dest"
  if ( !(Test-Path($_src))){
      Write-Host "File not found :  $_src"
      if($_exit){ Exit }
  }else{
      Copy-Item $_src -Destination $_dest -Recurse
  }
}

function copyCrt{
  copyFile 0 "$env:appdata\neocore\neodev-sdk\src\system\common_crt0_cd.s"  projects\$projectName
  copyFile 0 scaffolding\crt0_cd.s projects\$projectName
}

function configureMakefile{
  Write-Host "Generate Makefile for $projectName"
  copyFile 0 scaffolding\Makefile projects\$projectName
  $content = [System.IO.File]::ReadAllText("projects\$projectName\Makefile").Replace("/*projectName*/","$projectName")
  [System.IO.File]::WriteAllText("projects\$projectName\Makefile", $content)
}

function configureMain{
  Write-Host "Generate main.c for $projectName"
  copyFile 0 scaffolding\main.c projects\$projectName
}

function _main{
  createFolder projects\$projectName
  copyCrt
  configureMakefile
  configureMain
}

_main