function Remove-Project {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName
  )
  Write-Host "clean $ProjectName project" -ForegroundColor Yellow
  Write-Host "remove $env:TEMP\neocore\$ProjectName"
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
  "CATALOG 0000000000000 " | Out-File -Encoding ascii -FilePath $OutputFile -Force
  ('  FILE "{0}" BINARY ' -f $ISOName) | Out-File -Encoding ascii -FilePath $OutputFile -Append -Force
  "  TRACK 01 MODE1/2048 " | Out-File -Encoding ascii -FilePath $OutputFile -Append -Force
  "  INDEX 01 00:00:00 " | Out-File -Encoding ascii -FilePath $OutputFile -Append -Force

  if ((Test-Path -Path $OutputFile) -eq $true) {
    Write-Host "builded CUE is available to $OutputFile" -ForegroundColor Green
    Write-Host ""
  } else {
    Write-Host "error - $OutputFile was not generated" -ForegroundColor Red
    exit 1
  }
}

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
    Write-Host "error - $PathCDTemplate not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $PRGFile)) {
    Write-Host "error - $PRGFile not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $SpriteFile)) {
    Write-Host "error - $SpriteFile not found" -ForegroundColor Red
    exit 1
  }
  Copy-Item -Path "$PathCDTemplate\*" -Destination $PathISOBuildFolder -Recurse -Force
  Copy-Item -Path $PRGFile -Destination "$PathISOBuildFolder\DEMO.PRG" -Force
  Copy-Item -Path $SpriteFile -Destination "$PathISOBuildFolder\DEMO.SPR" -Force

  & mkisofs.exe -o $OutputFile -pad $PathISOBuildFolder
  
  if ((Test-Path -Path $OutputFile) -eq $true) {
    Write-Host "builded ISO is available to $OutputFile" -ForegroundColor Green
    Write-Host ""  
  } else {
    Write-Host "error - $OutputFile was not generated" -ForegroundColor Red
    exit 1
  }
}

function Write-Sprite {
  param (
    [Parameter(Mandatory=$true)][String] $Format,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $XMLFile
  )
  Write-Host "compiling sprites" -ForegroundColor Yellow
  if ((Test-Path -Path $XMLFile) -eq $false) { Write-Host "error - $XMLFile not found" -ForegroundColor Red; exit 1 }

  & BuildChar.exe $XMLFile
  & CharSplit.exe char.bin "-$Format" $OutputFile
  Remove-Item -Path char.bin -Force
  
  if ((Test-Path -Path "$OutputFile.$Format") -eq $true) {
    Write-Host "builded sprites is available to $OutputFile.$Format" -ForegroundColor Green
    Write-Host ""  
  } else {
    Write-Host ("error - {0}.{1} was not generated" -f $OutputFile, $Format) -ForegroundColor Red
    exit 1
  }
}

function Write-ZIP {
  param (
    [Parameter(Mandatory=$true)][String] $Path,
    [Parameter(Mandatory=$true)][String] $ISOFile,
    [Parameter(Mandatory=$true)][String] $OutputFile
  )
  Write-Host "compiling ZIP" -ForegroundColor Yellow
  if ((Test-Path -Path $ISOFile) -eq $false) { Write-Host "error - $ISOFile not found" -ForegroundColor Red; exit 1 }
  if ((Test-Path -Path $Path) -eq $false) { Write-Host "error - $Path not found" -ForegroundColor Red; exit 1 }

  if ((Test-Path -Path $OutputFile)) { Remove-Item $OutputFile -Force }
  Add-Type -Assembly System.IO.Compression.FileSystem
  $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
  [System.IO.Compression.ZipFile]::CreateFromDirectory($Path, $OutputFile, $compressionLevel, $false)

  if ((Test-Path -Path $OutputFile) -eq $true) {
    Write-Host "builded ZIP is available to $OutputFile" -ForegroundColor Green
    Write-Host ""  
  } else {
    Write-Host "error - $OutputFile was not generated" -ForegroundColor Red
    exit 1
  }
}

function Watch-Folder {
  param (
   [Parameter(Mandatory=$true)][String] $Path 
  )
  if ((Test-Path -Path $Path) -eq $false) { Write-Host "error - $Path not found" -ForegroundColor Red; exit 1 }
  Write-Host "waiting change in $Path" -ForegroundColor Yellow

  $sizeLast = (Get-ChildItem -Path $Path | Measure-Object -Sum Length | Select-Object Count, Sum).Sum
  $sizeCurrent = $sizeLast
  Write-Host $sizeCurrent
  While ($sizeLast -like $sizeCurrent) {
    Start-Sleep -Seconds 5
    $sizeCurrent = (Get-ChildItem -Path $Path | Measure-Object -Sum Length | Select-Object Count, Sum).Sum
  }
}