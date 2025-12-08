function Assert-Gitignore {
  param (
    [Parameter(Mandatory=$true)]
    [string]$ProjectSrc
  )
  
  $gitignorePath = Join-Path (Join-Path $ProjectSrc "..") ".gitignore"

  if (-not (Test-Path $gitignorePath)) {
    return $true
  }

  # File exists, proceed with validation
  Write-Host "Checking .gitignore configuration..." -ForegroundColor Cyan
  try {
    $gitignoreContent = Get-Content -Path $gitignorePath -ErrorAction Stop
    $issuesFound = @()
    $missingPatterns = @()

    # Required patterns for NeoCore v3 projects
    $requiredPatterns = @(
      ".DS_Store",
      "*.png_reject.png",
      "**/out/fix.bin",
      "**/out/char.bin",
      "/build/",
      "/dist/",
      "upgrade.log",
      "neocore-version-switcher-latest-spool.bat",
      "neocore-version-switcher-spool/",
      "console_history"      
    )

    # Check for missing required patterns
    foreach ($requiredPattern in $requiredPatterns) {
      $patternFound = $false
      foreach ($line in $gitignoreContent) {
        $trimmedLine = $line.Trim()
        
        # For build/ and dist/, accept both absolute and relative forms
        if ($requiredPattern -eq "/build/") {
          if ($trimmedLine -eq "/build/" -or $trimmedLine -eq "build/") {
            $patternFound = $true
            break
          }
        } elseif ($requiredPattern -eq "/dist/") {
          if ($trimmedLine -eq "/dist/" -or $trimmedLine -eq "dist/") {
            $patternFound = $true
            break
          }
        } else {
          # Exact match for other patterns
          if ($trimmedLine -eq $requiredPattern) {
            $patternFound = $true
            break
          }
        }
      }
      
      if (-not $patternFound) {
        $missingPatterns += $requiredPattern
      }
    }

    # Check for problematic patterns
    foreach ($line in $gitignoreContent) {
      $trimmedLine = $line.Trim()

      # Skip empty lines and comments
      if ([string]::IsNullOrWhiteSpace($trimmedLine) -or $trimmedLine.StartsWith('#')) {
        continue
      }

      # Check for obsolete externs.h entry
      if ($trimmedLine -eq "externs.h") {
        $issuesFound += "Obsolete entry 'externs.h' found - should be removed (not needed in v3)"
        continue
      }

      # Check for non-absolute paths that should be absolute
      if ($trimmedLine -eq "build/" -and -not ($gitignoreContent | Where-Object { $_.Trim() -eq "/build/" })) {
        $issuesFound += "Pattern 'build/' should preferably be '/build/' (absolute path)"
      }
      elseif ($trimmedLine -eq "dist/" -and -not ($gitignoreContent | Where-Object { $_.Trim() -eq "/dist/" })) {
        $issuesFound += "Pattern 'dist/' should preferably be '/dist/' (absolute path)"
      }
      elseif ($trimmedLine -eq "out/") {
        $issuesFound += "Pattern 'out/' should preferably be '/out/' or '**/out/' (absolute/recursive path)"
      }
    }

    # Report findings
    if ($missingPatterns.Count -gt 0 -or $issuesFound.Count -gt 0) {
      Write-Host ""
      Write-Host "  WARNING: .gitignore issues detected" -ForegroundColor Yellow
      Write-Host ""
      
      if ($missingPatterns.Count -gt 0) {
        Write-Host "  Missing recommended patterns:" -ForegroundColor Yellow
        foreach ($pattern in $missingPatterns) {
          Write-Host "    - $pattern" -ForegroundColor Cyan
        }
        Write-Host ""
      }

      if ($issuesFound.Count -gt 0) {
        Write-Host "  Issues to review:" -ForegroundColor Yellow
        foreach ($issue in $issuesFound) {
          Write-Host "    - $issue" -ForegroundColor Yellow
        }
        Write-Host ""
      }
    } else {
      Write-Host "  .gitignore configuration looks good" -ForegroundColor Green
    }

    return $true

  } catch {
    Write-Host "  ERROR: Failed to read .gitignore: $($_.Exception.Message)" -ForegroundColor Red
    return $true
  }
}
