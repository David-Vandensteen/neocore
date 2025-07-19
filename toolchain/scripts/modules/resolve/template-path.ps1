function Resolve-TemplatePath {
  param(
    [Parameter(Mandatory=$true)][String] $Path
  )

  $resolvedPath = Get-TemplatePath -Path $Path
  if (-Not(Test-Path -Path $resolvedPath)) {
    Write-Host "Error: $resolvedPath not found" -ForegroundColor Red
    exit 1
  }

  return (Resolve-Path -Path $resolvedPath).Path
}