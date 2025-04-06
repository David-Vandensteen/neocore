function Resolve-TemplatePath {
  param(
    [Parameter(Mandatory=$true)][String] $Path
  )

  $resolvedPath = Get-TemplatePath -Path $Path

  return (Resolve-Path -Path $resolvedPath).Path
}