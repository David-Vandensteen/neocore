Import-Module ".\scripts\module-hash.ps1"
Import-Module ".\scripts\module-emulators.ps1"

function clean {
  param(
    [String] $ProjectName
  )
  Write-Host "Clean $ProjectName"
  Write-Host "Remove $env:TEMP\neocore\$ProjectName"
  Stop-Emulators
  if (Test-Path -Path $env:TEMP\neocore\$ProjectName) { Get-ChildItem -Path $env:TEMP\neocore\$ProjectName -Recurse | Remove-Item -force -recurse }
  if (Test-Path -Path $env:TEMP\neocore\$ProjectName) { Remove-Item $env:TEMP\neocore\$ProjectName -Force }
}

function zip {
  param(
    [String] $ProjectName
  )
}

function sprite {

}