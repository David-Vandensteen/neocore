function Assert-Path {
  if ((Test-Path -Path $Config.project.makefile) -eq $false) {
    Write-Host "error : $($Config.project.makefile) not found" -ForegroundColor Red
    return $false
  }
  if ((Test-Path -Path $Config.project.neocorePath) -eq $false) {
    Write-Host "error : $($Config.project.neocorePath) not found" -ForegroundColor Red
    return $false
  }

  Write-Host "path is compliant" -ForegroundColor Green
  return $true
}

function Assert-PathLength {
  param(
    [Parameter(Mandatory=$true)]
    [string]$Path,
    [int]$MaxLength = 100
  )

  if ($Path.Length -gt $MaxLength) {
    Write-Host "error : Path length ($($Path.Length)) exceeds maximum of $MaxLength characters: $Path" -ForegroundColor Red
    return $false
  }

  Write-Host "path length is compliant ($($Path.Length)/$MaxLength characters)" -ForegroundColor Green
  return $true
}
