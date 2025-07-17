function Set-EnvPath {
  param (
    [Parameter(Mandatory=$true)][String] $GCCPath,
    [Parameter(Mandatory=$true)][String] $Bin
  )

  $gccPath = Get-TemplatePath -Path $GCCPath
  $binPath = Get-TemplatePath -Path $Bin
  if ($Rule -eq "sprite") {
    $env:path = "$binPath"
  } else {
    $env:path = "$gccPath;$binPath;$env:windir\System32;$env:windir\System32\WindowsPowerShell\v1.0\"
  }

  Write-Host "Env Path: $env:path"
  Write-Host "--------------------------------------------"
  Write-Host ""
}
