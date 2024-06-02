function Logger-Info {
  param ([Parameter(Mandatory=$true)][String] $Message)
  Write-Host $message -ForegroundColor Blue
}

function Logger-Step {
  param ([Parameter(Mandatory=$true)][String] $Message)
  Write-Host $message -ForegroundColor Yellow
}

function Logger-Success {
  param ([Parameter(Mandatory=$true)][String] $Message)
  Write-Host $message -ForegroundColor Green
}

function Logger-Error {
  param ([Parameter(Mandatory=$true)][String] $Message)
  Write-Host "error : $Message" -ForegroundColor Red
  exit 1
}

