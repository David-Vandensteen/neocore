function Write-Dist {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $PathDestination,
    [String] $ISOFile,
    [String] $CUEFile,
    [String] $CHDFile,
    [String] $HashFile
  )
  Write-Host "Create dist for $ProjectName" -ForegroundColor Yellow

  if ($ISOFile -and (Test-Path -Path $ISOFile) -eq $false) {
    Write-Host "$ISOFile not found" -ForegroundColor Red
    exit 1
  }
  if ($CUEFile -and (Test-Path -Path $CUEFile) -eq $false) {
    Write-Host "$CUEFile not found" -ForegroundColor Red
    exit 1
  }
  if ($CHDFile -and (Test-Path -Path $CHDFile) -eq $false) {
    Write-Host "$CHDFile not found" -ForegroundColor Red
    exit 1
  }
  if ($HashFile -and (Test-Path -Path $HashFile) -eq $false) {
    Write-Host "$HashFile not found" -ForegroundColor Red
    exit 1
  }

  if ($ISOFile) {
    if ((Test-Path -Path "$PathDestination\iso\$ProjectName.iso") -eq $false) {
      New-Item -Path "$PathDestination\iso" -ItemType Directory -Force
    } else {
      Write-Host "$PathDestination\iso\$ProjectName.iso already exist" -ForegroundColor Red
      exit 1
    }
  }
  if ($CHDFile) {
    if ((Test-Path -Path "$PathDestination\mame\$CHDFile.chd") -eq $false) {
      New-Item -Path "$PathDestination\mame" -ItemType Directory -Force
    } else {
      Write-Host "$PathDestination\mame\$ProjectName.chd already exist" -ForegroundColor Red
      exit 1
    }
  }
  if ($ISOFile) {
    Write-Host "Copy iso file $PathDestination\iso" -ForegroundColor Blue
    Copy-Item -Path $ISOFile -Destination "$PathDestination\iso"
    Copy-Item -Path $CUEFile -Destination "$PathDestination\iso"
  }

  if ($CHDFile) {
    Write-Host "Copy chd file $PathDestination\mame" -ForegroundColor Blue
    Copy-Item -Path $CHDFile -Destination "$PathDestination\mame"
    Copy-Item -Path $HashFile -Destination "$PathDestination\mame"
  }

  if ($ISOFile -and $Config.project.sound.cdda.tracks.track) {
    Write-Host ""
    Write-Host "copy sound tracks" -ForegroundColor Blue
    Write-Host ""
    Write-Host "CUE file : $CUEFile"
    $content = [System.IO.File]::ReadAllText($CUEFile)
    $Config.project.sound.cdda.tracks.track | ForEach-Object {
      $file = $_.file

      $fileName = Split-Path -Path $file -Leaf -Resolve
      $filePath = Split-Path -Path $file
      $fileExt = [System.IO.Path]::GetExtension($File)

      if ($buildConfig.rule -eq "dist:iso" ) {
        $ext = $Config.project.sound.cdda.dist.iso.format
      } else {
        $ext = "wav"
      }

      $fileNameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($fileName)

      $source = Join-Path `
                  -Path $Config.project.buildPath `
                  -ChildPath "$($Config.project.name)\$($filePath)\$($fileNameWithoutExt).$ext"

      $destination = Join-Path `
                      -Path $Config.project.distPath `
                      -ChildPath "$($Config.project.name)\$($Config.project.name)-$($Config.project.version)\iso"

      Copy-Item -Path $source -Destination $destination

      $content = $content.Replace("$($filePath)\$($fileNameWithoutExt).wav", "$($fileNameWithoutExt).$ext")
      $content = $content.Replace("$($filePath)\$($fileNameWithoutExt).mp3", "$($fileNameWithoutExt).$ext")
    }
    Write-Host "make the cue file" -ForegroundColor Blue
    Write-Host $content
    $content | Out-File -FilePath "$PathDestination\iso\$ProjectName.cue" -Encoding ascii -Force
  }
  Write-Host ""
  if ($ISOFile) {
    if (((Test-Path -Path "$PathDestination\iso\$ProjectName.cue") -eq $true) -and ((Test-Path -Path "$PathDestination\iso\$ProjectName.cue") -eq $true)) {
      Write-Host "ISO delivery $pathDestination\iso" -ForegroundColor Green
    } else {
      Write-Host "ISO dist failed" -ForegroundColor Red
      exit 1
    }
  }

  if ($CHDFile) {
    if ((Test-Path -Path "$pathDestination\mame\$ProjectName.chd") -eq $true) {
      Write-Host "Mame delivery $PathDestination\mame" -ForegroundColor Green
    } else {
      Write-Host "Mame dist failed" -ForegroundColor Red
      exit 1
    }
  }
}