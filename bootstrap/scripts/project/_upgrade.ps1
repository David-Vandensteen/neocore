param (
  [Parameter(Mandatory=$true)]
  [string]$ProjectSrcPath,

  [Parameter(Mandatory=$true)]
  [string]$ProjectNeocorePath
)

function Show-Error {
  param ($message)
  Write-Host "error: $message" -ForegroundColor Red
  exit 1
}

if (Test-Path -Path $ProjectNeocorePath) {
  $srcLib = Resolve-Path -Path "..\..\..\src-lib"
  $toolchain = Resolve-Path -Path "..\..\..\toolchain"
  $manifest = Resolve-Path -Path "..\..\..\manifest.xml"

  if (-Not(Test-Path -Path $srcLib)) { Show-Error "$srcLib not found" }
  if (-Not(Test-Path -Path $toolchain)) { Show-Error "$toolchain not found" }
  if (-Not(Test-Path -Path $manifest)) { Show-Error "$manifest not found" }

  if (-Not(Test-Path -Path "$ProjectNeocorePath\src-lib")) { Show-Error "$ProjectNeocorePath\src-lib not found" }
  if (-Not(Test-Path -Path "$ProjectNeocorePath\toolchain")) { Show-Error "$ProjectNeocorePath\toolchain not found" }

  try {
    robocopy /MIR "$srcLib" "$ProjectNeocorePath\src-lib"
    Copy-Item -Path $manifest -Destination $ProjectNeocorePath -Force
    robocopy /MIR "$toolchain" "$ProjectNeocorePath\toolchain"
    Write-Host "files copied successfully to $ProjectNeocorePath"
  } catch {
    Show-Error "failed to copy some files"
  }
} else {
  Show-Error "$ProjectNeocorePath not found"
}

if (Test-Path -Path $ProjectSrcPath) {
  $makBat = Resolve-Path -Path "..\..\..\bootstrap\standalone\mak.bat"
  $makPs1 = Resolve-Path -Path "..\..\..\bootstrap\standalone\mak.ps1"

  try {
    Copy-Item -Path $makBat -Destination $ProjectSrcPath -Force
    Copy-Item -Path $makPs1 -Destination $ProjectSrcPath -Force
    Write-Host "files copied successfully to $ProjectSrcPath"
  } catch {
    Show-Error "failed to copy some files"
  }
} else {
  Show-Error "$ProjectSrcPath not found"
  exit 1
}
