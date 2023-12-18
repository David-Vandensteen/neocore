# Neocore
# David Vandensteen
# MIT


param (
  [Parameter(Mandatory=$true)][String] $ConfigFile,
  [String] $Rule = "default"
)

function Compare-FileHash {
  param (
      [Parameter(Mandatory = $true)]
      [ValidateScript({Test-Path $_})]
      [string]$SrcFile,

      [Parameter(Mandatory = $true)]
      [ValidateScript({Test-Path $_})]
      [string]$DestFile
  )

  $hasher = [System.Security.Cryptography.SHA256]::Create()

  $file1Bytes = [System.IO.File]::ReadAllBytes($SrcFile)
  $file2Bytes = [System.IO.File]::ReadAllBytes($DestFile)

  $file1Hash = $hasher.ComputeHash($file1Bytes)
  $file2Hash = $hasher.ComputeHash($file2Bytes)

  $file1HashString = [System.BitConverter]::ToString($file1Hash) -replace "-", ""
  $file2HashString = [System.BitConverter]::ToString($file2Hash) -replace "-", ""

  if ($file1HashString -eq $file2HashString) {
    return $true
  }
  else {
    return $false
  }
}

function Check {
  param ([Parameter(Mandatory=$true)][xml] $Config)
  function Check-Manifest {
    param (
      [Parameter(Mandatory = $true)]
      [ValidateScript({Test-Path $_})]
      [string]$ManifestSource,

      [Parameter(Mandatory = $true)]
      [ValidateScript({Test-Path $_})]
      [string]$ManifestCache
  )
    Write-Host "check manifest" -ForegroundColor Yellow
    Write-Host "source : $ManifestSource"
    Write-Host "cache : $ManifestCache"
    if ((Compare-FileHash -SrcFile $ManifestSource -DestFile $ManifestCache) -eq $false) {
      return $false
    }
    return $true
  }

  function Check-XMLError {
    param ([Parameter(Mandatory=$true)][String] $Entry)
    Write-Host "error : xml $Entry not found" -ForegroundColor Red
    exit 1
  }
  function Check-PathError {
    param ([Parameter(Mandatory=$true)][String] $Path)
    Write-Host "error : $Path not found" -ForegroundColor Red
    exit 1
  }
  function Check-XML {
    if (-Not($Config.project.name)) { Check-XMLError -Entry "project.name" }
    if (-Not($Config.project.version)) { Check-XMLError -Entry "project.version" }
    if (-Not($Config.project.makefile)) { Check-XMLError -Entry "project.makefile" }
    if (-Not($Config.project.neocorePath)) { Check-XMLError -Entry "project.neocorePath" }
    if (-Not($Config.project.buildPath)) { Check-XMLError -Entry "project.buildPath" }
    if (-Not($Config.project.distPath)) { Check-XMLError -Entry "project.distPath" }
    if (-Not($Config.project.emulator)) { Check-XMLError -Entry "project.emulator" }
    if (-Not($Config.project.compiler)) { Check-XMLError -Entry "project.compiler" }
    if (-Not($Config.project.compiler.path)) { Check-XMLError -Entry "project.compiler.path" }
    if (-Not($Config.project.compiler.includePath)) { Check-XMLError -Entry "project.compiler.includePath" }
    if (-Not($Config.project.compiler.libraryPath)) { Check-XMLError -Entry "project.compiler.libraryPath" }
    if (-Not($Config.project.compiler.systemFile)) { Check-XMLError -Entry "project.compiler.systemFile" }

    if ($Config.project.sound) {
      if ($Config.project.sound.cdda) {
        if (-Not($Config.project.sound.cdda.dist.iso.format)) { Check-XMLError -Entry "project.sound.cdda.dist.iso.format" }
        if (-Not($Config.project.sound.cdda.tracks)) { Check-XMLError -Entry "project.sound.cdda.tracks" }
      }
    }
  }
  function Check-Path {
    if ((Test-Path -Path $Config.project.makefile) -eq $false) { Check-PathError -Path $Config.project.makefile }
    if ((Test-Path -Path $Config.project.neocorePath) -eq $false) { Check-PathError -Path $Config.project.neocorePath }
  }
  Write-Host "check config" -ForegroundColor Yellow
  Check-XML
  Check-Path
  if ((Test-Path -Path "$($Config.project.buildPath)\manifest.xml") -eq $false) {
    if (Test-Path -Path $Config.project.buildPath) {
      Write-Host "manifest not found : remove build cache" -ForegroundColor Blue
      Write-Host "Please, remove $(Resolve-Path -Path $Config.project.buildPath) to rebuild neocore"
      exit 1
    }
  }

  if (Test-Path -Path "$($Config.project.buildPath)\manifest.xml") {
    $checkManifest = Check-Manifest `
      -ManifestSource "$($Config.project.neocorePath)\manifest.xml" `
      -ManifestCache "$($Config.project.buildPath)\manifest.xml"

    if ($checkManifest -eq $false) {
      Write-Host "manifest has changed : remove build cache" -ForegroundColor Blue
      Write-Host "Please, remove $(Resolve-Path -Path $Config.project.buildPath) to rebuild neocore"
      exit 1
    }
  }

  if ($Config.project.name -like "*-*") { Write-Host "error : char - is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*\*") { Write-Host "error : char \ is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*/*") { Write-Host "error : char / is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*$*") { Write-Host "error : char $ is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*=*") { Write-Host "error : char = is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*@*") { Write-Host "error : char @ is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*(*") { Write-Host "error : char ( is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*)*") { Write-Host "error : char ) is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*{*") { Write-Host "error : char { is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*}*") { Write-Host "error : char } is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Config.project.name -like "*#*") { Write-Host "error : char # is not allowed in project name" -ForegroundColor Red; exit 1 }
  Write-Host "config is compliant" -ForegroundColor Green
}

function Remove-Project {
  Write-Host "clean $($buildConfig.pathBuild)" -ForegroundColor Yellow
  if (Test-Path -Path $buildConfig.pathBuild) {
    Get-ChildItem -Path $buildConfig.pathBuild -Recurse -ErrorAction SilentlyContinue | Remove-Item -force -Recurse -ErrorAction SilentlyContinue
  }
  if (Test-Path -Path $buildConfig.pathBuild) { Remove-Item $buildConfig.pathBuild -Force -ErrorAction SilentlyContinue }
}

function Set-EnvPath {
  param (
    [Parameter(Mandatory=$true)][String] $GCCPath,
    [Parameter(Mandatory=$true)][String] $Bin
  )

  $env:path = "$GCCPath;$Bin;$env:windir\System32;$env:windir\System32\WindowsPowerShell\v1.0\"

  Write-Host "Env Path: $env:path"
  Write-Host "--------------------------------------------"
  Write-Host ""
}


function Main {
  param (
    [Parameter(Mandatory=$true)][String] $Rule,
    [Parameter(Mandatory=$true)][String] $BaseURL,
    [Parameter(Mandatory=$true)][xml] $Config
  )

  Check -Config $Config

  $buildConfig = [PSCustomObject]@{
    pathMame = "$($Config.project.buildPath)\mame"
    pathRaine = "$($Config.project.buildPath)\raine"
    pathSpool = "$($Config.project.buildPath)\spool"
    pathNeocore = $Config.project.buildPath
    pathBuild = "$($Config.project.buildPath)\$($Config.project.name)"
    pathDist = $Config.project.distPath
    pathNeodevBin = "$($Config.project.buildPath)\neodev-sdk\m68k\bin"
    pathNeocoreBin = "$($Config.project.buildPath)\bin"
    pathNeodev = "$($Config.project.buildPath)\neodev-sdk"
    pathToolchain = $Config.project.toolchainPath
    projectName = $Config.project.name
    version = $Config.project.version
    makefile = $Config.project.makefile
    PRGFile = "$($Config.project.buildPath)\$($Config.project.name)\$($Config.project.name).prg"
    rule = $Rule
    XMLDATFile = $Config.project.XMLDATFile
    baseURL = $BaseURL
  }

  Write-Host "project name : $($buildConfig.projectName)"
  Write-Host "project version : $($buildConfig.version)"
  Write-Host "makefile : $($buildConfig.makefile)"
  Write-Host "path neodev bin : $($buildConfig.pathNeodevBin)"
  Write-Host "path neocore bin : $($buildConfig.pathNeocoreBin)"
  Write-Host "path neodev : $($buildConfig.pathNeoDev)"
  Write-Host "program file : $($buildConfig.PRGFile)"
  Write-Host "required rule : $($buildConfig.rule)"
  Write-Host "project setting file : $XMLProjectSettingFile"
  Write-Host "graphic data XML file for DATLib : $($buildConfig.XMLDATFile)"
  Write-Host "mame folder : $($buildConfig.pathMame)"
  Write-Host "raine folder : $($buildConfig.pathRaine)"
  Write-Host "spool folder for download : $($buildConfig.pathSpool)"
  Write-Host "neocore folder : $($buildConfig.pathNeocore)"
  Write-Host "path build : $($buildConfig.pathBuild)"
  Write-Host "path dist : $($buildConfig.pathDist)"
  Write-Host "--------------------------------------------"
  Write-Host ""

  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\module-check-rule.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\module-logger.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\module-sdk.ps1"
  Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\module-emulators.ps1"

  Check-Rule

  $raineProcessName = [System.IO.Path]::GetFileNameWithoutExtension($Config.project.emulator.raine.exeFile)
  $mameProcessName = [System.IO.Path]::GetFileNameWithoutExtension($Config.project.emulator.mame.exeFile)

  Stop-Emulators -RaineProcessName $raineProcessName -MameProcessName $mameProcessName

  if ((Test-Path -Path $buildConfig.pathSpool) -eq $false) { New-Item -Path $buildConfig.pathSpool -ItemType Directory -Force }

  $gccPath = "..\..\build\gcc\gcc-2.95.2"
  Write-Host $gccPath

  if ($Config.project.compiler.path) { $gccPath = $Config.project.compiler.path }

  Set-EnvPath -GCCPath $gccPath -Bin "$($Config.project.buildPath)\bin"
  $env:NEODEV = $buildConfig.pathNeodev

  if ((Test-Path -Path $buildConfig.pathNeoDevBin) -eq $false) { Install-SDK }
  if ((Test-Path -Path $buildConfig.pathNeocoreBin) -eq $false) { Install-SDK }
  if ((Test-Path -Path $buildConfig.pathNeodev) -eq $false) { Install-SDK }

  # TODO : if ((Test-Path -Path "$($buildConfig.pathNeodev)\m68k\include\neocore.h") -eq $false) { Install-SDK }
  # TODO : if ((Test-Path -Path "$($buildConfig.pathNeodev)\m68k\lib\libneocore.a") -eq $false) { Install-SDK }

  if ($Rule -notmatch "^only:") { Remove-Project }
  if ((Test-Path -Path $buildConfig.pathBuild) -eq $false) { New-Item -Path $buildConfig.pathBuild -ItemType Directory -Force }

  function BuilderProgram {
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-program.ps1"
    robocopy .\ $buildConfig.pathBuild /e /xf * | Out-Null
    if ($Config.project.compiler.program.version -eq "2.95.2") { $gccPath = $Config.project.compiler.program.path }

    Write-Program `
      -ProjectName $buildConfig.projectName `
      -GCCPath $gccPath -PathNeoDev $buildConfig.pathNeodev `
      -MakeFile $buildConfig.makefile `
      -PRGFile $buildConfig.PRGFile `
      -BinPath "$($Config.project.buildPath)\bin"
  }

  function BuilderSprite {
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-sprite.ps1"
    Write-DATXML -InputFile $ConfigFile -OutputFile "$($buildConfig.pathBuild)\chardata.xml"
    Write-Sprite -XMLFile "$($buildConfig.pathBuild)\chardata.xml" -Format "cd" -OutputFile "$($buildConfig.pathBuild)\$($buildConfig.projectName)"
  }

  function BuilderISO {
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-iso.ps1"

    Write-Cache `
      -PRGFile $buildConfig.PRGFile `
      -SpriteFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).cd" `
      -PathISOBuildFolder "$($buildConfig.pathBuild)\iso" `
      -PathCDTemplate "$($buildConfig.pathNeocore)\cd_template" `

    if ($config.project.sound.sfx.pcm) {
      Write-SFX `
      -PathISOBuildFolder "$($buildConfig.pathBuild)\iso" `
      -PCMFile "$($config.project.sound.sfx.pcm)"
    }

    if ($config.project.sound.sfx.z80) {
      Write-SFX `
        -PathISOBuildFolder "$($buildConfig.pathBuild)\iso" `
        -Z80File "$($config.project.sound.sfx.z80)"
    }

    Write-ISO `
      -PRGFile $buildConfig.PRGFile `
      -SpriteFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).cd" `
      -OutputFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).iso" `
      -PathISOBuildFolder "$($buildConfig.pathBuild)\iso" `
      -PathCDTemplate "$($buildConfig.pathNeocore)\cd_template" `

    $configCDDA = $null

    if ($Config.project.sound.cdda.tracks.track) { $configCDDA = $config.project.sound.cdda }

    Write-CUE `
      -Rule $buildConfig.rule `
      -OutputFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).cue" `
      -ISOName "$($buildConfig.projectName).iso" `
      -Config $configCDDA
  }

  function BuilderMame {
    $mamePath = Split-Path $Config.project.emulator.mame.exeFile
    $name = $Config.project.name
    Write-Mame `
      -ProjectName $name `
      -PathMame $mamePath `
      -CUEFile "$($buildConfig.pathBuild)\$name.cue" `
      -OutputFile "$mamePath\roms\neocdz\$name.chd"
  }

  function RunnerMame {
    $exeName = [System.IO.Path]::GetFileName($Config.project.emulator.mame.exeFile)
    $mamePath = Split-Path $Config.project.emulator.mame.exeFile

    Mame `
      -ExeName $exeName `
      -GameName $buildConfig.projectName `
      -PathMame $mamePath `
      -XMLArgsFile "$($buildConfig.pathNeocore)\mame-args.xml"
  }

  function RunnerRaine {
    $exeName = [System.IO.Path]::GetFileName($Config.project.emulator.raine.exeFile)

    $rainePath = Split-Path $Config.project.emulator.raine.exeFile

    Raine `
      -FileName "$($buildConfig.projectName).cue" `
      -PathRaine $rainePath `
      -PathISO $buildConfig.pathBuild `
      -ExeName $exeName
  }

  if ($Rule -eq "clean") { exit 0 }
  if ($Rule -eq "sprite") { BuilderSprite }
  if (($Rule -eq "make") -or ($Rule -eq "") -or (!$Rule) -or ($Rule -eq "default") ) {
    BuilderSprite
    BuilderProgram
  }
  if ($Rule -eq "iso") {
    BuilderSprite
    BuilderProgram
    BuilderISO
  }
  if ($Rule -eq "run:raine" -or $Rule -eq "raine") {
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-raine.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
    RunnerRaine
  }
  if ($Rule -eq "run:mame" -or $Rule -eq "mame" -or $Rule -eq "run") {
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-mame.ps1"
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderMame
    RunnerMame
  }
  if ($Rule -eq "serve:raine") {
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-sprite.ps1"
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-program.ps1"
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-iso.ps1"
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-raine.ps1"
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-watcher.ps1"
    While ($true) {
      BuilderSprite
      BuilderProgram
      BuilderISO
      RunnerRaine
      Watch-Folder -Path "."
      Stop-Emulators -RaineProcessName $raineProcessName -MameProcessName $mameProcessName
    }
  }
  if ($Rule -eq "serve:mame" -or $Rule -eq "serve") {
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-sprite.ps1"
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-program.ps1"
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-iso.ps1"
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-mame.ps1"
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-watcher.ps1"
    While ($true) {
      BuilderSprite
      BuilderProgram
      BuilderISO
      BuilderMame
      RunnerMame
      Watch-Folder -Path "."
      Stop-Emulators -RaineProcessName $raineProcessName -MameProcessName $mameProcessName
    }
  }
  if ($Rule -eq "dist:iso" -or $Rule -eq "dist:raine") {
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-dist.ps1"

    if ((Test-Path -Path $Config.project.distPath) -eq $false) { New-Item -Path $Config.project.distPath -ItemType Directory -Force }
    BuilderSprite
    BuilderProgram
    BuilderISO
    Write-Dist `
      -ProjectName $buildConfig.projectName `
      -PathDestination "$($Config.project.distPath)\$($buildConfig.projectName)\$($buildConfig.projectName)-$($buildConfig.version)" `
      -ISOFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).iso" `
      -CUEFile "$($buildConfig.pathBuild)\$($buildConfig.projectName).cue" `
  }
  if ($Rule -eq "dist:mame" -or $Rule -eq "dist:chd") {
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-mame.ps1"
    Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\module-dist.ps1"
    if ((Test-Path -Path $Config.project.distPath) -eq $false) { New-Item -Path $Config.project.distPath -ItemType Directory -Force }
    BuilderSprite
    BuilderProgram
    BuilderISO
    BuilderMame
    Write-Dist `
      -ProjectName $buildConfig.projectName `
      -PathDestination "$($Config.project.distPath)\$($buildConfig.projectName)\$($buildConfig.projectName)-$($buildConfig.version)" `
      -CHDFile "$($buildConfig.pathMame)\roms\neocdz\$($buildConfig.projectName).chd" `
      -HashFile "$($buildConfig.pathMame)\hash\neocd.xml"
  }
  if ($Rule -eq "only:sprite") { BuilderSprite }
  if ($Rule -eq "only:program") { BuilderProgram }
  if ($Rule -eq "only:iso") { BuilderISO }
  if ($Rule -eq "only:mame") { BuilderMame }
  if ($Rule -eq "only:run") { RunnerMame }
  if ($Rule -eq "only:run:mame") { RunnerMame }
  if ($Rule -eq "only:run:raine") { RunnerRaine }
}

if ((Test-Path -Path $ConfigFile) -eq $false) {
  Write-Host "Config $ConfigFile not found" -ForegroundColor Red
  exit 1
}

Write-Host "informations" -ForegroundColor Yellow
Write-Host "Config file : $ConfigFile"

[xml]$config = (Get-Content -Path $ConfigFile)

Main -Config $config -BaseURL "http://azertyvortex.free.fr/download" -Rule $Rule
