function Write-MP3 {
  param(
    [Parameter(Mandatory=$true)][String] $ffmpeg,
    [Parameter(Mandatory=$true)][String] $MP3File,
    [Parameter(Mandatory=$true)][String] $WAVFile
  )
  Write-Host "Convert $WAVFile $MP3File" -ForegroundColor Cyan
  Write-Host $ffmpeg
  Write-Host $MP3File
  Write-Host $WAVFile
  Start-Process -NoNewWindow -FilePath $ffmpeg -ArgumentList "-y -i `"$WAVFile`" -b:a 192k `"$MP3File`"" -Wait
}