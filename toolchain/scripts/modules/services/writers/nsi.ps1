function Write-NSI {
  Write-Host "generating nsi script" -ForegroundColor Yellow
  Write-Host ""

  $packageName = $Config.project.name
  $version = $Config.project.version
  $buildPath = $Config.project.buildPath
  $distPath = $Config.project.distPath
  $neocorePath = $Config.project.neocorePath
  $mameExeFile = $Config.project.emulator.mame.exeFile

  if ((Test-Path -Path $distPath) -eq $false) {
    Write-Host "create $distPath folder" -ForegroundColor Yellow
    New-Item -Path $distPath -ItemType Directory -Force
  }

  if ((Test-Path -Path "$distPath\$packageName") -eq $false) {
    Write-Host "create $distPath\$packageName folder" -ForegroundColor Yellow
    New-Item -Path "$distPath\$packageName" -ItemType Directory -Force
  }

  if ((Test-Path -Path "$distPath\$packageName\$packageName-$version") -eq $false) {
    Write-Host "create $distPath\$packageName\$packageName-$version folder" -ForegroundColor Yellow
    New-Item -Path "$distPath\$packageName\$packageName-$version" -ItemType Directory -Force
  }

  if ((Test-Path -Path "$distPath\$packageName\$packageName-$version\exe") -eq $false) {
    Write-Host "create $distPath\$packageName\$packageName-$version\exe folder" -ForegroundColor Yellow
    New-Item -Path "$distPath\$packageName\$packageName-$version\exe" -ItemType Directory -Force
  }

  if ((Test-Path -Path "$distPath\$packageName\$packageName-$version\exe\$packageName-$version.exe") -eq $true) {
    Write-Host "$packageName : $version was already released" -ForegroundColor Red
    Write-Host "$distPath\$packageName\$packageName-$version\exe\$packageName-$version.exe already exist" -ForegroundColor Red
    exit 1
  }

  $NSITemplateFile = "$neocorePath\toolchain\nsi\template.nsi"
  $outPath = Resolve-Path -Path "$buildPath\$packageName"
  $NSIFile = "$outPath\$packageName.nsi"
  $outFile = "$(Resolve-Path -Path $distPath)\$packageName\$packageName-$version\exe\$packageName-$version.exe"
  $icon = Resolve-Path -Path "$neocorePath\toolchain\nsi\neogeo.ico"
  $brandingText = "Created with Neocore"
  $mamePath = "$(Resolve-Path -Path $(Split-Path -Parent $mameExeFile))\"
  $exec = "$(Split-Path $mameExeFile -Leaf) -window -skip_gameinfo neocdz $packageName"

  if ((Test-Path -Path $NSITemplateFile) -eq $false) {
    Write-Host "$NSITemplateFile not found" -ForegroundColor Red
    exit 1
  }

  if ((Test-Path -Path $outPath) -eq $false) {
    Write-Host "$outPath not found" -ForegroundColor Red
    exit 1
  }

  if ((Test-Path -Path $icon) -eq $false) {
    Write-Host "$icon not found" -ForegroundColor Red
    exit 1
  }

  if ((Test-Path -Path $mamePath) -eq $false) {
    Write-Host "$mamePath not found" -ForegroundColor Red
    exit 1
  }

  $NSIcontent = [System.IO.File]::ReadAllText($NSITemplateFile)
  $NSIcontent = $NSIcontent.Replace("/*packageName*/", $packageName)
  $NSIcontent = $NSIcontent.Replace("/*outFile*/", $outFile)
  $NSIcontent = $NSIcontent.Replace("/*icon*/", $icon)
  $NSIcontent = $NSIcontent.Replace("/*brandingText*/", $brandingText)
  $NSIcontent = $NSIcontent.Replace("/*mamePath*/", $mamePath)
  $NSIcontent = $NSIcontent.Replace("/*exec*/", $exec)

  [System.IO.File]::WriteAllText($NSIFile, $NSIcontent)

  if ((Test-Path -Path $NSIFile) -eq $false) {
    Write-Host "$NSIFile was not generated" -ForegroundColor Red
    exit 1
  }

  if ((Test-Path -Path $NSIFile) -eq $true) {
    Write-Host ""
    Write-Host "NSI script is available at $NSIFile" -ForegroundColor Green
    Write-Host ""
  }
}