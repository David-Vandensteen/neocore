function Write-WAV {
  param(
    [Parameter(Mandatory=$true)][String] $mpg123,
    [Parameter(Mandatory=$true)][String] $MP3File,
    [Parameter(Mandatory=$true)][String] $WAVFile
  )
  Write-Host "Convert $MP3File $WAVFile" -ForegroundColor Cyan
  Start-Process -NoNewWindow -FilePath $mpg123 -ArgumentList "-w $WAVFile $MP3File" -Wait
}
