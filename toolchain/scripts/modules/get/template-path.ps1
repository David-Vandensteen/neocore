function Get-TemplatePath {
  param(
    [Parameter(Mandatory=$true)][String] $Path
  )

  $replacedPath = $Path.Replace("{{build}}", $Config.project.buildPath)
  $replacedPath = $replacedPath.Replace("{{neocore}}", $Config.project.neocorePath)
  $replacedPath = $replacedPath.Replace("{{name}}", $Config.project.name)

  if ($Path -ne $replacedPath) {
    Write-Host "Resolving template path: $Path to $replacedPath" -ForegroundColor Cyan
  }

  return $replacedPath
}
