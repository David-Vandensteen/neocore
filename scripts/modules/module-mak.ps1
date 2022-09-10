Import-Module "..\..\scripts\modules\module-emulators.ps1"
Import-Module "..\..\scripts\modules\module-iso.ps1"

function Remove-Project {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName
  )
  Write-Host "Clean $ProjectName"
  Write-Host "Remove $env:TEMP\neocore\$ProjectName"
  Stop-Emulators
  if (Test-Path -Path $env:TEMP\neocore\$ProjectName) { Get-ChildItem -Path $env:TEMP\neocore\$ProjectName -Recurse | Remove-Item -force -recurse }
  if (Test-Path -Path $env:TEMP\neocore\$ProjectName) { Remove-Item $env:TEMP\neocore\$ProjectName -Force }
}

function Set-EnvPath {
  param (
    [Parameter(Mandatory=$true)][String] $PathNeoDevBin,
    [Parameter(Mandatory=$true)][String] $PathNeocoreBin
  )
  $env:path = "$PathNeoDevBin;$PathNeocoreBin;$env:windir\System32;$env:windir\System32\WindowsPowerShell\v1.0\"
  Write-Host "Env Path: $env:path"
}

function Write-Cue {
  # TODO
}

function Write-Program {
  param (
    [Parameter(Mandatory=$true)][String] $MakeFile,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $PathNeoDev,
    [Parameter(Mandatory=$true)][String] $ProjectName
  )
  Write-Host "make rule"
  $env:PROJECT = $ProjectName
  $env:NEODEV = $PathNeoDev
  $env:FILEPRG = $PRGFile
  & make -f $MakeFile
  Write-Host "program is available to $PRGFile" -ForegroundColor DarkMagenta
}

function Write-ISO {
  param (
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $SpriteFile,
    [Parameter(Mandatory=$true)][String] $PathISOBuildFolder,
    [Parameter(Mandatory=$true)][String] $PathCDTemplate
  )
  if (-Not(Test-Path -Path $PathISOBuildFolder)) { mkdir -Path $PathISOBuildFolder }
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

  # TODO : remove PathISOBuildFolder
  Copy-Item -Path "$PathCDTemplate\*" -Destination $PathISOBuildFolder -Recurse -Force
  Copy-Item -Path $PRGFile -Destination "$PathISOBuildFolder\DEMO.PRG" -Force
  Copy-Item -Path $SpriteFile -Destination "$PathISOBuildFolder\DEMO.SPR" -Force

  New-IsoFile -Source $PathISOBuildFolder -Path $OutputFile -Force
  Write-Host "iso is available to $OutputFile" -ForegroundColor DarkMagenta
}

function Write-Sprite {
  param (
    [Parameter(Mandatory=$true)][String] $Format,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $XMLFile
  )
  Write-Host "sprite rule"
  # TODO : catch error
  & BuildChar.exe $XMLFile
  & CharSplit.exe char.bin "-$Format" $OutputFile
  Remove-Item -Path char.bin -Force
  Write-Host "sprite is available to $OutputFile.$Format" -ForegroundColor Green
}

function Write-Zip {
  param (
    [Parameter(Mandatory=$true)][String] $Path,
    [Parameter(Mandatory=$true)][String] $ISOFile,
    [Parameter(Mandatory=$true)][String] $OutputFile
  )

  if ((Test-Path -Path $OutputFile)) { Remove-Item $OutputFile -Force }
  Add-Type -Assembly System.IO.Compression.FileSystem
  $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
  [System.IO.Compression.ZipFile]::CreateFromDirectory($Path, $OutputFile, $compressionLevel, $false)
  Write-Host "zip is available to $OutputFile" -ForegroundColor DarkMagenta
}