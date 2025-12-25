function Install-BiosForRaine {
  Write-Host "Checking BIOS for Raine..." -ForegroundColor Yellow
  
  if (-Not($Manifest.manifest.dependencies.biosForRaine.url)) {
    Write-Host "Warning: biosForRaine not found in manifest dependencies" -ForegroundColor Yellow
    return $true
  }
  
  $biosPath = Resolve-TemplatePath -Path $Manifest.manifest.dependencies.biosForRaine.path
  $biosBinFile = Join-Path $biosPath "neocd.bin"
  
  # Check if BIOS file already exists
  if (Test-Path -Path $biosBinFile) {
    Write-Host "BIOS for Raine already installed at $biosPath" -ForegroundColor Green
    return $true
  }
  
  Write-Host "Installing BIOS for Raine..." -ForegroundColor Yellow
  Install-Component `
    -URL $Manifest.manifest.dependencies.biosForRaine.url `
    -PathDownload $Config.project.buildPath `
    -PathInstall $Manifest.manifest.dependencies.biosForRaine.path
  
  Write-Host "BIOS for Raine installed successfully" -ForegroundColor Green
  return $true
}

function Install-Raine {
  param (
    [Parameter(Mandatory=$true)][String] $PathRaine
  )
  
  Write-Host "Raine not found at $PathRaine, installing..." -ForegroundColor Yellow
  
  if ($Manifest.manifest.dependencies.raine.url) {
    Install-Component `
      -URL $Manifest.manifest.dependencies.raine.url `
      -PathDownload "$($Config.project.buildPath)\spool" `
      -PathInstall $Manifest.manifest.dependencies.raine.path
    
    # Move raine64 folder from spool to build directory and rename to raine
    $buildPathResolved = Resolve-TemplatePath -Path $Config.project.buildPath
    $raineSourcePath = "$buildPathResolved\spool\raine64-0.97.5\raine64"
    $raineDestPath = "$buildPathResolved\raine"
    Write-Host "Checking source path: $raineSourcePath" -ForegroundColor Cyan
    Write-Host "Target path: $raineDestPath" -ForegroundColor Cyan
    
    if (Test-Path -Path $raineSourcePath) {
      Write-Host "Source path exists, proceeding with move..." -ForegroundColor Yellow
      if (Test-Path -Path $raineDestPath) {
        Write-Host "Removing existing raine folder..." -ForegroundColor Yellow
        Remove-Item -Path $raineDestPath -Recurse -Force
      }
      Move-Item -Path $raineSourcePath -Destination $raineDestPath -Force
      Write-Host "Moved raine64 from spool to build\raine" -ForegroundColor Green
    } else {
      Write-Host "Warning: Source path $raineSourcePath does not exist!" -ForegroundColor Red
      return $false
    }
    
    Install-RaineConfig -Path $PathRaine
    
    if (-Not(Install-BiosForRaine)) {
      Write-Host "Failed to install BIOS for Raine" -ForegroundColor Red
      return $false
    }
    
    if (-Not(Update-RaineConfigSwitch -PathRaine $PathRaine)) {
      Write-Host "Failed to update Raine config" -ForegroundColor Red
      return $false
    }
    
    return $true
  } else {
    Write-Host "Error: Raine not found in manifest dependencies" -ForegroundColor Red
    Write-Host "Please add raine to manifest.xml dependencies section" -ForegroundColor Yellow
    return $false
  }
}
