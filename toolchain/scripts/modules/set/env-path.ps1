function Set-EnvPath {
  param (
    [Parameter(Mandatory=$true)][String] $GCCPath,
    [Parameter(Mandatory=$true)][String] $Bin
  )

  $env:path = "$GCCPath;$Bin;$env:windir\System32;$env:windir\System32\WindowsPowerShell\v1.0\"

  Write-Host "Env Path: $env:path"
  Write-Host "--------------------------------------------"
  Write-Host ""
}
