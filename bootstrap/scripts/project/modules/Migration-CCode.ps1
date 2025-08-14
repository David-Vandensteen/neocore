# Migration-CCode.ps1
# C code analysis for v2 to v3 migration

# Import dependencies
if (-not (Get-Command Write-MigrationLog -ErrorAction SilentlyContinue)) {
    . "$PSScriptRoot\Migration-Logging.ps1"
}

function Test-CFileV3Compatibility {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath,

        [Parameter(Mandatory=$true)]
        [string]$FileContent
    )

    $issues = @()

    # Define breaking patterns for v2->v3 migration (REAL patterns only)
    $BreakingPatterns = @{
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

        # REAL deprecated logging functions from v2 (only the ones that actually existed)
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

    # Scan for patterns with line number detection
    foreach ($patternName in $BreakingPatterns.Keys) {
        $patternInfo = $BreakingPatterns[$patternName]
        $pattern = $patternInfo.Pattern

        if ($FileContent -match $pattern) {
            # Find all matches with line numbers
            $lines = $FileContent -split "`r?`n"
            $matchedLines = @()

            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -match $pattern) {
                    $matchedLines += ($i + 1)  # Line numbers are 1-based
                }
            }

            $count = $matchedLines.Count
            $lineInfo = if ($count -eq 1) { "line $($matchedLines[0])" }
                       elseif ($count -le 3) { "lines $($matchedLines -join ', ')" }
                       else { "lines $($matchedLines[0]), $($matchedLines[1]), ... (+$($count-2) more)" }

            $issueDescription = "$($patternInfo.Issue) ($count occurrence$(if($count -gt 1){'s'}) at $lineInfo)"
            $issues += $issueDescription

            Write-MigrationLog -Message "Found pattern '$patternName' in $FilePath`: $issueDescription" -Level "WARN"
        }
    }

    # Check for hardcoded version references with line numbers
    if ($FileContent -match "(?i)(neocore|datlib)\s*(version\s*)?2\.\d+") {
        $lines = $FileContent -split "`r?`n"
        $matchedLines = @()

        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match "(?i)(neocore|datlib)\s*(version\s*)?2\.\d+") {
                $matchedLines += ($i + 1)
            }
        }

        $lineInfo = if ($matchedLines.Count -eq 1) { "line $($matchedLines[0])" }
                   else { "lines $($matchedLines -join ', ')" }

        $issues += "Hardcoded v2 version references found (at $lineInfo)"
        Write-MigrationLog -Message "Hardcoded v2 version references in $FilePath at $lineInfo" -Level "WARN"
    }

    if ($issues.Count -eq 0) {
        Write-MigrationLog -Message "File $FilePath appears to be v3 compatible" -Level "INFO"
    } else {
        Write-MigrationLog -Message "Found $($issues.Count) potential v2/v3 compatibility issues in $FilePath" -Level "WARN"
    }

    return $issues
}

function Get-CFilesInProject {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectPath
    )

    Write-MigrationLog -Message "Scanning for C files in: $ProjectPath" -Level "INFO"

    # Get all C files recursively
    $cFiles = @()
    $searchPatterns = @("*.c", "*.h", "*.cpp", "*.hpp")

    foreach ($pattern in $searchPatterns) {
        try {
            $files = Get-ChildItem -Path $ProjectPath -Filter $pattern -Recurse -File -ErrorAction SilentlyContinue
            $cFiles += $files
        } catch {
            Write-MigrationLog -Message "Error scanning for $pattern files: $($_.Exception.Message)" -Level "WARN"
        }
    }

    # Exclude build directories and common non-source directories
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

    Write-MigrationLog -Message "Found $($filteredFiles.Count) C files to analyze" -Level "INFO"
    return $filteredFiles
}

function Invoke-CCodeAnalysis {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath,

        [switch]$Silent
    )

    Write-MigrationLog -Message "Starting C code v2->v3 compatibility analysis..." -Level "INFO"

    # Analyze C files in the project source directory only (not parent directory)
    $cFiles = Get-CFilesInProject -ProjectPath $ProjectSrcPath

    if ($cFiles.Count -eq 0) {
        Write-MigrationLog -Message "No C files found for analysis" -Level "INFO"
        return @{
            Success = $true
            HasIssues = $false
            TotalFiles = 0
            FilesWithIssues = 0
            TotalIssues = 0
            Issues = @()
        }
    }

    if (-not $Silent) {
        Write-Host "Analyzing $($cFiles.Count) C files for v2 to v3 compatibility..." -ForegroundColor Cyan
    }

    $totalIssues = 0
    $filesWithIssues = 0
    $allIssues = @()

    foreach ($file in $cFiles) {
        $relativePath = $file.FullName.Replace($ProjectSrcPath, "").TrimStart('\', '/')
        $fileContent = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue

        if ($fileContent) {
            $issues = Test-CFileV3Compatibility -FilePath $relativePath -FileContent $fileContent

            if ($issues.Count -gt 0) {
                $filesWithIssues++
                $totalIssues += $issues.Count

                # Store issues with file context
                foreach ($issue in $issues) {
                    $allIssues += @{
                        File = $relativePath
                        Issue = $issue
                    }
                }

                if (-not $Silent) {
                    Write-Host "Issues found in: $relativePath ($($issues.Count) issues)" -ForegroundColor Yellow
                }
            }
        }
    }

    # Summary
    if ($totalIssues -gt 0) {
        if (-not $Silent) {
            Write-Host ""
            Write-Host "C Code Analysis Summary:" -ForegroundColor Red
            Write-Host "  - Files analyzed: $($cFiles.Count)" -ForegroundColor White
            Write-Host "  - Files with issues: $filesWithIssues" -ForegroundColor Red
            Write-Host "  - Total issues found: $totalIssues" -ForegroundColor Red
            Write-Host "  - Status: Manual review required" -ForegroundColor Yellow
        }
        Write-MigrationLog -Message "C code analysis: $totalIssues issues in $filesWithIssues files" -Level "WARN"
    } else {
        if (-not $Silent) {
            Write-Host ""
            Write-Host "C Code Analysis Summary:" -ForegroundColor Green
            Write-Host "  - Files analyzed: $($cFiles.Count)" -ForegroundColor White
            Write-Host "  - Files with issues: 0" -ForegroundColor Green
            Write-Host "  - Status: Code appears v3 compatible" -ForegroundColor Green
        }
        Write-MigrationLog -Message "C code analysis: No v2/v3 compatibility issues detected" -Level "SUCCESS"
    }

    return @{
        Success = $true
        HasIssues = ($totalIssues -gt 0)
        TotalFiles = $cFiles.Count
        FilesWithIssues = $filesWithIssues
        TotalIssues = $totalIssues
        Issues = $allIssues
    }
}
