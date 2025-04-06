function Get-TemplatePath {
  param(
    [Parameter(Mandatory=$true)][String] $Path
  )

  return $Path.Replace("{{build}}", $Config.project.buildPath)
}