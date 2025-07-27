function Set-EnvPath {
  param (
    [Parameter(Mandatory=$true)][String] $GCCPath,
    [Parameter(Mandatory=$true)][String] $Bin
  )

  try {
    # Resolve template paths with error handling
    $gccPath = Get-TemplatePath -Path $GCCPath
    $binPath = Get-TemplatePath -Path $Bin

    # Validate that paths were resolved successfully
    if ([string]::IsNullOrEmpty($gccPath)) {
      Write-Host "Error: Failed to resolve GCC path: $GCCPath" -ForegroundColor Red
      return $false
    }

    if ([string]::IsNullOrEmpty($binPath)) {
      Write-Host "Error: Failed to resolve Bin path: $Bin" -ForegroundColor Red
      return $false
    }

    # Set environment path based on rule
    if ($Rule -eq "sprite") {
      $env:path = "$binPath"
    } else {
      $env:path = "$gccPath;$binPath;$env:windir\System32;$env:windir\System32\WindowsPowerShell\v1.0\"
    }

    # Validate that environment path was set
    if ([string]::IsNullOrEmpty($env:path)) {
      Write-Host "Error: Failed to set environment path" -ForegroundColor Red
      return $false
    }

    Write-Host "Env Path: $env:path"
    Write-Host "--------------------------------------------"
    Write-Host ""
    return $true

  } catch {
    Write-Host "Error setting environment path: $($_.Exception.Message)" -ForegroundColor Red
    return $false
  }
}
