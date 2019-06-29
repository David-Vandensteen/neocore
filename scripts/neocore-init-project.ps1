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

function copyFiles{
  copyFile 0 scaffolding\common_crt0_cd.s projects\$projectName
  copyFile 0 scaffolding\crt0_cd.s projects\$projectName
  copyFile 0 scaffolding\mak.bat projects\$projectName
  copyFile 0 scaffolding\chardata.xml projects\$projectName
}

function configureMakefile{
  Write-Host "Generate Makefile for $projectName"
  copyFile 0 scaffolding\Makefile projects\$projectName
  $content = [System.IO.File]::ReadAllText("projects\$projectName\Makefile").Replace("/*projectName*/","$projectName")
  [System.IO.File]::WriteAllText("projects\$projectName\Makefile", $content)
}

function configureMak{
  Write-Host "Configure mak"
  $content = [System.IO.File]::ReadAllText("projects\$projectName\mak.bat").Replace("/*project*/","$projectName")
  [System.IO.File]::WriteAllText("projects\$projectName\mak.bat", $content)
}

function configureMain{
  Write-Host "Generate main.c for $projectName"
  copyFile 0 scaffolding\main.c projects\$projectName
}

function makeInit{
  Write-Host "$projectName mak init"
  pushd projects\$projectName
  & .\mak.bat init
  popd
}

function _main{
  createFolder projects\$projectName
  createFolder projects\$projectName\assets
  createFolder projects\$projectName\assets\gfx
  copyFiles
  #configureMakefile
  configureMak
  configureMain
  makeInit
}

_main