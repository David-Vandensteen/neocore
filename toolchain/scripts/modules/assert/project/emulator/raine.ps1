
function Assert-ProjectEmulatorRaineExeFile {
	Write-Host "Assert project emulator RAINE exeFile" -ForegroundColor Yellow

	if (-Not($Config.project.emulator.raine.exeFile)) {
		Write-Host "error : project.emulator.raine.exeFile not found" -ForegroundColor Red
		return $false
	}

	$expectedExeFile = "{{build}}\raine\raine.exe"
	$currentExeFile = $Config.project.emulator.raine.exeFile

	if ($currentExeFile -ne $expectedExeFile) {
		Write-Host "Warning: RAINE exeFile differs from expected configuration" -ForegroundColor Yellow
		Write-Host "Current : $currentExeFile" -ForegroundColor Yellow
		Write-Host "Expected: $expectedExeFile" -ForegroundColor Yellow
		Write-Host ""
		Write-Host "Updating project.xml with correct exeFile..." -ForegroundColor Cyan

		# Find and update project.xml
		$projectXmlPath = $ConfigFile
		if (Test-Path $projectXmlPath) {
			[xml]$xml = Get-Content $projectXmlPath
			$exeNode = $xml.SelectSingleNode("//emulator/raine/exeFile")
			if ($exeNode) {
				$exeNode.InnerText = $expectedExeFile
				$xml.Save($projectXmlPath)
				Write-Host "RAINE exeFile updated successfully" -ForegroundColor Green
			}
		}
	}

	Write-Host "Project emulator RAINE exeFile configuration is valid" -ForegroundColor Green
	return $true
}
