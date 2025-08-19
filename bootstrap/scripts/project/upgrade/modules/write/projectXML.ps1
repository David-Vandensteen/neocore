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
        NeocorePath = "..\neocore"
        BuildPath = "..\build"
        Makefile = "Makefile"
        DistPath = "..\dist"
        RaineExe = "{{build}}\raine\raine32.exe"
        MameExe = "{{build}}\mame\mame64.exe"
        CompilerPath = "..\build\gcc\gcc-2.95.2"
        IncludePath = "{{neocore}}\src-lib\include"
        LibraryPath = "{{neocore}}\src-lib"
    }

    $existingSoundSection = $null

    if (Test-Path $projectXmlPath) {
        try {
            [xml]$existingData = Get-Content -Path $projectXmlPath
            Write-Log -File $LogFile -Level "INFO" -Message "Read existing project.xml data"

            # Extract existing values to preserve them
            $nameNode = $existingData.SelectSingleNode("//name")
            $versionNode = $existingData.SelectSingleNode("//version")
            $platformNode = $existingData.SelectSingleNode("//platform")
            $neocorePathNode = $existingData.SelectSingleNode("//neocorePath")
            $buildPathNode = $existingData.SelectSingleNode("//buildPath")
            $makefileNode = $existingData.SelectSingleNode("//makefile")
            $distPathNode = $existingData.SelectSingleNode("//distPath")
            $raineNode = $existingData.SelectSingleNode("//raine/exeFile")
            $mameNode = $existingData.SelectSingleNode("//mame/exeFile")
            $compilerPathNode = $existingData.SelectSingleNode("//compiler/path")
            $includePathNode = $existingData.SelectSingleNode("//compiler/includePath")
            $libraryPathNode = $existingData.SelectSingleNode("//compiler/libraryPath")

            if ($nameNode) { $existingValues.ProjectName = $nameNode.InnerText }
            if ($versionNode) { $existingValues.ProjectVersion = $versionNode.InnerText }
            if ($platformNode) { $existingValues.Platform = $platformNode.InnerText }
            if ($neocorePathNode) { $existingValues.NeocorePath = $neocorePathNode.InnerText }
            if ($buildPathNode) { $existingValues.BuildPath = $buildPathNode.InnerText }
            if ($makefileNode) { $existingValues.Makefile = $makefileNode.InnerText }
            if ($distPathNode) { $existingValues.DistPath = $distPathNode.InnerText }
            if ($raineNode) { $existingValues.RaineExe = $raineNode.InnerText }
            if ($mameNode) { $existingValues.MameExe = $mameNode.InnerText }
            if ($compilerPathNode) { $existingValues.CompilerPath = $compilerPathNode.InnerText }
            if ($includePathNode) { $existingValues.IncludePath = $includePathNode.InnerText }
            if ($libraryPathNode) { $existingValues.LibraryPath = $libraryPathNode.InnerText }

            # Check if sound section exists and preserve it
            $soundNode = $existingData.SelectSingleNode("//sound")
            if ($soundNode) {
                # Move existing sound content into new <cd> structure
                $sfxNode = $soundNode.SelectSingleNode("sfx")
                $cddaNode = $soundNode.SelectSingleNode("cdda")

                if ($sfxNode -or $cddaNode) {
                    $existingSoundSection = "  <sound>`n    <cd>`n"

                    if ($sfxNode) {
                        $pcmNode = $sfxNode.SelectSingleNode("pcm")
                        $z80Node = $sfxNode.SelectSingleNode("z80")
                        $existingSoundSection += '      <sfx>' + "`n"
                        if ($pcmNode) { $existingSoundSection += '        <pcm>' + $pcmNode.InnerText + '</pcm>' + "`n" }
                        if ($z80Node) { $existingSoundSection += '        <z80>' + $z80Node.InnerText + '</z80>' + "`n" }
                        $existingSoundSection += '      </sfx>' + "`n"
                    }

                    if ($cddaNode) {
                        $existingSoundSection += '      <cdda>' + "`n"
                        $distNode = $cddaNode.SelectSingleNode("dist")
                        if ($distNode) {
                            $isoNode = $distNode.SelectSingleNode("iso")
                            if ($isoNode) {
                                $formatNode = $isoNode.SelectSingleNode("format")
                                $existingSoundSection += '        <dist>' + "`n"
                                $existingSoundSection += '          <iso>' + "`n"
                                if ($formatNode) { $existingSoundSection += '            <format>' + $formatNode.InnerText + '</format>' + "`n" }
                                $existingSoundSection += '          </iso>' + "`n"
                                $existingSoundSection += '        </dist>' + "`n"
                            }
                        }
                        $tracksNode = $cddaNode.SelectSingleNode("tracks")
                        if ($tracksNode) {
                            $existingSoundSection += '        <tracks>' + "`n"
                            $trackNodes = $tracksNode.SelectNodes("track")
                            foreach ($trackNode in $trackNodes) {
                                $idNode = $trackNode.SelectSingleNode("id")
                                $fileNode = $trackNode.SelectSingleNode("file")
                                $pregapNode = $trackNode.SelectSingleNode("pregap")
                                $existingSoundSection += '          <track>' + "`n"
                                if ($idNode) { $existingSoundSection += '            <id>' + $idNode.InnerText + '</id>' + "`n" }
                                if ($fileNode) { $existingSoundSection += '            <file>' + $fileNode.InnerText + '</file>' + "`n" }
                                if ($pregapNode) { $existingSoundSection += '            <pregap>' + $pregapNode.InnerText + '</pregap>' + "`n" }
                                $existingSoundSection += '          </track>' + "`n"
                            }
                            $existingSoundSection += '        </tracks>' + "`n"
                        }
                        $existingSoundSection += '      </cdda>' + "`n"
                    }

                    $existingSoundSection += '    </cd>' + "`n"
                    $existingSoundSection += '  </sound>'

                    Write-Log -File $LogFile -Level "INFO" -Message "Found existing sound section, moving content to new cd structure"
                }
            }

            # Check if chardata section exists and preserve it
            $chardataNode = $existingData.SelectSingleNode("//gfx/DAT/chardata")
            $existingChardataSection = $null
            if ($chardataNode) {
                # Preserve existing chardata structure and enhance setup
                $existingChardataSection = '      <chardata>' + "`n"

                # Process setup section with v3 enhancements
                $setupNode = $chardataNode.SelectSingleNode("setup")
                $existingChardataSection += '        <setup>' + "`n"

                # Add starting_tile first if it exists in user's setup
                if ($setupNode -and $setupNode.SelectSingleNode("starting_tile")) {
                    $existingChardataSection += '          <starting_tile>' + $setupNode.SelectSingleNode("starting_tile").InnerText + '</starting_tile>' + "`n"
                }

                # Add v3 required elements
                $existingChardataSection += '          <charfile>out\char.bin</charfile>' + "`n"
                $existingChardataSection += '          <mapfile>out\charMaps.s</mapfile>' + "`n"
                $existingChardataSection += '          <palfile>out\charPals.s</palfile>' + "`n"
                $existingChardataSection += '          <incfile>out\charInclude.h</incfile>' + "`n"
                $existingChardataSection += '          <incprefix>../</incprefix>' + "`n"

                # Preserve existing setup elements (except v3 ones and starting_tile to avoid duplication)
                if ($setupNode) {
                    $v3Elements = @('charfile', 'mapfile', 'palfile', 'incfile', 'incprefix', 'starting_tile')
                    foreach ($child in $setupNode.ChildNodes) {
                        if ($child.NodeType -eq [System.Xml.XmlNodeType]::Element -and $v3Elements -notcontains $child.Name) {
                            $existingChardataSection += '          <' + $child.Name + '>' + $child.InnerText + '</' + $child.Name + '>' + "`n"
                        }
                    }
                }
                $existingChardataSection += '        </setup>' + "`n"

                # Preserve other chardata elements (pict, import, etc.)
                foreach ($child in $chardataNode.ChildNodes) {
                    if ($child.NodeType -eq [System.Xml.XmlNodeType]::Element -and $child.Name -ne 'setup') {
                        $existingChardataSection += '        <' + $child.Name
                        # Add attributes if any
                        foreach ($attr in $child.Attributes) {
                            $existingChardataSection += ' ' + $attr.Name + '="' + $attr.Value + '"'
                        }
                        $existingChardataSection += '>' + "`n"
                        $existingChardataSection += '          <file>' + $child.SelectSingleNode('file').InnerText + '</file>' + "`n"
                        $existingChardataSection += '        </' + $child.Name + '>' + "`n"
                    }
                }
                $existingChardataSection += '      </chardata>'

                Write-Log -File $LogFile -Level "INFO" -Message "Found existing chardata section, preserved and enhanced with v3 setup"
            }

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
  <makefile>$($existingValues.Makefile)</makefile>
  <neocorePath>$($existingValues.NeocorePath)</neocorePath>
  <buildPath>$($existingValues.BuildPath)</buildPath>
  <distPath>$($existingValues.DistPath)</distPath>
  <gfx>
    <DAT>
"@

    # Add preserved chardata or default template
    if ($existingChardataSection) {
        $xmlContent += "`n" + $existingChardataSection + "`n"
    } else {
        # Default chardata template if none exists
        $xmlContent += @"

      <chardata>
        <setup>
          <charfile>out\char.bin</charfile>
          <mapfile>out\charMaps.s</mapfile>
          <palfile>out\charPals.s</palfile>
          <incfile>out\charInclude.h</incfile>
          <incprefix>../</incprefix>
        </setup>
      </chardata>
"@
    }

    $xmlContent += @"
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
"@

    # Add sound section if it exists in the original file
    if ($existingSoundSection) {
        $xmlContent += "`n$existingSoundSection`n"
    }

    $xmlContent += @"

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
    <includePath>{{neocore}}\src-lib\include</includePath>
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
