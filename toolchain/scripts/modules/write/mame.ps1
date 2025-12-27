function Write-MameHash {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $CHDFile,
    [Parameter(Mandatory=$true)][String] $XMLFile
  )
  function Get-CHDSHA1 {
    param (
      [Parameter(Mandatory=$true)][String] $File,
      [Parameter(Mandatory=$true)][String] $PathMame
    )
    $chdmanPath = Join-Path $PathMame "chdman.exe"
    if ((Test-Path -Path $chdmanPath) -eq $false) {
      Write-Host "[ERROR] chdman.exe not found: $chdmanPath" -ForegroundColor Red
      Write-Host "Check that the path is correctly resolved (e.g. build/mame/chdman.exe) and that the file really exists." -ForegroundColor Yellow
      return $null
    }
    $r = (& $chdmanPath info -i $File) | Select-Object -Index 11
    $r = $r.Split(":")[1].trim()
    return $r
  }
  function Write-MameHashFile {
    param (
      [Parameter(Mandatory=$true)][String] $ProjectName,
      [Parameter(Mandatory=$true)][String] $XMLFile,
      [Parameter(Mandatory=$true)][String] $SHA1
    )
    if (Test-Path -Path $XMLFile) { Remove-Item -Path $XMLFile -Force }
    Set-Content -Path $XMLFile -Value '<?xml version="1.0"?>'
    Add-Content -Path $XMLFile -Value '<!-- THIS FILE IS GENERATED JUST IN TIME BY NEOCORE -->'
    Add-Content -Path $XMLFile -Value '<!DOCTYPE softwarelist SYSTEM "softwarelist.dtd">'
    Add-Content -Path $XMLFile -Value '<softwarelist name="neocd" description="SNK NeoGeo CD CD-ROMs">'
    Add-Content -Path $XMLFile -Value "<software name=`"$ProjectName`">"
    Add-Content -Path $XMLFile -Value "<description>$ProjectName</description>"
    Add-Content -Path $XMLFile -Value '<year>1995</year>'
    Add-Content -Path $XMLFile -Value "<publisher>$ProjectName</publisher>"
    Add-Content -Path $XMLFile -Value "<info name=`"alt_title`" value=`"$ProjectName`" />"
    Add-Content -Path $XMLFile -Value '<info name="serial" value="NGCD-583 (JPN)" />'
    Add-Content -Path $XMLFile -Value '<info name="release" value="59950502 (JPN)" />'
    Add-Content -Path $XMLFile -Value '<part name="cdrom" interface="neocd_cdrom">'
    Add-Content -Path $XMLFile -Value '<diskarea name="cdrom">'
    Add-Content -Path $XMLFile -Value "<disk name=`"$ProjectName`" sha1=`"$SHA1`"/>"
    Add-Content -Path $XMLFile -Value '</diskarea>'
    Add-Content -Path $XMLFile -Value '</part>'
    Add-Content -Path $XMLFile -Value '</software>'
    Add-Content -Path $XMLFile -Value '</softwarelist>'
  }

  # Support both <path> and <exeFile> in <mame>
  if ($Config.project.emulator.mame.path) {
    $PathMameResolved = Get-TemplatePath -Path $Config.project.emulator.mame.path
  } elseif ($Config.project.emulator.mame.exeFile) {
    $PathMameResolved = Split-Path (Get-TemplatePath -Path $Config.project.emulator.mame.exeFile)
  } else {
    throw "No valid MAME emulator path or exeFile found in project.xml"
  }
  $SHA1 = Get-CHDSHA1 -File $CHDFile -PathMame $PathMameResolved
  Write-MameHashFile -ProjectName $ProjectName -XMLFile $XMLFile -SHA1 $SHA1

  return $true
}

function Write-Mame {
  param (
    [Parameter(Mandatory=$true)][String] $ProjectName,
    [Parameter(Mandatory=$true)][String] $PathMame,
    [Parameter(Mandatory=$true)][String] $CUEFile,
    [Parameter(Mandatory=$true)][String] $OutputFile
  )
  if ((Test-Path -Path $PathMame) -eq $false) {
    if ($Manifest.manifest.dependencies.mame.url) {
      if (-not (Install-Component `
        -URL $Manifest.manifest.dependencies.mame.url `
        -PathDownload "$($Config.project.buildPath)\spool" `
        -PathInstall $Manifest.manifest.dependencies.mame.path)) {
        Write-Host "Failed to install MAME component" -ForegroundColor Red
        return $false
      }
      
      # Install ngdev plugin after MAME installation
      if (-not (Install-MamePluginsNgdev -PathMame $PathMame)) {
        Write-Host "Failed to install MAME ngdev plugin" -ForegroundColor Red
        return $false
      }
    } else {
      Write-Host "Error: MAME not found in manifest dependencies" -ForegroundColor Red
      Write-Host "Please add mame to manifest.xml dependencies section" -ForegroundColor Yellow
      return $false
    }
  }

  if ((Test-Path -Path $PathMame) -eq $false) { Write-Host "error - $PathMame not found" -ForegroundColor Red; return $false }
  if ((Test-Path -Path $CUEFile) -eq $false) { Write-Host "error - $CUEFile not found" -ForegroundColor Red; return $false }
  $chdmanPath = Join-Path $PathMame "chdman.exe"
  if ((Test-Path -Path $chdmanPath) -eq $false) { Write-Host "error - $chdmanPath is not found" -ForegroundColor Red; return $false }
  if ((Test-Path -Path (Join-Path $PathMame $Config.project.emulator.mame.exe)) -eq $false) { Write-Host "error - $($Config.project.emulator.mame.exe) is not found in $PathMame" -ForegroundColor Red; return $false }

  Write-Host "Compiling CHD" -ForegroundColor Yellow

  if ($Rule -eq "dist:mame" -or $Rule -eq "dist:exe") {
    Start-Process -NoNewWindow -FilePath $chdmanPath -ArgumentList "createcd -i $CUEFile -o $OutputFile --force" -Wait
  } else {
    Start-Process -NoNewWindow -FilePath $chdmanPath -ArgumentList "createcd -i $CUEFile -o $OutputFile --force --compression none" -Wait
  }

  if ((Test-Path -Path $OutputFile) -eq $false) {
    Write-Host "$OutputFile was not generated" -ForegroundColor Red
    return $false
  } else {
    Write-Host "Builded CHD $OutputFile" -ForegroundColor Green
    Write-Host ""
  }
  Write-MameHash -ProjectName $ProjectName -CHDFile $OutputFile -XMLFile "$(Resolve-TemplatePath -Path $PathMame)\hash\neocd.xml"

  return $true
}

function Mame {
  param (
    [Parameter(Mandatory=$true)][String] $ExeName,
    [Parameter(Mandatory=$true)][String] $GameName,
    [Parameter(Mandatory=$true)][String] $PathMame,
    [Parameter(Mandatory=$true)][String] $XMLArgsFile
  )
  $defaultMameArgs = "-rompath `"$PathMame\roms`" -hashpath `"$PathMame\hash`" -cfg_directory $env:TEMP -nvram_directory $env:TEMP -skip_gameinfo neocdz $GameName"

  $mameArgs = "-window"
  $pathMame = Resolve-TemplatePath -Path $PathMame

  if (Test-Path -Path $XMLArgsFile) { $mameArgs = (Select-Xml -Path $XMLArgsFile -XPath '/mame/args').Node.InnerXML }

  if ((Test-Path -Path $pathMame) -eq $false) {
    Write-Host "$pathMame not found" -ForegroundColor Red
    return $false
  }
  if ((Test-Path -Path "$pathMame\$ExeName") -eq $false) { Write-Host ("error - {0}\ not found" -f $PathMame) -ForegroundColor Red; return $false }
  Write-Host "Launching mame $GameName" -ForegroundColor Yellow
  Write-Host "$pathMame\$ExeName $mameArgs $defaultMameArgs"
  Start-Process -NoNewWindow -FilePath "$pathMame\$ExeName" -ArgumentList "$mameArgs $defaultMameArgs"

  return $true
}

function Mame-WithProfile {
  param (
    [Parameter(Mandatory=$true)][String] $ExeName,
    [Parameter(Mandatory=$true)][String] $GameName,
    [Parameter(Mandatory=$true)][String] $PathMame
  )
  $pathMame = Resolve-TemplatePath -Path $PathMame
  $profileName = $Rule.Split(":")[2]
  if ($Rule -eq "run:mame") { $profileName = "default" }
  if (-Not($Config.project.emulator.mame.profile.$profileName)) {
    Write-Host "error : mame profile $profileName not found" -ForegroundColor Red
    return $false
  }

  Write-Host "start mame with profile : $profileName" -ForegroundColor Yellow
  Write-Host "extra parameters : $($Config.project.emulator.mame.profile.$profileName)" -ForegroundColor Yellow
  Write-Host ""

  $mameArgs = $Config.project.emulator.mame.profile.$profileName
  $mameArgs = Get-TemplatePath -Path $mameArgs
  $defaultMameArgs = "-rompath `"$pathMame\roms`" -hashpath `"$pathMame\hash`" -cfg_directory $env:TEMP -nvram_directory $env:TEMP $GameName"

  Write-Host "$pathMame\$ExeName $mameArgs $defaultMameArgs"
  Start-Process -NoNewWindow -Wait -FilePath "$pathMame\$ExeName" -ArgumentList "$mameArgs $defaultMameArgs"

  # Clean up console_history file if it exists
  if (Test-Path -Path "console_history") {
    Remove-Item -Path "console_history" -Force
  }

  return $true
}
