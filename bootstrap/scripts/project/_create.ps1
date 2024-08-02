param (
  [Parameter(Mandatory=$true)]
  [string]$Name,

  [Parameter(Mandatory=$true)]
  [string]$Path
)

function Show-Error {
  param ($message)
  Write-Host "ERROR: $message" -ForegroundColor Red
  exit 1
}

if (-not (Test-Path $Path)) {
  try {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null

    xcopy /E /I "..\..\..\src-lib" "$Path\neocore\src-lib" | Out-Null
    if (-not $?) { Show-Error "Failed to copy src-lib." }

    Copy-Item "..\..\..\manifest.xml" "$Path\neocore"
    if (-not $?) { Show-Error "Failed to copy manifest.xml." }

    Copy-Item "..\..\..\bootstrap\.gitignore" "$Path\.gitignore"
    if (-not $?) { Show-Error "Failed to copy .gitignore." }

    xcopy /E /I "..\..\..\toolchain" "$Path\neocore\toolchain" | Out-Null
    if (-not $?) { Show-Error "Failed to copy toolchain." }

    xcopy /E /I "..\..\..\bootstrap\standalone" "$Path\src" | Out-Null
    if (-not $?) { Show-Error "Failed to copy standalone." }

    $xmlPath = "$Path\src\project.xml"
    [xml]$xml = Get-Content -Path $xmlPath
    $xml.project.name = $Name
    $xml.Save($xmlPath)
  } catch {
    Show-Error $_.Exception.Message
  }
} else {
  Write-Host "$Path already exists" -ForegroundColor Yellow
}
