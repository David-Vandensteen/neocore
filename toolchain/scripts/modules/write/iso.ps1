function Write-ISO {
  param (
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $SpriteFile,
    [Parameter(Mandatory=$true)][String] $PathISOBuildFolder,
    [Parameter(Mandatory=$true)][String] $PathCDTemplate
  )

  Write-Host "Compiling ISO $OutputFile" -ForegroundColor Yellow

  & mkisofs.exe -o $OutputFile -pad $PathISOBuildFolder

  if ((Test-Path -Path $OutputFile) -eq $true) {
    Write-Host "Builded ISO $OutputFile" -ForegroundColor Green
    Write-Host ""
  } else {
    Write-Host "$OutputFile was not generated" -ForegroundColor Red
    exit 1
  }
}

function Write-Cache {
  param (
    [Parameter(Mandatory=$true)][String] $PathCDTemplate,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $SpriteFile,
    [Parameter(Mandatory=$true)][String] $PathISOBuildFolder
  )

  if ((Test-Path -Path $PathCDTemplate) -eq $false) {
    if ($Manifest.manifest.dependencies.cdTemplate.url) {
      Install-Component `
        -URL $Manifest.manifest.dependencies.cdTemplate.url `
        -PathDownload "$($Config.project.buildPath)\spool" `
        -PathInstall $Manifest.manifest.dependencies.cdTemplate.path
    } else {
      Install-Component -URL "$BaseURL/neobuild-cd_template.zip" -PathDownload "$($Config.project.buildPath)\spool" -PathInstall $Config.project.buildPath
    }
  }

  if (Test-Path -Path $PathISOBuildFolder) { Remove-Item $PathISOBuildFolder -Recurse -Force }
  if (-Not(Test-Path -Path $PathISOBuildFolder)) { mkdir -Path $PathISOBuildFolder | Out-Null }
  if (-Not(Test-Path -Path $PathCDTemplate)) {
    Write-Host "$PathCDTemplate not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $PRGFile)) {
    Write-Host "$PRGFile not found" -ForegroundColor Red
    exit 1
  }
  if (-Not(Test-Path -Path $SpriteFile)) {
    Write-Host "$SpriteFile not found" -ForegroundColor Red
    exit 1
  }

  Copy-Item -Path "$PathCDTemplate\*" -Destination $PathISOBuildFolder -Recurse -Force -ErrorAction Stop
  Copy-Item -Path $PRGFile -Destination "$PathISOBuildFolder\DEMO.PRG" -Force -ErrorAction Stop
  Copy-Item -Path $SpriteFile -Destination "$PathISOBuildFolder\DEMO.SPR" -Force -ErrorAction Stop
}

function Write-SFX {
  param(
    [Parameter(Mandatory=$true)][String] $PathISOBuildFolder,
    [String] $PCMFile,
    [String] $Z80File
  )

  Write-Host "SoundFX" -ForegroundColor Yellow

  if ($PCMFile) { Write-Host $PCMFile -ForegroundColor Blue }
  if ($Z80File) { Write-Host $Z80File -ForegroundColor Blue }

  Write-Host "Destination folder $PathISOBuildFolder" -ForegroundColor Blue

  if ($PCMFile) { Copy-Item -Path $PCMFile -Destination "$PathISOBuildFolder\DEMO.PCM" -Force -ErrorAction Stop }
  if ($Z80File) { Copy-Item -Path $Z80File -Destination "$PathISOBuildFolder\DEMO.Z80" -Force -ErrorAction Stop }
}

function Write-CUE {
  param (
    [Parameter(Mandatory=$true)][String] $Rule,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $ISOName,
    [System.Xml.XmlElement] $ConfigCDDA
  )

  function Get-CUETrack {
    param (
      [Parameter(Mandatory=$true)][String] $Rule,
      [Parameter(Mandatory=$true)][String] $File,
      [Parameter(Mandatory=$true)][int] $Index,
      [Parameter(Mandatory=$true)][String] $Pregap
    )

    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($File)
    $ext = [System.IO.Path]::GetExtension($File)
    $path = [System.IO.Path]::GetDirectoryName($File)

    $destination = "$($Config.project.buildPath)\$($Config.project.name)\$path"

    Copy-Item -Path $File -Destination $destination

    if ($ext -eq ".mp3" -or ($ext -eq ".wav" -and $ConfigCDDA.dist.iso.format -eq ".mp3")) {
      if ((Test-Path -Path "$($Config.project.buildPath)\bin\mpg123-1.31.3-static-x86-64") -eq $false) {
        if ($Manifest.manifest.dependencies.mpg123.url) {
          Install-Component `
          -URL $Manifest.manifest.dependencies.mpg123.url `
          -PathDownload "$($Config.project.buildPath)\spool" `
          -PathInstall $Manifest.manifest.dependencies.mpg123.path
        } else {
          Install-Component `
          -URL "$BaseURL/mpg123-1.31.3-static-x86-64.zip" `
          -PathDownload "$($Config.project.buildPath)\spool" `
          -PathInstall "$($Config.project.buildPath)\bin"
        }
      }
    }

    if (-Not($Rule -like "*dist*")) {
      $buildPathProject = "$($Config.project.buildPath)\$($Config.project.name)"
      if ($ext -eq ".wav") {
        Write-Host "copy $File" -ForegroundColor Blue
        Copy-Item -Path "$buildPathProject\$path\$baseName$ext" -Destination $path\$baseName$ext
      }

      if ($ext -eq ".mp3") {
        Write-WAV `
          -mpg123 "$($Config.project.buildPath)\bin\mpg123-1.31.3-static-x86-64\mpg123.exe" `
          -WAVFile "$buildPathProject\$path\$baseName.wav" `
          -MP3File "$path\$baseName.mp3"
        $File = "$path\$baseName.wav"
      }
    }

    if ($Rule -eq "dist:exe" -and $ext -eq ".mp3") {
      Write-WAV `
        -mpg123 "$($Config.project.buildPath)\bin\mpg123-1.31.3-static-x86-64\mpg123.exe" `
        -WAVFile "$buildPathProject\$path\$baseName.wav" `
        -MP3File "$path\$baseName.mp3"
      $File = "$path\$baseName.wav"
    }

    if ($Rule -eq "dist:mame" -and $ext -eq ".mp3") {
      Write-WAV `
        -mpg123 "$($Config.project.buildPath)\bin\mpg123-1.31.3-static-x86-64\mpg123.exe" `
        -WAVFile "$buildPathProject\$path\$baseName.wav" `
        -MP3File "$path\$baseName.mp3"
      $File = "$path\$baseName.wav"
    }

    if ($Rule -eq "dist:exe" -and $ext -eq ".wav") {
      Write-Host "copy $File" -ForegroundColor Blue
      Copy-Item -Path "$buildPathProject\$path\$baseName$ext" -Destination $path\$baseName$ext
    }

    if ($Rule -eq "dist:mame" -and $ext -eq ".wav") {
      Write-Host "copy $File" -ForegroundColor Blue
      Copy-Item -Path "$buildPathProject\$path\$baseName$ext" -Destination $path\$baseName$ext
    }

    if ($Rule -like "dist:iso") {
      if ($ext -eq ".mp3" -and $ConfigCDDA.dist.iso.format -eq "wav") {
        Write-WAV `
          -mpg123 "$($Config.project.buildPath)\bin\mpg123-1.31.3-static-x86-64\mpg123.exe" `
          -WAVFile "$buildPathProject\$path\$baseName.wav" `
          -MP3File "$path\$baseName.mp3"
        $File = "$path\$baseName.wav"
      }

      if ($ext -eq ".wav" -and $ConfigCDDA.dist.iso.format -eq "wav") {
        Write-Host "copy $File" -ForegroundColor Blue
        Copy-Item -Path "$buildPathProject\$path\$baseName$ext" -Destination $path\$baseName$ext
      }

      if ($ext -eq ".wav" -and $ConfigCDDA.dist.iso.format -eq "mp3") {
        if ((Test-Path -Path "$($Config.project.buildPath)\bin\ffmpeg.exe") -eq $false) {
          if ($Manifest.manifest.dependencies.ffmpeg.url) {
              Install-Component `
                -URL $Manifest.manifest.dependencies.ffmpeg.url `
                -PathDownload "$($Config.project.buildPath)\spool" `
                -PathInstall $Manifest.manifest.dependencies.ffmpeg.url
            } else {
              Install-Component `
                -URL "$BaseURL/ffmpeg-23-12-18.zip" `
                -PathDownload "$($Config.project.buildPath)\spool" `
                -PathInstall "$($Config.project.buildPath)\bin"
            }
        }

        Write-MP3 `
          -ffmpeg "$($Config.project.buildPath)\bin\ffmpeg.exe" `
          -WAVFile "$path\$baseName.wav" `
          -MP3File "$buildPathProject\$path\$baseName.mp3"
        $File = "$path\$baseName.wav"
      }
    }

    return (
      'FILE "{0}" WAVE
  TRACK {1:d2} AUDIO
    PREGAP {2}
    INDEX 01 00:00:00') -f $File, $Index, $Pregap
  }

  ('FILE "{0}" BINARY ' -f $ISOName) | Out-File -Encoding utf8 -FilePath $OutputFile -Force
  "  TRACK 01 MODE1/2048 " | Out-File -Encoding utf8 -FilePath $OutputFile -Append -Force
  "    INDEX 01 00:00:00 " | Out-File -Encoding utf8 -FilePath $OutputFile -Append -Force

  if ($ConfigCDDA) {
    $tracks = $ConfigCDDA.tracks.track
    $tracks | ForEach-Object {
      Get-CUETrack `
        -Rule $Rule `
        -File $_.file `
        -Index $_.id `
        -Pregap $_.pregap | Out-File -Encoding ascii -FilePath $OutputFile -Append -Force
    }
  }

  (Get-Content -Path $OutputFile -Raw).replace("`r`n","`n") | Set-Content -Path "$OutputFile.spool" -Force -NoNewline
  Copy-Item -Path "$OutputFile.spool" -Destination $OutputFile -Force
  Remove-Item -Path "$OutputFile.spool" -Force

  if ((Test-Path -Path $OutputFile) -eq $true) {
    Write-Host "Builded CUE $OutputFile" -ForegroundColor Green
    Write-Host ""
  } else {
    Write-Host "$OutputFile was not generated" -ForegroundColor Red
    exit 1
  }
}
