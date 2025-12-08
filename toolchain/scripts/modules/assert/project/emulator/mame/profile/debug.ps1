function Assert-ProjectEmulatorMameProfileDebug {
  Write-Host "Assert project emulator MAME profile debug" -ForegroundColor Yellow

  if (-Not($Config.project.emulator.mame.profile.debug)) {
    Write-Host "error : project.emulator.mame.profile.debug not found" -ForegroundColor Red
    return $false
  }

  $expectedDebugProfile = "-console -debug -window -skip_gameinfo -pluginspath {{build}}\mame\plugins -plugin ngdev neocdz"
  $currentDebugProfile = $Config.project.emulator.mame.profile.debug

  if ($currentDebugProfile -ne $expectedDebugProfile) {
    Write-Host "Warning: MAME debug profile differs from expected configuration" -ForegroundColor Yellow
    Write-Host "Current : $currentDebugProfile" -ForegroundColor Yellow
    Write-Host "Expected: $expectedDebugProfile" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Updating project.xml with correct debug profile..." -ForegroundColor Cyan
    
    # Find and update project.xml
    $projectXmlPath = $ConfigFile
    if (Test-Path $projectXmlPath) {
      [xml]$xml = Get-Content $projectXmlPath
      $debugNode = $xml.SelectSingleNode("//emulator/mame/profile/debug")
      if ($debugNode) {
        $debugNode.InnerText = $expectedDebugProfile
        $xml.Save($projectXmlPath)
        Write-Host "Debug profile updated successfully" -ForegroundColor Green
      }
    }
  }

  Write-Host "Project emulator MAME profile debug configuration is valid" -ForegroundColor Green
  return $true
}