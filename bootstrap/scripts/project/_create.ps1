param (
  [Parameter(Mandatory=$true)]
  [string]$Name,

  [Parameter(Mandatory=$true)]
  [string]$Path
)

function Show-Error {
  param ($message)
  Write-Host "error : $message" -ForegroundColor Red
  exit 1
}

if (-not (Test-Path $Path)) {
  Import-Module "..\..\..\toolchain\scripts\modules\assert\project-name.ps1"
  Assert-ProjectName -Name $Name
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

    $crt0cdContent = [System.IO.File]::ReadAllText("..\..\..\bootstrap\standalone\crt0_cd.s").Replace("/*project_name*/", $Name.PadRight(16))
    [System.IO.File]::WriteAllText("$Path\src\crt0_cd.s", $crt0cdContent)
  } catch {
    Show-Error $_.Exception.Message
  }
} else {
  Write-Host "$Path already exists" -ForegroundColor Yellow
}
