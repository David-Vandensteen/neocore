function Assert-ProjectName {
  param ([Parameter(Mandatory=$true)][string] $Name)

  if ($Name -like "*-*") { Write-Host "error : char - is not allowed in project name" -ForegroundColor Red; return $false }
  if ($Name -like "*\*") { Write-Host "error : char \ is not allowed in project name" -ForegroundColor Red; return $false }
  if ($Name -like "*/*") { Write-Host "error : char / is not allowed in project name" -ForegroundColor Red; return $false }
  if ($Name -like "*$*") { Write-Host "error : char $ is not allowed in project name" -ForegroundColor Red; return $false }
  if ($Name -like "*=*") { Write-Host "error : char = is not allowed in project name" -ForegroundColor Red; return $false }
  if ($Name -like "*@*") { Write-Host "error : char @ is not allowed in project name" -ForegroundColor Red; return $false }
  if ($Name -like "*(*") { Write-Host "error : char ( is not allowed in project name" -ForegroundColor Red; return $false }
  if ($Name -like "*)*") { Write-Host "error : char ) is not allowed in project name" -ForegroundColor Red; return $false }
  if ($Name -like "*{*") { Write-Host "error : char { is not allowed in project name" -ForegroundColor Red; return $false }
  if ($Name -like "*}*") { Write-Host "error : char } is not allowed in project name" -ForegroundColor Red; return $false }
  if ($Name -like "*#*") { Write-Host "error : char # is not allowed in project name" -ForegroundColor Red; return $false }
  if ($Name.Length -gt 16) { Write-Host "error : project name is too long (16 char max)" -ForegroundColor Red; return $false }

  Write-Host "project name is compliant" -ForegroundColor Green
  return $true
}