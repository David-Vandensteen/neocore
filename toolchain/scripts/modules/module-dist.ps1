function Write-Dist {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $PathDestination,
    [Parameter(Mandatory=$true)][String] $ISOFile,
    [Parameter(Mandatory=$true)][String] $CUEFile,
    [Parameter(Mandatory=$true)][String] $CHDFile,
    [Parameter(Mandatory=$true)][String] $HashFile
  )
  Write-Host "create dist" -ForegroundColor Yellow
  if ((Test-Path -Path $ISOFile) -eq $false) {
    Write-Host "error : $ISOFile not found" -ForegroundColor Red
    exit 1
  }
  if ((Test-Path -Path $CUEFile) -eq $false) {
    Write-Host "error : $CUEFile not found" -ForegroundColor Red
    exit 1
  }
  if ((Test-Path -Path $CHDFile) -eq $false) {
    Write-Host "error : $CHDFile not found" -ForegroundColor Red
    exit 1
  }
  if ((Test-Path -Path $HashFile) -eq $false) {
    Write-Host "error : $HashFile not found" -ForegroundColor Red
    exit 1
  }
  if ((Test-Path -Path $PathDestination) -eq $false) {
    New-Item -Path "$PathDestination\iso" -ItemType Directory -Force
    New-Item -Path "$PathDestination\mame" -ItemType Directory -Force
  } else {
    Write-Host "error : $PathDestination already exist" -ForegroundColor Red
    exit 1
  }
  Write-Host "copy iso file to $PathDestination\iso" -ForegroundColor Blue
  Copy-Item -Path $ISOFile -Destination "$PathDestination\iso"
  Copy-Item -Path $CUEFile -Destination "$PathDestination\iso"

  Write-Host "copy chd and Mame hash file to $PathDestination\mame" -ForegroundColor Blue
  Copy-Item -Path $CHDFile -Destination "$PathDestination\mame"
  Copy-Item -Path $HashFile -Destination "$PathDestination\mame"

  if ($Config.project.sound.cdda.tracks.track) {
    Write-Host ""
    Write-Host "copy sound tracks"
    Write-Host ""
    $content = [System.IO.File]::ReadAllText($CUEFile)
    $Config.project.sound.cdda.tracks.track | ForEach-Object {
      $fileName = Split-Path $_.file -leaf
      Write-Host "copy $fileName to $PathDestination\iso" -ForegroundColor Blue
      Copy-Item -Path $_.file -Destination "$PathDestination\iso"
      $content = $content.Replace($_.file, $fileName)
    }
    Write-Host "make a cue file"
    $content | Out-File -FilePath "$PathDestination\iso\$ProjectName.cue" -Encoding utf8 -Force
  }
  Write-Host ""
  if (((Test-Path -Path "$PathDestination\iso\$ProjectName.cue") -eq $true) -and ((Test-Path -Path "$PathDestination\iso\$ProjectName.cue") -eq $true)) {
    Write-Host "ISO delivery is available to $pathDestination\iso" -ForegroundColor Green
  } else {
    Write-Host "error : iso dist failed" -ForegroundColor Red
    exit 1
  }
  if ((Test-Path -Path "$pathDestination\mame\$ProjectName.chd") -eq $true) {
    Write-Host "Mame delivery is available to $PathDestination\mame" -ForegroundColor Green
  } else {
    Write-Host "error : mame dist failed" -ForegroundColor Red
    exit 1
  }
}