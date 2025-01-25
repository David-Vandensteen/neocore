function Write-MP3 {
  param(
    [Parameter(Mandatory=$true)][String] $ffmpeg,
    [Parameter(Mandatory=$true)][String] $MP3File,
    [Parameter(Mandatory=$true)][String] $WAVFile
  )
  Logger-Info -Message "convert $WAVFile $MP3File"
  Write-Host $ffmpeg
  Write-Host $MP3File
  Write-Host $WAVFile
  Start-Process -NoNewWindow -FilePath $ffmpeg -ArgumentList "-i `"$WAVFile`" -b:a 192k `"$MP3File`"" -Wait
}