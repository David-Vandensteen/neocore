function Download {
  param (
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $Path
  )
  Write-Host "Download - $URL $Path"
  Import-Module BitsTransfer

  $start_time = Get-Date
  Start-BitsTransfer -Source $URL -Destination $Path
  Write-Host "Time taken - $((Get-Date).Subtract($start_time).Seconds) second(s)"
}