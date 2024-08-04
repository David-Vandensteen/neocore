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

if (Test-Path $ProjectNeocorePath) {
  try {
    robocopy /MIR "..\..\..\src-lib" "$ProjectNeocorePath\src-lib"
    Copy-Item -Path "..\..\..\manifest.xml" -Destination $ProjectNeocorePath -Force
    robocopy /MIR "..\..\..\toolchain" "$ProjectNeocorePath\toolchain"
    Write-Host "files copied successfully to $ProjectNeocorePath"
  } catch {
    Show-Error "failed to copy some files"
  }
} else {
  Show-Error "$ProjectNeocorePath not found"
}

if (Test-Path $ProjectSrcPath) {
  try {
    Copy-Item -Path "..\..\..\bootstrap\standalone\mak.bat" -Destination $ProjectSrcPath -Force
    Copy-Item -Path "..\..\..\bootstrap\standalone\mak.ps1" -Destination $ProjectSrcPath -Force
    Write-Host "files copied successfully to $ProjectSrcPath"
  } catch {
    Show-Error "failed to copy some files"
  }
} else {
  Show-Error "$ProjectSrcPath not found"
  exit 1
}
