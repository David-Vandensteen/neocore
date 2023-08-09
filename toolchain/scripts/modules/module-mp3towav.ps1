function Write-WAV {
  param(
    [Parameter(Mandatory=$true)][String] $mpg123,
    [Parameter(Mandatory=$true)][String] $MP3File,
    [Parameter(Mandatory=$true)][String] $WAVFile
  )
  Logger-Info -Message "convert $MP3File to $WAVFile"
  Start-Process -NoNewWindow -FilePath $mpg123 -ArgumentList "-w $WAVFile $MP3File" -Wait
}