function Write-ZIP {
  param (
    [Parameter(Mandatory=$true)][String] $Path,
    [Parameter(Mandatory=$true)][String] $ISOFile,
    [Parameter(Mandatory=$true)][String] $OutputFile
  )
  Write-Host "compiling ZIP" -ForegroundColor Yellow
  if ((Test-Path -Path $ISOFile) -eq $false) { Write-Host "error - $ISOFile not found" -ForegroundColor Red; exit 1 }
  if ((Test-Path -Path $Path) -eq $false) { Write-Host "error - $Path not found" -ForegroundColor Red; exit 1 }

  if ((Test-Path -Path $OutputFile)) { Remove-Item $OutputFile -Force }
  Add-Type -Assembly System.IO.Compression.FileSystem
  $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
  [System.IO.Compression.ZipFile]::CreateFromDirectory($Path, $OutputFile, $compressionLevel, $false)

  if ((Test-Path -Path $OutputFile) -eq $true) {
    Write-Host "builded ZIP is available to $OutputFile" -ForegroundColor Green
    Write-Host ""
  } else {
    Write-Host "error - $OutputFile was not generated" -ForegroundColor Red
    exit 1
  }
}
