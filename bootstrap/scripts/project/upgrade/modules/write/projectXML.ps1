function Write-ProjectXML {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath,

        [Parameter(Mandatory=$true)]
        [string]$TargetVersion,

        [Parameter(Mandatory=$true)]
        [string]$LogFile
    )

    $projectXmlPath = "$ProjectSrcPath\project.xml"

    Write-Host "Updating project.xml to NeoCore v3 format..." -ForegroundColor Cyan
    Write-Log -File $LogFile -Level "INFO" -Message "Starting project.xml migration to v3 format"

    # Read existing project.xml if it exists to preserve values
    $existingValues = @{
        ProjectName = "DefaultProject"
        ProjectVersion = "1.0.0"
        Platform = "cd"
        RaineExe = "{{build}}\raine\raine32.exe"
        MameExe = "{{build}}\mame\mame64.exe"
        CompilerPath = "{{build}}\gcc\gcc-2.95.2"
        IncludePath = "{{neocore}}\src-lib\include"
        LibraryPath = "{{neocore}}\src-lib"
    }

    if (Test-Path $projectXmlPath) {
        try {
            [xml]$existingData = Get-Content -Path $projectXmlPath
            Write-Log -File $LogFile -Level "INFO" -Message "Read existing project.xml data"

            # Extract existing values to preserve them
            $nameNode = $existingData.SelectSingleNode("//name")
            $versionNode = $existingData.SelectSingleNode("//version")
            $platformNode = $existingData.SelectSingleNode("//platform")
            $raineNode = $existingData.SelectSingleNode("//raine/exeFile")
            $mameNode = $existingData.SelectSingleNode("//mame/exeFile")
            $compilerPathNode = $existingData.SelectSingleNode("//compiler/path")
            $includePathNode = $existingData.SelectSingleNode("//compiler/includePath")
            $libraryPathNode = $existingData.SelectSingleNode("//compiler/libraryPath")

            if ($nameNode) { $existingValues.ProjectName = $nameNode.InnerText }
            if ($versionNode) { $existingValues.ProjectVersion = $versionNode.InnerText }
            if ($platformNode) { $existingValues.Platform = $platformNode.InnerText }
            if ($raineNode) { $existingValues.RaineExe = $raineNode.InnerText }
            if ($mameNode) { $existingValues.MameExe = $mameNode.InnerText }
            if ($compilerPathNode) { $existingValues.CompilerPath = $compilerPathNode.InnerText }
            if ($includePathNode) { $existingValues.IncludePath = $includePathNode.InnerText }
            if ($libraryPathNode) { $existingValues.LibraryPath = $libraryPathNode.InnerText }

        } catch {
            Write-Host "WARNING: Failed to read existing project.xml: $($_.Exception.Message)" -ForegroundColor Yellow
            Write-Log -File $LogFile -Level "WARNING" -Message "Failed to read existing project.xml: $($_.Exception.Message)"
        }
    }

    # Create new project.xml content for NeoCore v3 (real structure)
    $xmlContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<project>
  <name>$($existingValues.ProjectName)</name>
  <version>$($existingValues.ProjectVersion)</version>
  <platform>$($existingValues.Platform)</platform>
  <neocorePath>{{neocore}}</neocorePath>
  <buildPath>{{neocore}}\build</buildPath>
  <makefile>..\Makefile</makefile>
  <gfx>
    <DAT>
      <chardata>
        <setup fileType="char">
          <charfile>out\char.bin</charfile>
          <mapfile>out\charMaps.s</mapfile>
          <palfile>out\charPals.s</palfile>
          <incfile>out\charData.h</incfile>
          <incprefix>../</incprefix>
        </setup>
        <import bank="0">
          <file>assets\sprites\sprites.bmp</file>
        </import>
      </chardata>
      <fixdata>
        <chardata>
          <setup fileType="fix">
            <charfile>out\fix.bin</charfile>
            <palfile>out\fixPals.s</palfile>
            <incfile>out\fixData.h</incfile>
          </setup>
          <import bank="0">
            <file>{{build}}\fix\systemFont.bin</file>
          </import>
        </chardata>
      </fixdata>
    </DAT>
  </gfx>
  <emulator>
    <raine>
      <exeFile>$($existingValues.RaineExe)</exeFile>
      <config>
        <default>{{build}}\raine\config\default.cfg</default>
        <full>{{build}}\raine\config\fullscreen.cfg</full>
        <yuv>{{build}}\raine\config\yuv.cfg</yuv>
      </config>
    </raine>
    <mame>
      <exeFile>$($existingValues.MameExe)</exeFile>
      <profile>
        <default>-window -skip_gameinfo neocdz</default>
        <full>-nowindow -skip_gameinfo neocdz</full>
        <nosound>-sound none -window -skip_gameinfo neocdz</nosound>
        <debug>-debug -window -skip_gameinfo neocdz</debug>
      </profile>
    </mame>
  </emulator>
  <compiler>
    <name>gcc</name>
    <version>2.95.2</version>
    <path>$($existingValues.CompilerPath)</path>
    <includePath>$($existingValues.IncludePath)</includePath>
    <libraryPath>$($existingValues.LibraryPath)</libraryPath>
    <crtPath>{{neocore}}\src-lib\crt</crtPath>
    <systemFile>
      <cd>{{neocore}}\src-lib\system\neocd.x</cd>
      <cartridge>{{neocore}}\src-lib\system\neocart.x</cartridge>
    </systemFile>
  </compiler>
</project>
"@

    try {
        # Write new project.xml
        $xmlContent | Out-File -FilePath $projectXmlPath -Encoding UTF8 -Force

        Write-Host "Successfully updated project.xml to NeoCore v3 format" -ForegroundColor Green
        Write-Host "  - Project: $($existingValues.ProjectName) v$($existingValues.ProjectVersion)" -ForegroundColor White
        Write-Host "  - Platform: $($existingValues.Platform)" -ForegroundColor White
        Write-Host "  - NeoCore Target: $TargetVersion" -ForegroundColor White

        Write-Log -File $LogFile -Level "SUCCESS" -Message "Successfully updated project.xml to NeoCore v3 format (version: $TargetVersion)"
        return $true

    } catch {
        Write-Host "ERROR: Failed to write project.xml: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -File $LogFile -Level "ERROR" -Message "Failed to write project.xml: $($_.Exception.Message)"
        return $false
    }
}
