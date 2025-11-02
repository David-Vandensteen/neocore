function Write-NSI {
  Write-Host "generating nsi script" -ForegroundColor Yellow
  Write-Host ""

  $packageName = $Config.project.name
  $version = $Config.project.version
  $buildPath = Get-TemplatePath -Path $Config.project.buildPath
  $distPath = Get-TemplatePath -Path $Config.project.distPath
  $neocorePath = Resolve-TemplatePath -Path $Config.project.neocorePath
  $mameExeFile = Resolve-TemplatePath -Path $Config.project.emulator.mame.exeFile

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

  if ((Test-Path -Path "$distPath\$packageName\$packageName-$version\$($Config.project.platform)") -eq $false) {
    Write-Host "create $distPath\$packageName\$packageName-$version\$($Config.project.platform) folder" -ForegroundColor Yellow
    New-Item -Path "$distPath\$packageName\$packageName-$version\$($Config.project.platform)" -ItemType Directory -Force
  }

  if ((Test-Path -Path "$distPath\$packageName\$packageName-$version\$($Config.project.platform)\exe") -eq $false) {
    Write-Host "create $distPath\$packageName\$packageName-$version\$($Config.project.platform)\exe folder" -ForegroundColor Yellow
    New-Item -Path "$distPath\$packageName\$packageName-$version\$($Config.project.platform)\exe" -ItemType Directory -Force
  }

  if ((Test-Path -Path "$distPath\$packageName\$packageName-$version\$($Config.project.platform)\exe\$packageName-$version.exe") -eq $true) {
    Write-Host "$packageName : $version was already released" -ForegroundColor Red
    Write-Host "$distPath\$packageName\$packageName-$version\$($Config.project.platform)\exe\$packageName-$version.exe already exist" -ForegroundColor Red
    return $false
  }

  $NSITemplateFile = "$neocorePath\toolchain\nsi\template.nsi"
  $outPath = "$buildPath\$packageName"
  $NSIFile = "$outPath\$packageName.nsi"
  $outFile = "$(Resolve-TemplatePath -Path $Config.project.distPath)\$packageName\$packageName-$version\$($Config.project.platform)\exe\$packageName-$version.exe"
  $icon = "$neocorePath\toolchain\nsi\neogeo.ico"
  $brandingText = "Created with Neocore"
  $mamePath = "$(Split-Path -Parent $mameExeFile)\"
  $exec = "$(Split-Path $mameExeFile -Leaf) -window -skip_gameinfo neocdz $packageName"

  if ((Test-Path -Path $NSITemplateFile) -eq $false) {
    Write-Host "$NSITemplateFile not found" -ForegroundColor Red
    return $false
  }

  if ((Test-Path -Path $outPath) -eq $false) {
    Write-Host "$outPath not found" -ForegroundColor Red
    return $false
  }

  if ((Test-Path -Path $icon) -eq $false) {
    Write-Host "$icon not found" -ForegroundColor Red
    return $false
  }

  if ((Test-Path -Path $mamePath) -eq $false) {
    Write-Host "$mamePath not found" -ForegroundColor Red
    return $false
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
    return $false
  }

  if ((Test-Path -Path $NSIFile) -eq $true) {
    Write-Host ""
    Write-Host "NSI script $NSIFile" -ForegroundColor Green
    Write-Host ""
    return $true
  }

  return $false
}