function Update-RaineConfigSwitch {
  Write-Host "Switching Raine config" -ForegroundColor Yellow
  if ($Rule -like "run:raine:*") {
    $raineConfigName = $Rule.Split(":")[2]
  } else {
    $raineConfigName = "default"
  }

  Write-Host "Using $raineConfigName config" -ForegroundColor Yellow
  if ($Rule -like "run:raine:*") {
    if (-Not($Config.project.emulator.raine.config.$raineConfigName)) {
      Write-Host "Error - $raineConfigName not found in project.emulator.raine.config" -ForegroundColor Red
      exit 1
    }
    $raineConfig = Resolve-TemplatePath -Path $Config.project.emulator.raine.config.$raineConfigName
  } else {
    $raineConfig = Resolve-TemplatePath -Path "$($Config.project.buildPath)\raine\config\default.cfg"
  }

  if (-Not(Test-Path -Path $raineConfig)) {
    Write-Host "Error - $raineConfig not found" -ForegroundColor Red
    exit 1
  }

  Write-Host "Copying $raineConfig to $rainePath\config\raine32_sdl.cfg"
  Copy-Item $raineConfig $rainePath\config\raine32_sdl.cfg -Force
}

function Invoke-Raine {
  param (
    [Parameter(Mandatory=$true)][String] $FileName,
    [Parameter(Mandatory=$true)][String] $PathISO,
    [Parameter(Mandatory=$true)][String] $PathRaine,
    [Parameter(Mandatory=$true)][String] $ExeName
  )
  if ((Test-Path -Path "$PathISO\$FileName") -eq $false) {
    Write-Host "$FileName not found" -ForegroundColor Red
    exit 1
  }
  if ((Test-Path -Path $PathRaine) -eq $false) {
    if ($Manifest.manifest.dependencies.raine.url) {
      Install-Component `
        -URL $Manifest.manifest.dependencies.raine.url `
        -PathDownload "$($Config.project.buildPath)\spool" `
        -PathInstall $Manifest.manifest.dependencies.raine.path
    } else {
      Install-Component -URL "$BaseURL/neobuild-raine.zip" -PathDownload "$($Config.project.buildPath)\spool" -PathInstall $Config.project.buildPath
    }
    Install-RaineConfig -Path $PathRaine
  }
  Assert-RaineConfig
  Update-RaineConfigSwitch
  Write-Host "Launching raine $FileName" -ForegroundColor Yellow
  $pathRaineAbs = (Resolve-Path -Path $PathRaine).Path
  Push-Location -Path $PathISO
  & "$pathRaineAbs\$ExeName" $FileName
  Pop-Location
}

function Start-Raine {
  $exeName = [System.IO.Path]::GetFileName($Config.project.emulator.raine.exeFile)
  $rainePath = Split-Path $Config.project.emulator.raine.exeFile
  $rainePath = Get-TemplatePath -Path $rainePath

  Invoke-Raine `
    -FileName "$($Config.project.name).cue" `
    -PathRaine $rainePath `
    -PathISO "$($Config.project.buildPath)\$($Config.project.name)" `
    -ExeName $exeName
}
