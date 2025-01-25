Import-Module "$($config.project.neocorePath)\toolchain\scripts\modules\install\sdk.ps1"

function Start-Animator {
    $exe = "$($Config.project.buildPath)\neodev-sdk\m68k\bin\Animator.exe"

    if (-not (Test-Path -Path $exe)) { Install-SDK }

    Start-Process -NoNewWindow -FilePath $exe
}
