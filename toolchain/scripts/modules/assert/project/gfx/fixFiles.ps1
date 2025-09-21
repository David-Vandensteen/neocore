function Assert-ProjectGfxFixFiles {
  Write-Host "Assert project gfx fix files" -ForegroundColor Yellow

  # Check if fixdata section exists
  if (-Not($Config.project.gfx.DAT.fixdata)) {
    Write-Host "error : project.gfx.DAT.fixdata not found" -ForegroundColor Red
    return $false
  }

  # Check if chardata section exists within fixdata
  if (-Not($Config.project.gfx.DAT.fixdata.chardata)) {
    Write-Host "error : project.gfx.DAT.fixdata.chardata not found" -ForegroundColor Red
    return $false
  }

  $fixdata = $Config.project.gfx.DAT.fixdata.chardata
  $missingFiles = @()
  $checkedFiles = 0

  # Check individual fix files
  if ($fixdata.fix) {
    foreach ($fixElement in $fixdata.fix) {
      if ($fixElement.file) {
        $checkedFiles++
        $filePath = $fixElement.file

        # Resolve path with templates (if used)
        try {
          $resolvedPath = Get-TemplatePath -Path $filePath
        } catch {
          $resolvedPath = $filePath
        }

        # Test file existence
        if (-Not(Test-Path -Path $resolvedPath)) {
          $missingFiles += $resolvedPath
          Write-Host "error : fix file not found: $resolvedPath (id: $($fixElement.id), bank: $($fixElement.bank))" -ForegroundColor Red
        } else {
          Write-Host "fix file found: $resolvedPath (id: $($fixElement.id), bank: $($fixElement.bank))" -ForegroundColor Green
        }
      }
    }
  }

  # Check import files (imported binary files)
  if ($fixdata.import) {
    foreach ($importElement in $fixdata.import) {
      if ($importElement.file) {
        $filePath = $importElement.file

        # Skip validation for system font file
        if ($filePath -eq "{{build}}\fix\systemFont.bin") {
          Write-Host "import file skipped (system): $filePath (bank: $($importElement.bank))" -ForegroundColor Cyan
          continue
        }

        $checkedFiles++

        # Resolve path with templates
        try {
          $resolvedPath = Get-TemplatePath -Path $filePath
        } catch {
          $resolvedPath = $filePath
        }

        # Test file existence
        if (-Not(Test-Path -Path $resolvedPath)) {
          $missingFiles += $resolvedPath
          Write-Host "error : import file not found: $resolvedPath (bank: $($importElement.bank))" -ForegroundColor Red
        } else {
          Write-Host "import file found: $resolvedPath (bank: $($importElement.bank))" -ForegroundColor Green
        }
      }
    }
  }

  # Validation summary
  if ($missingFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "Fix files validation failed: $($missingFiles.Count) missing files out of $checkedFiles total" -ForegroundColor Red
    foreach ($file in $missingFiles) {
      Write-Host "  - Missing: $file" -ForegroundColor Red
    }
    return $false
  }

  if ($checkedFiles -eq 0) {
    Write-Host "No fix files found to validate" -ForegroundColor Yellow
    return $true
  }

  Write-Host "All fix files validated successfully ($checkedFiles files)" -ForegroundColor Green
  return $true
}