function Download {
  param (
    [Parameter(Mandatory=$true)][String] $URL,
    [Parameter(Mandatory=$true)][String] $Path
  )
  Write-Host "Download - $URL $Path"
  $fileName = Split-Path $URL -leaf

  $start_time = Get-Date
  Invoke-WebRequest -URI $URL -Outfile $Path"\"$fileName
  Write-Host "Time taken - $((Get-Date).Subtract($start_time).Seconds) second(s)"
}