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
    return $false
  }
  if ($CUEFile -and (Test-Path -Path $CUEFile) -eq $false) {
    Write-Host "$CUEFile not found" -ForegroundColor Red
    return $false
  }
  if ($CHDFile -and (Test-Path -Path $CHDFile) -eq $false) {
    Write-Host "$CHDFile not found" -ForegroundColor Red
    return $false
  }
  if ($HashFile -and (Test-Path -Path $HashFile) -eq $false) {
    Write-Host "$HashFile not found" -ForegroundColor Red
    return $false
  }

  # Always use cd subfolder structure
  $hasCD = $true

  if ($ISOFile) {
    $isoPath = if ($hasCD) { "$PathDestination\cd\iso" } else { "$PathDestination\iso" }
    if ((Test-Path -Path "$isoPath\$ProjectName.iso") -eq $false) {
      New-Item -Path $isoPath -ItemType Directory -Force
    } else {
      Write-Host "$isoPath\$ProjectName.iso already exists" -ForegroundColor Yellow
      $response = Read-Host "Do you want to overwrite it? (y/N)"
      if ($response -ne 'y' -and $response -ne 'Y') {
        Write-Host "Operation cancelled by user" -ForegroundColor Red
        return $false
      }
      Write-Host "Overwriting existing ISO file..." -ForegroundColor Yellow
    }
  }
  if ($CHDFile) {
    $mamePath = if ($hasCD) { "$PathDestination\cd\mame" } else { "$PathDestination\mame" }
    if ((Test-Path -Path "$mamePath\$ProjectName.chd") -eq $false) {
      New-Item -Path $mamePath -ItemType Directory -Force
    } else {
      Write-Host "$mamePath\$ProjectName.chd already exists" -ForegroundColor Yellow
      $response = Read-Host "Do you want to overwrite it? (y/N)"
      if ($response -ne 'y' -and $response -ne 'Y') {
        Write-Host "Operation cancelled by user" -ForegroundColor Red
        return $false
      }
      Write-Host "Overwriting existing CHD file..." -ForegroundColor Yellow
    }
  }
  if ($ISOFile) {
    $isoPath = if ($hasCD) { "$PathDestination\cd\iso" } else { "$PathDestination\iso" }
    Write-Host "Copy iso file $isoPath" -ForegroundColor Cyan
    Copy-Item -Path $ISOFile -Destination $isoPath
    Copy-Item -Path $CUEFile -Destination $isoPath
  }

  if ($CHDFile) {
    $mamePath = if ($hasCD) { "$PathDestination\cd\mame" } else { "$PathDestination\mame" }
    Write-Host "Copy chd file $mamePath" -ForegroundColor Cyan
    Copy-Item -Path $CHDFile -Destination $mamePath
    Copy-Item -Path $HashFile -Destination $mamePath
  }

  if ($Config.project.sound.cd.cdda.tracks.track) {
    $cddaTracks = $Config.project.sound.cd.cdda.tracks.track
    $cddaConfig = $Config.project.sound.cd.cdda
  }

  if ($ISOFile -and $cddaTracks) {
    Write-Host ""
    Write-Host "copy sound tracks" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "CUE file : $CUEFile"
    $content = [System.IO.File]::ReadAllText($CUEFile)
    $cddaTracks | ForEach-Object {
      $file = $_.file

      $fileName = Split-Path -Path $file -Leaf -Resolve
      $filePath = Split-Path -Path $file
      $fileExt = [System.IO.Path]::GetExtension($File)

      if ($Rule -eq "dist:iso" ) {
        $ext = $cddaConfig.dist.iso.format
      } else {
        $ext = "wav"
      }

      $fileNameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($fileName)

      # Resolve template path for buildPath
      $resolvedBuildPath = Get-TemplatePath -Path $Config.project.buildPath
      # Resolve template path for distPath
      $resolvedDistPath = Get-TemplatePath -Path $Config.project.distPath

      $source = Join-Path `
                  -Path $resolvedBuildPath `
                  -ChildPath "$($Config.project.name)\$($filePath)\$($fileNameWithoutExt).$ext"

      # Adjust destination path based on distribution type and CD content
      $distSubPath = if ($Rule -eq "dist:iso") {
        if ($hasCD) { "cd\iso" } else { "iso" }
      } elseif ($Rule -eq "dist:mame") {
        if ($hasCD) { "cd\mame" } else { "mame" }
      } else {
        "iso"
      }

      $destination = Join-Path `
                      -Path $resolvedDistPath `
                      -ChildPath "$($Config.project.name)\$($Config.project.name)-$($Config.project.version)\$distSubPath"

      Copy-Item -Path $source -Destination $destination

      $content = $content.Replace("$($filePath)\$($fileNameWithoutExt).wav", "$($fileNameWithoutExt).$ext")
      $content = $content.Replace("$($filePath)\$($fileNameWithoutExt).mp3", "$($fileNameWithoutExt).$ext")
    }
    Write-Host "make the cue file" -ForegroundColor Cyan
    Write-Host $content
    $isoPath = if ($hasCD) { "$PathDestination\cd\iso" } else { "$PathDestination\iso" }
    $content | Out-File -FilePath "$isoPath\$ProjectName.cue" -Encoding ascii -Force
  }
  Write-Host ""
  if ($ISOFile) {
    $isoPath = if ($hasCD) { "$PathDestination\cd\iso" } else { "$PathDestination\iso" }
    if (((Test-Path -Path "$isoPath\$ProjectName.cue") -eq $true) -and ((Test-Path -Path "$isoPath\$ProjectName.iso") -eq $true)) {
      Write-Host "ISO delivery $isoPath" -ForegroundColor Green
    } else {
      Write-Host "ISO dist failed" -ForegroundColor Red
      return $false
    }
  }

  if ($CHDFile) {
    $mamePath = if ($hasCD) { "$PathDestination\cd\mame" } else { "$PathDestination\mame" }
    if ((Test-Path -Path "$mamePath\$ProjectName.chd") -eq $true) {
      Write-Host "Mame delivery $mamePath" -ForegroundColor Green
    } else {
      Write-Host "Mame dist failed" -ForegroundColor Red
      return $false
    }
  }

  # Distribution completed successfully
  return $true
}