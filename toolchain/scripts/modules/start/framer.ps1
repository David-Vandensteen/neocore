function Start-Framer {
    $exe = "$($Config.project.buildPath)\neodev-sdk\m68k\bin\Framer.exe"

    if (-not (Test-Path -Path $exe)) { Install-SDK }

    Start-Process -NoNewWindow -FilePath $exe
}
