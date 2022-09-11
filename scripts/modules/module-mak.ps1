Import-Module "..\..\scripts\modules\module-emulators.ps1"
Import-Module "..\..\scripts\modules\module-iso.ps1"

function Remove-Project {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName
  )
  Write-Host "Clean $ProjectName"
  Write-Host "Remove $env:TEMP\neocore\$ProjectName"
  Stop-Emulators
  if (Test-Path -Path $env:TEMP\neocore\$ProjectName) {
    Get-ChildItem -Path $env:TEMP\neocore\$ProjectName -Recurse -ErrorAction SilentlyContinue | Remove-Item -force -Recurse -ErrorAction SilentlyContinue
  }
  if (Test-Path -Path $env:TEMP\neocore\$ProjectName) { Remove-Item $env:TEMP\neocore\$ProjectName -Force -ErrorAction SilentlyContinue }
}

function Set-EnvPath {
  param (
    [Parameter(Mandatory=$true)][String] $PathNeoDevBin,
    [Parameter(Mandatory=$true)][String] $PathNeocoreBin
  )
  $env:path = "$PathNeoDevBin;$PathNeocoreBin;$env:windir\System32;$env:windir\System32\WindowsPowerShell\v1.0\"
  Write-Host "Env Path: $env:path"
  Write-Host "--------------------------------------------"
  Write-Host ""
}

function Write-CUE {
  param 
  (
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $ISOName
  )
  "CATALOG 0000000000000" | Out-File -FilePath $OutputFile -Force
  ('FILE "{0}" BINARY' -f $ISOName) | Out-File -FilePath $OutputFile -Append -Force
  "TRACK 01 MODE1/2048" | Out-File -FilePath $OutputFile -Append -Force
  "INDEX 01 00:00:00" | Out-File -FilePath $OutputFile -Append -Force
  Write-Host "builded CUE is available to $OutputFile" -ForegroundColor Green
  Write-Host ""
}

function Write-Program {
  param (
    [Parameter(Mandatory=$true)][String] $MakeFile,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $ProjectName
  )
  Write-Host "compiling program" -ForegroundColor Yellow
  $env:PROJECT = $ProjectName
  $env:NEODEV = $PathNeoDev
  $env:FILEPRG = $PRGFile
  & make -f $MakeFile
  # TODO : test outfile
  Write-Host "builded program is available to $PRGFile" -ForegroundColor Green
  Write-Host ""
}

function Write-ISO {
  param (
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $SpriteFile,
    [Parameter(Mandatory=$true)][String] $PathISOBuildFolder,
    [Parameter(Mandatory=$true)][String] $PathCDTemplate
  )
  Write-Host "compiling ISO" -ForegroundColor Yellow
  if (Test-Path -Path $PathISOBuildFolder) { Remove-Item $PathISOBuildFolder -Recurse -Force }
  if (-Not(Test-Path -Path $PathISOBuildFolder)) { mkdir -Path $PathISOBuildFolder | Out-Null }
  if (-Not(Test-Path -Path $PathCDTemplate)) {
    Write-Host "error : $PathCDTemplate not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $PRGFile)) {
    Write-Host "error : $PRGFile not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $SpriteFile)) {
    Write-Host "error : $SpriteFile not found" -ForegroundColor Red
    exit 1
  }
  Copy-Item -Path "$PathCDTemplate\*" -Destination $PathISOBuildFolder -Recurse -Force
  Copy-Item -Path $PRGFile -Destination "$PathISOBuildFolder\DEMO.PRG" -Force
  Copy-Item -Path $SpriteFile -Destination "$PathISOBuildFolder\DEMO.SPR" -Force

  New-IsoFile -Source $PathISOBuildFolder -Path $OutputFile -Force | Out-Null
  # TODO : test outfile
  Write-Host "builded ISO is available to $OutputFile" -ForegroundColor Green
  Write-Host ""
}

function Write-Sprite {
  param (
    [Parameter(Mandatory=$true)][String] $Format,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $XMLFile
  )
  Write-Host "compiling sprites" -ForegroundColor Yellow
  # TODO : catch error
  & BuildChar.exe $XMLFile
  & CharSplit.exe char.bin "-$Format" $OutputFile
  Remove-Item -Path char.bin -Force
  # TODO : test outfile
  Write-Host "builded sprites is available to $OutputFile.$Format" -ForegroundColor Green
  Write-Host ""
}

function Write-ZIP {
  param (
    [Parameter(Mandatory=$true)][String] $Path,
    [Parameter(Mandatory=$true)][String] $ISOFile,
    [Parameter(Mandatory=$true)][String] $OutputFile
  )
  Write-Host "compiling ZIP" -ForegroundColor Yellow
  if ((Test-Path -Path $OutputFile)) { Remove-Item $OutputFile -Force }
  Add-Type -Assembly System.IO.Compression.FileSystem
  $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
  [System.IO.Compression.ZipFile]::CreateFromDirectory($Path, $OutputFile, $compressionLevel, $false)
   # TODO : test outfile
   Write-Host "builded ZIP is available to $OutputFile" -ForegroundColor Green
  Write-Host ""
}