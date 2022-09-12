function Write-Mame {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $PathMame,
    [Parameter(Mandatory=$true)][String] $CUEFile,
    [Parameter(Mandatory=$true)][String] $OutputFile
  )

  if ((Test-Path -Path $PathMame) -eq $false) { Write-Host "error - $PathMame not found" -ForegroundColor Red; exit 1 }
  if ((Test-Path -Path $CUEFile) -eq $false) { Write-Host "error - $CUEFile not founc" -ForegroundColor Red; exit 1 }
  if ((Test-Path -Path "$PathMame\mame64.exe") -eq $false) { Write-Host "error - mame64.exe is not found in $PathMame" -ForegroundColor Red; exit 1 }

  Write-Host "compiling CHD" -ForegroundColor Yellow
  & chdman.exe createcd -i $CUEFile -o $OutputFile --force
  if ((Test-Path -Path $OutputFile) -eq $false) {
    Write-Host "error - $OutputFile was not generated" -ForegroundColor Red
    exit 1
  } else {
    Write-Host "builded CHD is available to $OutputFile" -ForegroundColor Green
    Write-Host ""
  }
  Write-MameHash -ProjectName $ProjectName -CHDFile $OutputFile -XMLFile "$PathMame\hash\neocd.xml"
}

# TODO : mame args ... override in env ?
function Mame {
  param (
    [Parameter(Mandatory=$true)][String] $GameName,
    [Parameter(Mandatory=$true)][String] $PathMame
  )
  if ((Test-Path -Path $PathMame) -eq $false) { Write-Host "error - $PathMame not found" -ForegroundColor Red; exit 1 }
  if ((Test-Path -Path "$PathMame\mame64.exe") -eq $false) { Write-Host ("error - {0}\mame64.exe not found" -f $PathMame) -ForegroundColor Red; exit 1 }
  Write-Host "launching mame $GameName" -ForegroundColor Yellow
  Start-Process -NoNewWindow -FilePath "$PathMame\mame64.exe" -ArgumentList "-window -rompath `"$PathMame\roms`" -hashpath `"$PathMame\hash`" -cfg_directory $env:TEMP -nvram_directory $env:TEMP -skip_gameinfo neocdz $GameName"
}
