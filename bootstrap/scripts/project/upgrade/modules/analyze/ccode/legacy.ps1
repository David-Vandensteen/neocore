function Analyze-CCodeLegacy {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath,

        [Parameter(Mandatory=$true)]
        [string]$LogFile
    )

    # Helper function to get relative path (Windows PowerShell compatible)
    function Get-RelativePath {
        param(
            [string]$FullPath,
            [string]$BasePath
        )

        try {
            # Normalize paths
            $FullPath = $FullPath.TrimEnd('\', '/')
            $BasePath = $BasePath.TrimEnd('\', '/')

            # Convert to absolute paths
            $fullPathResolved = (Resolve-Path -Path $FullPath).Path
            $basePathResolved = (Resolve-Path -Path $BasePath).Path

            # Simple relative path calculation
            if ($fullPathResolved.StartsWith($basePathResolved)) {
                $relativePath = $fullPathResolved.Substring($basePathResolved.Length)
                $relativePath = $relativePath.TrimStart('\', '/')
                # Convert backslashes to forward slashes for consistency
                return $relativePath -replace '\\', '/'
            } else {
                # If not under base path, just return filename
                return Split-Path $FullPath -Leaf
            }
        } catch {
            # Fallback: just return filename if relative path calculation fails
            return Split-Path $FullPath -Leaf
        }
    }

    Write-Host "Analyzing C code for legacy patterns..." -ForegroundColor Cyan
    Write-Log -File $LogFile -Level "INFO" -Message "Starting C code legacy analysis"
    Write-Log -File $LogFile -Level "INFO" -Message "ProjectSrcPath: '$ProjectSrcPath'"

    # Define legacy patterns to detect
    $LegacyPatterns = @{
        # Position return type changes (v2 returns Vec2short, v3 uses Position* output parameter)
        "nc_get_position_gfx_animated_sprite() return value" = @{
            Pattern = "Vec2short\s+\w+\s*=\s*nc_get_position_gfx_animated_sprite\s*\("
            Issue = "nc_get_position_gfx_animated_sprite() signature changed in v3 (now uses output parameter)"
            Suggestion = "Change to: Position pos; nc_get_position_gfx_animated_sprite(&sprite, &pos);"
        }

        "nc_get_position_gfx_picture() return value" = @{
            Pattern = "Vec2short\s+\w+\s*=\s*nc_get_position_gfx_picture\s*\("
            Issue = "nc_get_position_gfx_picture() signature changed in v3 (now uses output parameter)"
            Suggestion = "Change to: Position pos; nc_get_position_gfx_picture(&picture, &pos);"
        }

        "nc_get_position_gfx_scroller() return value" = @{
            Pattern = "Vec2short\s+\w+\s*=\s*nc_get_position_gfx_scroller\s*\("
            Issue = "nc_get_position_gfx_scroller() signature changed in v3 (now uses output parameter)"
            Suggestion = "Change to: Position pos; nc_get_position_gfx_scroller(&scroller, &pos);"
        }

        # Breaking change: nc_get_relative_position signature
        "nc_get_relative_position() old signature" = @{
            Pattern = "Vec2short\s+\w+\s*=\s*nc_get_relative_position\s*\(\s*[^,]*,\s*[^)]*\s*\)"
            Issue = "nc_get_relative_position() signature changed in v3 (now takes Position* as first parameter)"
            Suggestion = "Change to: Position pos; nc_get_relative_position(&pos, box, world_coord);"
        }

        # Vec2short type usage (replaced with Position in v3)
        "Vec2short type usage" = @{
            Pattern = "Vec2short\s+\w+"
            Issue = "Vec2short type deprecated in v3, replaced with Position"
            Suggestion = "Replace Vec2short with Position type"
        }

        # Direct member access on position functions (v3 signature change)
        "nc_get_position_gfx_picture_physic().x access" = @{
            Pattern = "nc_get_position_gfx_picture_physic\s*\([^)]*\)\s*\.\s*x"
            Issue = "nc_get_position_gfx_picture_physic() signature changed in v3 (now uses output parameter)"
            Suggestion = "Change to: Position pos; nc_get_position_gfx_picture_physic(&picture, &pos); then use pos.x"
        }

        "nc_get_position_gfx_picture_physic().y access" = @{
            Pattern = "nc_get_position_gfx_picture_physic\s*\([^)]*\)\s*\.\s*y"
            Issue = "nc_get_position_gfx_picture_physic() signature changed in v3 (now uses output parameter)"
            Suggestion = "Change to: Position pos; nc_get_position_gfx_picture_physic(&picture, &pos); then use pos.y"
        }

        "nc_get_position_gfx_animated_sprite().x access" = @{
            Pattern = "nc_get_position_gfx_animated_sprite\s*\([^)]*\)\s*\.\s*x"
            Issue = "nc_get_position_gfx_animated_sprite() signature changed in v3 (now uses output parameter)"
            Suggestion = "Change to: Position pos; nc_get_position_gfx_animated_sprite(&sprite, &pos); then use pos.x"
        }

        "nc_get_position_gfx_animated_sprite().y access" = @{
            Pattern = "nc_get_position_gfx_animated_sprite\s*\([^)]*\)\s*\.\s*y"
            Issue = "nc_get_position_gfx_animated_sprite() signature changed in v3 (now uses output parameter)"
            Suggestion = "Change to: Position pos; nc_get_position_gfx_animated_sprite(&sprite, &pos); then use pos.y"
        }

        "nc_get_position_gfx_picture().x access" = @{
            Pattern = "nc_get_position_gfx_picture\s*\([^)]*\)\s*\.\s*x"
            Issue = "nc_get_position_gfx_picture() signature changed in v3 (now uses output parameter)"
            Suggestion = "Change to: Position pos; nc_get_position_gfx_picture(&picture, &pos); then use pos.x"
        }

        "nc_get_position_gfx_picture().y access" = @{
            Pattern = "nc_get_position_gfx_picture\s*\([^)]*\)\s*\.\s*y"
            Issue = "nc_get_position_gfx_picture() signature changed in v3 (now uses output parameter)"
            Suggestion = "Change to: Position pos; nc_get_position_gfx_picture(&picture, &pos); then use pos.y"
        }

        "nc_get_position_gfx_scroller().x access" = @{
            Pattern = "nc_get_position_gfx_scroller\s*\([^)]*\)\s*\.\s*x"
            Issue = "nc_get_position_gfx_scroller() signature changed in v3 (now uses output parameter)"
            Suggestion = "Change to: Position pos; nc_get_position_gfx_scroller(&scroller, &pos); then use pos.x"
        }

        "nc_get_position_gfx_scroller().y access" = @{
            Pattern = "nc_get_position_gfx_scroller\s*\([^)]*\)\s*\.\s*y"
            Issue = "nc_get_position_gfx_scroller() signature changed in v3 (now uses output parameter)"
            Suggestion = "Change to: Position pos; nc_get_position_gfx_scroller(&scroller, &pos); then use pos.y"
        }

        # Deprecated logging functions from v2
        "nc_log() function" = @{
            Pattern = "nc_log\s*\(\s*`"[^`"]*`"\s*\)\s*;"
            Issue = "nc_log() function removed in v3"
            Suggestion = "Replace with nc_log_info_line()"
        }

        "nc_log_vec2short()" = @{
            Pattern = "nc_log_vec2short\s*\("
            Issue = "nc_log_vec2short() function removed in v3"
            Suggestion = "Replace with nc_log_position() and update parameter type from Vec2short to Position"
        }

        "nc_log_word() with label" = @{
            Pattern = "nc_log_word\s*\(\s*`"[^`"]*`"\s*,"
            Issue = "nc_log_word() signature changed in v3 (label parameter removed)"
            Suggestion = "Remove label parameter: nc_log_word(value) or use nc_log_info() first"
        }

        "nc_log_int() with label" = @{
            Pattern = "nc_log_int\s*\(\s*`"[^`"]*`"\s*,"
            Issue = "nc_log_int() signature changed in v3 (label parameter removed)"
            Suggestion = "Remove label parameter: nc_log_int(value) or use nc_log_info() first"
        }

        "nc_log_short() with label" = @{
            Pattern = "nc_log_short\s*\(\s*`"[^`"]*`"\s*,"
            Issue = "nc_log_short() signature changed in v3 (label parameter removed)"
            Suggestion = "Remove label parameter: nc_log_short(value) or use nc_log_info() first"
        }
    }

    # Get all C files in the project
    $cFiles = @()
    $searchPatterns = @("*.c", "*.h")

    foreach ($pattern in $searchPatterns) {
        try {
            $files = Get-ChildItem -Path $ProjectSrcPath -Filter $pattern -Recurse -File -ErrorAction SilentlyContinue
            # Additional check to ensure we only get files, not directories
            $validFiles = $files | Where-Object { $_.PSIsContainer -eq $false -and (Test-Path $_.FullName -PathType Leaf) }
            $cFiles += $validFiles
        } catch {
            Write-Log -File $LogFile -Level "WARNING" -Message "Error scanning for $pattern files: $($_.Exception.Message)"
        }
    }

    # Exclude build and common non-source directories
    $excludePatterns = @("*\build\*", "*\out\*", "*\bin\*", "*\obj\*", "*\.git\*")
    $filteredFiles = $cFiles | Where-Object {
        $filePath = $_.FullName
        $shouldInclude = $true

        foreach ($excludePattern in $excludePatterns) {
            if ($filePath -like $excludePattern) {
                $shouldInclude = $false
                break
            }
        }
        return $shouldInclude
    }

    Write-Log -File $LogFile -Level "INFO" -Message "Found $($filteredFiles.Count) C files to analyze"

    $allIssues = @()
    $filesWithIssues = 0

    # Analyze each file
    foreach ($file in $filteredFiles) {
        try {
            $fileContent = Get-Content -Path $file.FullName -Raw -ErrorAction Stop
            $fileIssues = @()

            # Scan for each legacy pattern
            foreach ($patternName in $LegacyPatterns.Keys) {
                $patternInfo = $LegacyPatterns[$patternName]
                $pattern = $patternInfo.Pattern

                if ($fileContent -match $pattern) {
                    # Find all matches with line numbers
                    $lines = $fileContent -split "`r?`n"

                    for ($i = 0; $i -lt $lines.Count; $i++) {
                        if ($lines[$i] -match $pattern) {
                            # Calculate relative path for this file
                            $relativePath = Get-RelativePath -FullPath $file.FullName -BasePath $ProjectSrcPath

                            $issue = [PSCustomObject]@{
                                File = $relativePath  # Use relative path instead of just filename
                                FullPath = $file.FullName
                                Line = $i + 1
                                Pattern = $patternName
                                Issue = $patternInfo.Issue
                                Suggestion = $patternInfo.Suggestion
                                Code = $lines[$i].Trim()
                            }
                            $fileIssues += $issue
                            $allIssues += $issue

                            # Log detailed information for each pattern found (using relative path)
                            Write-Log -File $LogFile -Level "WARNING" -Message "LEGACY PATTERN DETECTED in $relativePath at line $($i + 1): $($patternInfo.Issue)"
                            Write-Log -File $LogFile -Level "INFO" -Message "  Code: $($lines[$i].Trim())"
                            Write-Log -File $LogFile -Level "INFO" -Message "  Suggestion: $($patternInfo.Suggestion)"
                        }
                    }
                }
            }

            if ($fileIssues.Count -gt 0) {
                $filesWithIssues++
                Write-Log -File $LogFile -Level "INFO" -Message "Found $($fileIssues.Count) legacy patterns in $($file.Name)"
            }

        } catch {
            Write-Log -File $LogFile -Level "ERROR" -Message "Error analyzing file $($file.FullName): $($_.Exception.Message)"
        }
    }

    # Report results
    if ($allIssues.Count -gt 0) {
        Write-Host "Legacy code analysis completed:" -ForegroundColor Yellow
        Write-Host "  - Files analyzed: $($filteredFiles.Count)" -ForegroundColor White
        Write-Host "  - Files with issues: $filesWithIssues" -ForegroundColor White
        Write-Host "  - Total legacy patterns found: $($allIssues.Count)" -ForegroundColor White
        Write-Host ""
        Write-Host "Files requiring manual review:" -ForegroundColor Yellow

        # Show only file summary on console (detailed info is in log) - using relative paths
        $issuesByFile = $allIssues | Group-Object -Property File
        foreach ($fileGroup in $issuesByFile) {
            $displayName = if ([string]::IsNullOrWhiteSpace($fileGroup.Name)) {
                "<unknown file>"
            } else {
                $fileGroup.Name  # Already contains relative path
            }
            $patternCount = $fileGroup.Count
            Write-Host "  - ${displayName}: ${patternCount} pattern(s)" -ForegroundColor Red
        }
        Write-Host ""
        Write-Host "See upgrade.log for detailed analysis and suggestions." -ForegroundColor Cyan

        Write-Log -File $LogFile -Level "WARNING" -Message "Legacy code analysis completed: $($allIssues.Count) patterns found in $filesWithIssues files requiring manual review"

        return $false  # Manual intervention required
    } else {
        Write-Host "Legacy code analysis completed successfully:" -ForegroundColor Green
        Write-Host "  - Files analyzed: $($filteredFiles.Count)" -ForegroundColor White
        Write-Host "  - No legacy patterns detected" -ForegroundColor Green
        Write-Log -File $LogFile -Level "SUCCESS" -Message "Legacy code analysis completed: no legacy patterns detected in $($filteredFiles.Count) files"
        return $true
    }
}
