Param(
  [String] $neobuildData
)
[String] $neobuildTemp = "$env:TEMP\neocore"
[String] $toolsHost = "http://azertyvortex.free.fr/download"
#[String] $toolsHost = "http://127.0.0.1:8080/download"

function createFolder([String] $_item){
  if( !(Test-path($_item))){
    Write-Host "Create : $_item"
    New-Item -ItemType Directory -Force -Path $_item
  }
}

function cdTemplate{
  Write-Host "setup cd_template"
  downloadHttp $toolsHost/neobuild-cd_template.zip $neobuildTemp\neobuild-cd_template.zip
  expandZip $neobuildTemp\neobuild-cd_template.zip $neobuildData
  Start-Sleep 5
}

function raine{
  Write-Host "setup raine emulator"
  downloadHttp $toolsHost/neobuild-raine.zip $neobuildTemp\neobuild-raine.zip
  expandZip $neobuildTemp\neobuild-raine.zip $neobuildData
  Start-Sleep 5
}

function raineConfig{
  Write-Host "configure raine"
  $content = [System.IO.File]::ReadAllText("$neobuildData\raine\config\raine32_sdl.cfg").Replace("/*neocd_bios*/","neocd_bios = $env:appdata\neocore\raine\roms\NEOCD.BIN")
  [System.IO.File]::WriteAllText("$neobuildData\raine\config\raine32_sdl.cfg", $content)
}

function bin{
  Write-Host "setup bin"
  downloadHttp $toolsHost/neocore-bin.zip $neobuildTemp\neocore-bin.zip
  expandZip $neobuildTemp\neocore-bin.zip $neobuildData
  Start-Sleep 5
}

function sdk{
  Write-Host "setup sdk"
  downloadHttp $toolsHost/neodev-sdk.zip $neobuildTemp\neodev-sdk.zip
  expandZip $neobuildTemp\neodev-sdk.zip $neobuildData
  Start-Sleep 5
}

function testPathBreak([String] $pathToTest) {
  if (!(Test-Path($pathToTest))) {
    Write-Host "$pathToTest not found ... exit"
    break 1
  }
}

function testPsVersion() {
  if ($psversiontable.psversion.major -lt 5) {
    downloadHttp $toolsHost/Win7AndW2K8R2-KB3191566-x64.zip $neobuildTemp\Win7AndW2K8R2-KB3191566-x64.zip
    expandZip $neobuildTemp\Win7AndW2K8R2-KB3191566-x64.zip $neobuildTemp
    powershell -File $neobuildTemp\Install-WMF5.1.ps1
    break 0
  }
}

function downloadHttp([String] $url, [String] $targetFile){
  Write-Host "downloadHttp : $url $targetFile"
  Import-Module BitsTransfer

  $start_time = Get-Date
  Start-BitsTransfer -Source $url -Destination $targetFile
  Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
}

function expandZip([String] $file, [String] $destination) {
  Write-Host "expandZip $file $destination"
  $shell = new-object -com shell.application
  $zip = $shell.NameSpace($file)
  foreach($item in $zip.items()) {
    $shell.Namespace($destination).copyhere($item)
  }
}

function removeItem([String] $_item){
  Write-Host "Remove : $_item"
  if(Test-Path($_item)){
      Remove-Item -Force -Recurse $_item
  }
}
function removeFolder([String] $_item){
  removeItem $_item
}

function clean{
  if (Test-Path($neobuildData)) {
    removeFolder $neobuildTemp
    removeFolder $neobuildData
    Start-Sleep 5
  }
}

function _main{
  clean
  createFolder $neobuildData
  createFolder $neobuildTemp
  testPsVersion
  sdk
  cdTemplate
  raine
  raineConfig
  bin
}

_main

