function Build-EXE {
  if (-not (Write-NSI)) {
    Write-Host "NSI file creation failed" -ForegroundColor Red
    return $false
  }
  Write-Host "cleaning chd files in Mame to prepare standalone exe building " -ForegroundColor Yellow
  Write-Host ""

  $mameExeFile = Resolve-TemplatePath -Path $Config.project.emulator.mame.exeFile
  $mamePath = Resolve-TemplatePath -Path $(Convert-Path -Path $mameExeFile)
  $mameRomPath = Join-Path -Path (Split-Path -Path $mamePath -Parent) -ChildPath "roms\neocdz"
  $excludeChdFile = "$($Config.project.name).chd"
  $chdFiles = Get-ChildItem -Path $mameRomPath -Filter *.chd

  $packageName = $Config.project.name
  $distPath = Get-TemplatePath -Path $Config.project.distPath
  $version = $Config.project.version

  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $NSIFile = "$projectBuildPath\$packageName\$packageName.nsi"
  $makeNSISexe = "$projectBuildPath\tools\nsis-3.08\makensis.exe"

  if (-Not(Assert-BuildEXE)) {
    Write-Host "EXE build assertion failed" -ForegroundColor Red
    return $false
  }

  foreach ($file in $chdFiles) {
    if ($file.Name -ne $excludeChdFile) {
      Remove-Item -Path $file.FullName -Force
      Write-Host "  remove : $($file.FullName)" -ForegroundColor Yellow
      Write-Host ""
    }
  }

  Write-Host "Building the exe file, be patient ..." -ForegroundColor Yellow
  Write-Host ""

  if ((Test-Path -Path $NSIFile) -eq $false) {
    Write-Host "$NSIFile not found" -ForegroundColor Red
    return $false
  }

  if ((Test-Path -Path $makeNSISexe) -eq $false) {
    Write-Host "$makeNSISexe not found" -ForegroundColor Red
    return $false
  }

  Start-Process -FilePath $makeNSISexe -Wait -NoNewWindow -ArgumentList $NSIFile
  $exeFile = "$(Resolve-TemplatePath -Path $Config.project.distPath)\$packageName\$packageName-$version\$($Config.project.platform)\exe\$packageName-$version.exe"

  if ((Test-Path -Path $exeFile) -eq $true) {
    Write-Host ""
    Write-Host "Builded exe $exeFile" -ForegroundColor Green
  } else {
    Write-Host ""
    Write-Host "Builded $exeFile not found" -ForegroundColor Red
    return $false
  }

  return $true
}
