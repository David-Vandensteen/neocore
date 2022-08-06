Param(
  [String] $raineExe,
  [String] $fileZip
)

function testPathBreak([String] $pathToTest) {
  if (!(Test-Path($pathToTest))) {
    Write-Host "$pathToTest not found ... exit"
    break 1
  }
}

function main {
  testPathBreak $fileZip
  testPathBreak $raineExe
  & $raineExe $fileZip

  Start-Sleep 2
  $wshell = New-Object -ComObject wscript.shell;
  $wshell.AppActivate('raine32')
  Start-Sleep 1
  $wshell.SendKeys("{ESC}")
}

main