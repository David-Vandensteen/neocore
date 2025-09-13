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
    return $true
  } else {
    Write-Host "$OutputFile was not generated" -ForegroundColor Red
    return $false
  }
}

function Write-Cache {
  param (
    [Parameter(Mandatory=$true)][String] $PathCDTemplate,
    [Parameter(Mandatory=$true)][String] $PRGFile,
    [Parameter(Mandatory=$true)][String] $SpriteFile,
    [Parameter(Mandatory=$true)][String] $PathISOBuildFolder
  )

  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath

  if ((Test-Path -Path $PathCDTemplate) -eq $false) {
    if ($Manifest.manifest.dependencies.cdTemplate.url) {
      if (-not (Install-Component `
        -URL $Manifest.manifest.dependencies.cdTemplate.url `
        -PathDownload "$projectBuildPath\spool" `
        -PathInstall $Manifest.manifest.dependencies.cdTemplate.path)) {
        Write-Host "Failed to install CD Template component" -ForegroundColor Red
        return $false
      }
    } else {
      Write-Host "Error: CD Template not found in manifest dependencies" -ForegroundColor Red
      Write-Host "Please add cdTemplate to manifest.xml dependencies section" -ForegroundColor Yellow
      return $false
    }
  }

  if (Test-Path -Path $PathISOBuildFolder) { Remove-Item $PathISOBuildFolder -Recurse -Force }
  if (-Not(Test-Path -Path $PathISOBuildFolder)) { mkdir -Path $PathISOBuildFolder | Out-Null }
  if (-Not(Test-Path -Path $PathCDTemplate)) {
    Write-Host "$PathCDTemplate not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Test-Path -Path $PRGFile)) {
    Write-Host "$PRGFile not found" -ForegroundColor Red
    return $false
  }
  if (-Not(Test-Path -Path $SpriteFile)) {
    Write-Host "$SpriteFile not found" -ForegroundColor Red
    return $false
  }

  Copy-Item -Path "$PathCDTemplate\*" -Destination $PathISOBuildFolder -Recurse -Force -ErrorAction Stop
  Copy-Item -Path $PRGFile -Destination "$PathISOBuildFolder\DEMO.PRG" -Force -ErrorAction Stop
  Copy-Item -Path $SpriteFile -Destination "$PathISOBuildFolder\DEMO.SPR" -Force -ErrorAction Stop

  if ($Config.project.gfx.DAT.fixdata.chardata.setup.PSObject.Properties.Name -contains "charfile" -and $Config.project.gfx.DAT.fixdata.chardata.setup.charfile) {
    $fixfile = $Config.project.gfx.DAT.fixdata.chardata.setup.charfile
    Copy-Item -Path $fixfile -Destination "$PathISOBuildFolder\DEMO.FIX" -Force -ErrorAction Stop
  }

  return $true
}

function Write-SFX {
  param(
    [Parameter(Mandatory=$true)][String] $PathISOBuildFolder,
    [String] $PCMFile,
    [String] $Z80File
  )

  Write-Host "SoundFX" -ForegroundColor Yellow

  if ($PCMFile) { Write-Host $PCMFile -ForegroundColor Cyan }
  if ($Z80File) { Write-Host $Z80File -ForegroundColor Cyan }

  Write-Host "Destination folder $PathISOBuildFolder" -ForegroundColor Cyan

  if ($PCMFile) { Copy-Item -Path $PCMFile -Destination "$PathISOBuildFolder\DEMO.PCM" -Force -ErrorAction Stop }
  if ($Z80File) { Copy-Item -Path $Z80File -Destination "$PathISOBuildFolder\DEMO.Z80" -Force -ErrorAction Stop }

  return $true
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

    $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
    $buildPathProject = "$projectBuildPath\$($Config.project.name)"
    $destination = "$buildPathProject\$path"

    # Source file should be from the build folder, not project root
    $sourceFile = "$buildPathProject\$File"

    # Ensure destination directory exists
    if (-Not(Test-Path -Path $destination)) {
      New-Item -ItemType Directory -Path $destination -Force | Out-Null
    }

    # Only copy if source file exists and destination is different
    $destinationFile = "$destination\$baseName$ext"
    if (Test-Path -Path $sourceFile) {
      if ($sourceFile -ne $destinationFile) {
        Copy-Item -Path $sourceFile -Destination $destination -Force
      }
    } else {
      Write-Warning "Source file not found: $sourceFile"
    }

    if ($ext -eq ".mp3" -or ($ext -eq ".wav" -and $ConfigCDDA.dist.iso.format -eq ".mp3")) {
      if ((Test-Path -Path "$projectBuildPath\bin\mpg123-1.31.3-static-x86-64") -eq $false) {
        if ($Manifest.manifest.dependencies.mpg123.url) {
          if (-not (Install-Component `
          -URL $Manifest.manifest.dependencies.mpg123.url `
          -PathDownload "$projectBuildPath\spool" `
          -PathInstall $Manifest.manifest.dependencies.mpg123.path)) {
            Write-Host "Failed to install mpg123 component" -ForegroundColor Red
            return $false
          }
        } else {
          Write-Host "Error: mpg123 not found in manifest dependencies" -ForegroundColor Red
          Write-Host "Please add mpg123 to manifest.xml dependencies section" -ForegroundColor Yellow
          return $false
        }
      }
    }

    if (-Not($Rule -like "*dist*")) {
      if ($ext -eq ".wav") {
        Write-Host "copy $File" -ForegroundColor Cyan
        Copy-Item -Path "$buildPathProject\$path\$baseName$ext" -Destination $path\$baseName$ext
      }

      if ($ext -eq ".mp3") {
        Write-WAV `
          -mpg123 "$projectBuildPath\bin\mpg123-1.31.3-static-x86-64\mpg123.exe" `
          -WAVFile "$buildPathProject\$path\$baseName.wav" `
          -MP3File "$path\$baseName.mp3"
        $File = "$path\$baseName.wav"
      }
    }

    if ($Rule -eq "dist:exe" -and $ext -eq ".mp3") {
      Write-WAV `
        -mpg123 "$projectBuildPath\bin\mpg123-1.31.3-static-x86-64\mpg123.exe" `
        -WAVFile "$buildPathProject\$path\$baseName.wav" `
        -MP3File "$path\$baseName.mp3"
      $File = "$path\$baseName.wav"
    }

    if ($Rule -eq "dist:mame" -and $ext -eq ".mp3") {
      Write-WAV `
        -mpg123 "$projectBuildPath\bin\mpg123-1.31.3-static-x86-64\mpg123.exe" `
        -WAVFile "$buildPathProject\$path\$baseName.wav" `
        -MP3File "$path\$baseName.mp3"
      $File = "$path\$baseName.wav"
    }

    if ($Rule -eq "dist:exe" -and $ext -eq ".wav") {
      Write-Host "copy $File" -ForegroundColor Cyan
      Copy-Item -Path "$buildPathProject\$path\$baseName$ext" -Destination $path\$baseName$ext
    }

    if ($Rule -eq "dist:mame" -and $ext -eq ".wav") {
      Write-Host "copy $File" -ForegroundColor Cyan
      Copy-Item -Path "$buildPathProject\$path\$baseName$ext" -Destination $path\$baseName$ext
    }

    if ($Rule -like "dist:iso") {
      if ($ext -eq ".mp3" -and $ConfigCDDA.dist.iso.format -eq "wav") {
        Write-WAV `
          -mpg123 "$projectBuildPath\bin\mpg123-1.31.3-static-x86-64\mpg123.exe" `
          -WAVFile "$buildPathProject\$path\$baseName.wav" `
          -MP3File "$path\$baseName.mp3"
        $File = "$path\$baseName.wav"
      }

      if ($ext -eq ".wav" -and $ConfigCDDA.dist.iso.format -eq "wav") {
        Write-Host "copy $File" -ForegroundColor Cyan
        Copy-Item -Path "$buildPathProject\$path\$baseName$ext" -Destination $path\$baseName$ext
      }

      if ($ext -eq ".wav" -and $ConfigCDDA.dist.iso.format -eq "mp3") {
        # Search for ffmpeg executable in bin folder or its subdirectories
        $ffmpegPath = Get-ChildItem -Path "$projectBuildPath\bin" -Name "ffmpeg.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($ffmpegPath) {
          $ffmpegExe = Join-Path "$projectBuildPath\bin" $ffmpegPath
        } else {
          $ffmpegExe = "$projectBuildPath\bin\ffmpeg.exe"
        }

        # Download ffmpeg if not found
        if (-Not(Test-Path -Path $ffmpegExe)) {
          if ($Manifest.manifest.dependencies.ffmpeg.url) {
            if (-not (Install-Component `
              -URL $Manifest.manifest.dependencies.ffmpeg.url `
              -PathDownload "$projectBuildPath\spool" `
              -PathInstall (Get-TemplatePath -Path $Manifest.manifest.dependencies.ffmpeg.path))) {
              Write-Host "Failed to install ffmpeg component" -ForegroundColor Red
              return $false
            }
          } else {
            Write-Host "Error: ffmpeg not found in manifest dependencies" -ForegroundColor Red
            Write-Host "Please add ffmpeg to manifest.xml dependencies section" -ForegroundColor Yellow
            return $false
          }

          # Re-search for ffmpeg after installation
          $ffmpegPath = Get-ChildItem -Path "$projectBuildPath\bin" -Name "ffmpeg.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
          if ($ffmpegPath) {
            $ffmpegExe = Join-Path "$projectBuildPath\bin" $ffmpegPath
          } else {
            $ffmpegExe = "$projectBuildPath\bin\ffmpeg.exe"
          }
        }

        # Create destination directory if necessary
        $destinationDir = Split-Path -Path "$buildPathProject\$path\$baseName.mp3" -Parent
        if (-Not(Test-Path -Path $destinationDir)) {
          New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
        }

        Write-MP3 `
          -ffmpeg $ffmpegExe `
          -WAVFile "$buildPathProject\$path\$baseName.wav" `
          -MP3File "$buildPathProject\$path\$baseName.mp3"
        $File = "$buildPathProject\$path\$baseName.mp3"
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
    return $true
  } else {
    Write-Host "$OutputFile was not generated" -ForegroundColor Red
    return $false
  }
}
