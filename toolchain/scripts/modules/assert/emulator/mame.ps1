function Assert-EmulatorMame {
    $mameExeFile = $Config.project.emulator.mame.exeFile

    if (-not $mameExeFile) {
        Write-Host "Error: <exeFile> is missing in <mame> section of project.xml" -ForegroundColor Red
        return $false
    }

    Write-Host "Project emulator MAME <exeFile> tag is present in project.xml" -ForegroundColor Green
    return $true
}
