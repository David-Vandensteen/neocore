function Start-Animator {
    $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
    $exe = "$projectBuildPath\tools\Animator.exe"

    if (-not (Test-Path -Path $exe)) { Install-SDK }

    Start-Process -NoNewWindow -FilePath $exe
    return $true
}
