Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\services\installers\sdk.ps1"

function RunnerFramer {
    $exe = "$($Config.project.buildPath)\neodev-sdk\m68k\bin\Framer.exe"

    if (-not (Test-Path -Path $exe)) { Install-SDK }

    Start-Process -NoNewWindow -FilePath $exe
}
