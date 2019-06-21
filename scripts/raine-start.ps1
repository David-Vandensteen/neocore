Param(
  [String] $raineExe,
  [String] $fileZip
)

<#
[String] $neobuildData = "$env:APPDATA\neocore"
[String] $raineExe = "$neobuildData\raine\raine32.exe"
[String] $fileZip = "c:\temp\flamble.zip"
#>

function testPathBreak([String] $pathToTest) {
  if (!(Test-Path($pathToTest))) {
    Write-Host "$pathToTest not found ... exit"
    break 1
  }
}

function _main{
  testPathBreak $fileZip
  testPathBreak $raineExe
  & $raineExe $fileZip

  Start-Sleep 2
  $wshell = New-Object -ComObject wscript.shell;
  $wshell.AppActivate('raine32')
  Start-Sleep 1
  $wshell.SendKeys("{ESC}")
}

_main