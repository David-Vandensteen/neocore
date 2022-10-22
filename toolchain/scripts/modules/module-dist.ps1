function Write-Dist {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $PathDestination,
    [Parameter(Mandatory=$true)][String] $ISOFile,
    [Parameter(Mandatory=$true)][String] $CUEFile,
    [Parameter(Mandatory=$true)][String] $CHDFile,
    [Parameter(Mandatory=$true)][String] $HashFile
  )
  Logger-Step -Message "create dist"
  if ((Test-Path -Path $ISOFile) -eq $false) { Logger-Error -Message "$ISOFile not found" }
  if ((Test-Path -Path $CUEFile) -eq $false) { Logger-Error -Message "$CUEFile not found" }
  if ((Test-Path -Path $CHDFile) -eq $false) { Logger-Error -Message "$CHDFile not found" }
  if ((Test-Path -Path $HashFile) -eq $false) { Logger-Error -Message "$HashFile not found" }

  if ((Test-Path -Path $PathDestination) -eq $false) {
    New-Item -Path "$PathDestination\iso" -ItemType Directory -Force
    New-Item -Path "$PathDestination\mame" -ItemType Directory -Force
  } else { Logger-Error -Message "$PathDestination already exist" }

  Logger-Info -Message "copy iso file to $PathDestination\iso"

  Copy-Item -Path $ISOFile -Destination "$PathDestination\iso"
  Copy-Item -Path $CUEFile -Destination "$PathDestination\iso"

  Logger-Info "copy chd and Mame hash file to $PathDestination\mame"
  Copy-Item -Path $CHDFile -Destination "$PathDestination\mame"
  Copy-Item -Path $HashFile -Destination "$PathDestination\mame"

  if ($Config.project.sound.cdda.tracks.track) {
    Write-Host ""
    Write-Host "copy sound tracks"
    Write-Host ""
    $content = [System.IO.File]::ReadAllText($CUEFile)
    $Config.project.sound.cdda.tracks.track | ForEach-Object {
      $fileName = Split-Path $_.file -leaf
      Logger-Info -Message "copy $fileName to $PathDestination\iso"
      Copy-Item -Path $_.file -Destination "$PathDestination\iso"
      $content = $content.Replace($_.file, $fileName)
    }
    Write-Host "make a cue file"
    $content | Out-File -FilePath "$PathDestination\iso\$ProjectName.cue" -Encoding utf8 -Force
  }
  Write-Host ""
  if (((Test-Path -Path "$PathDestination\iso\$ProjectName.cue") -eq $true) -and ((Test-Path -Path "$PathDestination\iso\$ProjectName.cue") -eq $true)) {
    Logger-Success -Message "ISO delivery is available to $pathDestination\iso"
  } else { Logger-Error -Message "iso dist failed" }

  if ((Test-Path -Path "$pathDestination\mame\$ProjectName.chd") -eq $true) {
    Logger-Success -Message "Mame delivery is available to $PathDestination\mame"
  } else { Logger-Error -Message "mame dist failed" }
}