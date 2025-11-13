function MakLint {
  Write-Host "Mak lint" -ForegroundColor Cyan
  Write-Host "Running project validation checks..." -ForegroundColor Cyan
  Write-Host ""

  $hasErrors = $false
  $projectSrc = (Get-Location).Path

  # 1. Check project.xml assertions (already done in Assert-Project)
  Write-Host "=== PROJECT STRUCTURE VALIDATION ===" -ForegroundColor Cyan
  if (-Not(Assert-Project -Config $Config)) {
    Write-Host "Project structure validation failed" -ForegroundColor Red
    $hasErrors = $true
  } else {
    Write-Host "Project structure is valid" -ForegroundColor Green
  }
  Write-Host ""

  # 2. Check .gitignore configuration
  Write-Host "=== GITIGNORE VALIDATION ===" -ForegroundColor Cyan
  $gitignoreResult = Assert-Gitignore -ProjectSrc $projectSrc
  if (-not $gitignoreResult) {
    Write-Host ".gitignore validation failed" -ForegroundColor Red
    $hasErrors = $true
  } else {
    Write-Host ".gitignore is properly configured" -ForegroundColor Green
  }
  Write-Host ""

  # 3. Check for legacy code usage
  Write-Host "=== LEGACY CODE VALIDATION ===" -ForegroundColor Cyan
  $legacyResult = Assert-ProgramLegacy -ProjectPath $projectSrc
  if ($legacyResult.WarningCount -gt 0) {
    Write-Host "Legacy code issues found: $($legacyResult.WarningCount) usage(s)" -ForegroundColor Red
    $hasErrors = $true
  } else {
    Write-Host "No legacy code issues found" -ForegroundColor Green
  }
  Write-Host ""

  # Final summary
  Write-Host "=== LINT SUMMARY ===" -ForegroundColor Cyan
  if ($hasErrors) {
    Write-Host "Lint checks completed with errors" -ForegroundColor Red
    return $false
  } else {
    Write-Host "All lint checks passed successfully" -ForegroundColor Green
    return $true
  }
}