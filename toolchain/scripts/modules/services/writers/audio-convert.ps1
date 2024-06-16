function Write-WAV {
  param(
    [Parameter(Mandatory=$true)][String] $mpg123,
    [Parameter(Mandatory=$true)][String] $MP3File,
    [Parameter(Mandatory=$true)][String] $WAVFile
  )
  Logger-Info -Message "convert $MP3File to $WAVFile"
  Start-Process -NoNewWindow -FilePath $mpg123 -ArgumentList "-w $WAVFile $MP3File" -Wait
}

function Write-MP3 {
  param(
    [Parameter(Mandatory=$true)][String] $ffmpeg,
    [Parameter(Mandatory=$true)][String] $MP3File,
    [Parameter(Mandatory=$true)][String] $WAVFile
  )
  Logger-Info -Message "convert $WAVFile to $MP3File"
  Write-Host $ffmpeg
  Write-Host $MP3File
  Write-Host $WAVFile
  Start-Process -NoNewWindow -FilePath $ffmpeg -ArgumentList "-i `"$WAVFile`" -b:a 192k `"$MP3File`"" -Wait
}