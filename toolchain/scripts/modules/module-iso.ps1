Import-Module "$($buildConfig.pathToolchain)\scripts\modules\module-install-component.ps1"

function Write-ISO {
  param (
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $SpriteFile,
    [Parameter(Mandatory=$true)][String] $PathISOBuildFolder,
    [Parameter(Mandatory=$true)][String] $PathCDTemplate
  )
  if ((Test-Path -Path $PathCDTemplate) -eq $false) {
    Install-Component -URL "$($buildConfig.baseURL)/neobuild-cd_template.zip" -PathDownload $buildConfig.pathSpool -PathInstall $buildConfig.pathNeocore
  }
  Logger-Step -Message "compiling ISO"
  if (Test-Path -Path $PathISOBuildFolder) { Remove-Item $PathISOBuildFolder -Recurse -Force }
  if (-Not(Test-Path -Path $PathISOBuildFolder)) { mkdir -Path $PathISOBuildFolder | Out-Null }
  if (-Not(Test-Path -Path $PathCDTemplate)) { Logger-Error -Message "$PathCDTemplate not found" }
  if (-Not(Test-Path -Path $PRGFile)) { Logger-Error -Message "$PRGFile not found" }
  if (-Not(Test-Path -Path $SpriteFile)) { Logger-Error -Message "$SpriteFile not found" }
  Copy-Item -Path "$PathCDTemplate\*" -Destination $PathISOBuildFolder -Recurse -Force
  Copy-Item -Path $PRGFile -Destination "$PathISOBuildFolder\DEMO.PRG" -Force
  Copy-Item -Path $SpriteFile -Destination "$PathISOBuildFolder\DEMO.SPR" -Force

  & mkisofs.exe -o $OutputFile -pad $PathISOBuildFolder

  if ((Test-Path -Path $OutputFile) -eq $true) {
    Logger-Success -Message "builded ISO is available to $OutputFile"
    Write-Host ""
  } else { Logger-Error -Message "$OutputFile was not generated" }
}

function Write-CUE {
  param (
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $ISOName,
    [System.Xml.XmlElement] $Config
  )
  function Get-CUETrack {
    param (
      [Parameter(Mandatory=$true)][String] $File,
      [Parameter(Mandatory=$true)][int] $Index,
      [Parameter(Mandatory=$true)][String] $Pregap
    )
    return (
      'FILE "{0}" WAVE
  TRACK {1:d2} AUDIO
    PREGAP {2}
    INDEX 01 00:00:00') -f $File, $Index, $Pregap
  }

  ('FILE "{0}" BINARY ' -f $ISOName) | Out-File -Encoding utf8 -FilePath $OutputFile -Force
  "  TRACK 01 MODE1/2048 " | Out-File -Encoding utf8 -FilePath $OutputFile -Append -Force
  "    INDEX 01 00:00:00 " | Out-File -Encoding utf8 -FilePath $OutputFile -Append -Force

  if ($Config) {
    $tracks = $Config.tracks.track
    $tracks | ForEach-Object {
      Get-CUETrack -File $_.file -Index $_.id -Pregap $_.pregap | Out-File -Encoding utf8 -FilePath $OutputFile -Append -Force
    }
  }
  (Get-Content -Path $OutputFile -Raw).Replace("`r`n","`n") | Set-Content -Path $OutputFile -Force -NoNewline

  if ((Test-Path -Path $OutputFile) -eq $true) {
    Logger-Success -Message "builded CUE is available to $OutputFile"
    Write-Host ""
  } else { Logger-Error -Message "error - $OutputFile was not generated" }
}


