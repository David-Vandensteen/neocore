function Install-Component {
  param (
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $PathDownload,
    [Parameter(Mandatory=$true)][String] $PathInstall
  )

  $pathInstall = Get-TemplatePath -Path $PathInstall

  if (-not($(Test-Path -Path $pathInstall))) {
    Write-Host "  create $pathInstall" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $pathInstall -Force
  }

  $fileName = Split-Path -Path $URL -Leaf
  $pathDownload = Resolve-TemplatePath -Path $PathDownload
  $pathInstall = Resolve-TemplatePath -Path $PathInstall

  Write-Host "GET $fileName" -ForegroundColor Cyan
  Start-Download -URL $URL -Path $pathDownload

  if (-not($(Test-Path -Path "$pathDownload\$fileName"))) {
    Write-Host "  error : download failed" -ForegroundColor Red
    return $false
  }

  try {
    Expand-Archive -Path "$pathDownload\$fileName" -DestinationPath $pathInstall -Force -ErrorAction Stop
    Write-Host "  expanded $filename $pathInstall" -ForegroundColor Yellow
  } catch {
    Write-Host "  error : failed to expand archive $fileName" -ForegroundColor Red
    Write-Host "  error details: $($_.Exception.Message)" -ForegroundColor Red
    return $false
  }
  Write-Host ""

  Remove-Item -Path "$pathDownload\$fileName" -Force
  return $true
}