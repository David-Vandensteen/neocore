function Model-Project-Name {
  param ([Parameter(Mandatory=$true)][string] $Name)

  if ($Name -like "*-*") { Write-Host "error : char - is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Name -like "*\*") { Write-Host "error : char \ is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Name -like "*/*") { Write-Host "error : char / is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Name -like "*$*") { Write-Host "error : char $ is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Name -like "*=*") { Write-Host "error : char = is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Name -like "*@*") { Write-Host "error : char @ is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Name -like "*(*") { Write-Host "error : char ( is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Name -like "*)*") { Write-Host "error : char ) is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Name -like "*{*") { Write-Host "error : char { is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Name -like "*}*") { Write-Host "error : char } is not allowed in project name" -ForegroundColor Red; exit 1 }
  if ($Name -like "*#*") { Write-Host "error : char # is not allowed in project name" -ForegroundColor Red; exit 1 }

}