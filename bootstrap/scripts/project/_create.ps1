param (
  [Parameter(Mandatory=$true)]
  [string]$Name,

  [Parameter(Mandatory=$true)]
  [string]$Path,

  [switch]$Force = $false
)

Import-Module "..\..\..\toolchain\scripts\modules\assert\project\name.ps1"

if ((-not $Force) -and (Test-Path $Path)) {
  Write-Host "error : $Path already exists" -ForegroundColor Red
  exit 1
}

Assert-ProjectName -Name $Name

try {
  New-Item -ItemType Directory -Path $Path -Force | Out-Null

  xcopy /E /I /Y /Q "..\..\..\src-lib" "$Path\neocore\src-lib" | Out-Null
  if (-not $?) {
    Write-Host "error : failed to copy src-lib." -ForegroundColor Red
    exit 1
  }

  Copy-Item "..\..\..\manifest.xml" "$Path\neocore" -Force
  if (-not $?) {
    Write-Host "error : failed to copy manifest.xml." -ForegroundColor Red
    exit 1
  }

  Copy-Item "..\..\..\bootstrap\.gitignore" "$Path\.gitignore" -Force
  if (-not $?) {
    Write-Host "error: failed to copy .gitignore." -ForegroundColor Red
    exit 1
  }

  xcopy /E /I /Y /Q "..\..\..\toolchain" "$Path\neocore\toolchain" | Out-Null
  if (-not $?) {
    Write-Host "error : failed to copy toolchain." -ForegroundColor Red
    exit 1
  }

  xcopy /E /I /Y /Q "..\..\..\bootstrap\standalone" "$Path\src" | Out-Null
  if (-not $?) {
    Write-Host "error : failed to copy standalone." -ForegroundColor Red
    exit 1
  }

  $xmlPath = "$Path\src\project.xml"
  [xml]$xml = Get-Content -Path $xmlPath
  $xml.project.name = $Name
  $xml.Save($xmlPath)
} catch {
  Write-Host $_.Exception.Message -ForegroundColor Red
  exit 1
}
