Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\nsi.ps1"

function Build-EXE {
  Write-NSI
  Write-Host "cleaning chd files in Mame to prepare standalone exe building " -ForegroundColor Yellow
  Write-Host ""

  $mameExeFile = $Config.project.emulator.mame.exeFile
  $mamePath = Resolve-Path -Path $(Convert-Path -Path $mameExeFile)
  $mameRomPath = Join-Path -Path (Split-Path -Path $mamePath -Parent) -ChildPath "roms\neocdz"
  $excludeChdFile = "$($Config.project.name).chd"
  $chdFiles = Get-ChildItem -Path $mameRomPath -Filter *.chd

  foreach ($file in $chdFiles) {
    if ($file.Name -ne $excludeChdFile) {
      Remove-Item -Path $file.FullName -Force
      Write-Host "  remove : $($file.FullName)" -ForegroundColor Yellow
      Write-Host ""
    }
  }

  Write-Host "building the exe file, be patient ..." -ForegroundColor Yellow
  Write-Host ""

  $packageName = $Config.project.name
  $distPath = $Config.project.distPath
  $version = $Config.project.version

  $NSIFile = "$($Config.project.buildPath)\$packageName\$packageName.nsi"
  $makeNSISexe = "$($Config.project.buildPath)\tools\nsis-3.08\makensis.exe"

  if ((Test-Path -Path $NSIFile) -eq $false) {
    Write-Host "$NSIFile not found" -ForegroundColor Red
    exit 1
  }

  if ((Test-Path -Path $makeNSISexe) -eq $false) {
    Write-Host "$makeNSISexe not found" -ForegroundColor Red
    exit 1
  }

  Start-Process -FilePath $makeNSISexe -Wait -NoNewWindow -ArgumentList $NSIFile

  if ((Test-Path -Path "$distPath\$packageName\$packageName-$version\exe\$packageName-$version.exe") -eq $true) {
    Write-Host ""
    Write-Host "builded exe $distPath\$packageName\$packageName-$version\exe\$packageName-$version.exe" -ForegroundColor Green
  }
}
