function Resolve-TemplatePath {
  param(
    [Parameter(Mandatory=$true)][String] $Path
  )

  $resolvedPath = Get-TemplatePath -Path $Path
  if (-Not(Test-Path -Path $resolvedPath)) {
    Write-Host "Error: $resolvedPath not found" -ForegroundColor Red
    return $null
  }

  return (Resolve-Path -Path $resolvedPath).Path
}