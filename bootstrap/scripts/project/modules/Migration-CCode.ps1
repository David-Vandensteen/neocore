# Migration-CCode.ps1
# C code analysis functions for v2 to v3 migration

function Test-CFileV3Compatibility {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath,

        [Parameter(Mandatory=$true)]
        [string]$FileContent
    )

    Write-MigrationLog -Message "Analyzing C file: $FilePath" -Level "INFO"

    $issues = @()

    # Define v2 to v3 breaking changes patterns
    $BreakingPatterns = @{
        # Type system changes
        "Vec2short" = @{
            Pattern = "Vec2short"
            Issue = "Vec2short type replaced with Position in v3"
            Suggestion = "Replace Vec2short with Position type"
        }

        # Function signature changes
        "nc_get_position_gfx_animated_sprite\s*\(" = @{
            Pattern = "nc_get_position_gfx_animated_sprite\s*\("
            Issue = "nc_get_position_gfx_animated_sprite() signature changed in v3"
            Suggestion = "Update function call to use Position* parameter"
        }

        # Deprecated functions
        "nc_log_" = @{
            Pattern = "nc_log_"
            Issue = "nc_log_* functions deprecated in v3"
            Suggestion = "Replace with new logging API"
        }

        # Memory management changes
        "nc_malloc" = @{
            Pattern = "nc_malloc"
            Issue = "nc_malloc deprecated in v3"
            Suggestion = "Use standard malloc or new memory management functions"
        }

        # Sprite system changes
        "DATlib\s+0\.2" = @{
            Pattern = "DATlib\s+0\.2"
            Issue = "DATlib 0.2 references found (v3 uses DATlib 0.3)"
            Suggestion = "Update DATlib references to 0.3"
        }
    }

    # Scan for patterns
    foreach ($patternName in $BreakingPatterns.Keys) {
        $patternInfo = $BreakingPatterns[$patternName]
        $pattern = $patternInfo.Pattern

        if ($FileContent -match $pattern) {
            # Count occurrences
            $matches = [regex]::Matches($FileContent, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            $count = $matches.Count

            $issueDescription = "$($patternInfo.Issue) ($count occurrence$(if($count -gt 1){'s'}))"
            $issues += $issueDescription

            Write-MigrationLog -Message "Found pattern '$patternName' in $FilePath`: $issueDescription" -Level "WARN"
        }
    }

    # Check for common v2 includes that changed in v3
    $DeprecatedIncludes = @(
        "#include\s+[""<]neocore_v2\.h["">\s]",
        "#include\s+[""<]datlib_v2\.h["">\s]"
    )

    foreach ($includePattern in $DeprecatedIncludes) {
        if ($FileContent -match $includePattern) {
            $issues += "Deprecated include found - update to v3 headers"
            Write-MigrationLog -Message "Deprecated include pattern found in $FilePath" -Level "WARN"
        }
    }

    # Check for hardcoded version references
    if ($FileContent -match "(?i)(neocore|datlib)\s*(version\s*)?2\.\d+") {
        $issues += "Hardcoded v2 version references found"
        Write-MigrationLog -Message "Hardcoded v2 version references in $FilePath" -Level "WARN"
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

    Write-MigrationLog -Message "Found $($filteredFiles.Count) C/C++ files to analyze" -Level "INFO"
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
