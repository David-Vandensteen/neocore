function Assert-ProgramLegacy {
  param(
    [Parameter(Mandatory=$true)][String] $ProjectPath
  )

  Write-Host ""
  Write-Host "=== LEGACY FUNCTION ANALYSIS ===" -ForegroundColor Cyan
  Write-Host "Checking for deprecated function usage..." -ForegroundColor Yellow

  # List of legacy functions with their suggested replacements
  $legacyFunctions = @{
    'nc_init_gpu' = 'nc_gpu_init'
    'nc_clear_sprite_index_table' = 'nc_sprite_manager_clear_table'
    'nc_get_max_free_sprite_index' = 'nc_sprite_manager_get_max_free_index'
    'nc_get_max_sprite_index_used' = 'nc_sprite_manager_get_max_used_index'
    'nc_destroy_palette' = 'nc_palette_manager_unset_palette_info'
    'nc_clear_palette_index_table' = 'nc_palette_manager_clear_table'
    'nc_get_free_sprite_index' = 'nc_sprite_manager_get_free_index'
    'nc_get_max_free_palette_index' = 'nc_palette_manager_get_max_free_index'
    'nc_get_max_palette_index_used' = 'nc_palette_manager_get_max_used_index'
    'nc_wait_vbl' = 'nc_gpu_wait_vbl'
    'nc_pause_cdda' = 'nc_sound_pause_cdda'
    'nc_resume_cdda' = 'nc_sound_resume_cdda'
    'nc_stop_cdda' = 'nc_sound_stop_cdda'
    'nc_stop_adpcm' = 'nc_sound_stop_adpcm'
    'nc_init_log' = 'nc_log_init'
    'nc_get_position_x_log' = 'nc_log_get_x_position'
    'nc_get_position_y_log' = 'nc_log_get_y_position'
    'nc_init_adpcm' = 'nc_sound_init_adpcm'
    'nc_update_adpcm_player' = 'nc_sound_update_adpcm_player'
    'nc_clear_display' = 'nc_gpu_clear_display'
  }

  $warningCount = 0
  $foundIssues = @()

  # Search for all .c files in the project
  $cFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.c" | Where-Object {
    # Exclude files in build directories and other system directories
    $_.FullName -notmatch "\\build\\" -and
    $_.FullName -notmatch "\\bin\\" -and
    $_.FullName -notmatch "\\toolchain\\" -and
    $_.FullName -notmatch "\\neodev-sdk\\"
  }

  if ($cFiles.Count -eq 0) {
    Write-Host "  No .c files found in project" -ForegroundColor Gray
    return @{ WarningCount = 0; Issues = @() }
  }

  Write-Host "  Scanning $($cFiles.Count) .c file(s)..." -ForegroundColor Cyan

  foreach ($file in $cFiles) {
    $relativePath = $file.FullName -replace [regex]::Escape($ProjectPath), ""
    $relativePath = $relativePath.TrimStart('\', '/')

    try {
      $content = Get-Content $file.FullName -Raw -ErrorAction Stop
      $lines = Get-Content $file.FullName -ErrorAction Stop

      foreach ($legacyFunction in $legacyFunctions.Keys) {
        # Search with regex to avoid false positives in comments
        # Search for function calls (name followed by parentheses)
        $pattern = "\b$([regex]::Escape($legacyFunction))\s*\("

        if ($content -match $pattern) {
          # Find exact lines
          for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match $pattern) {
              $lineNumber = $i + 1
              $warningCount++

              $issue = @{
                File = $relativePath
                Line = $lineNumber
                LegacyFunction = $legacyFunction
                Replacement = $legacyFunctions[$legacyFunction]
                LineContent = $lines[$i].Trim()
              }
              $foundIssues += $issue

              Write-Host ""
              Write-Host "  WARNING: Legacy function detected" -ForegroundColor Yellow
              Write-Host "    File: $relativePath" -ForegroundColor Cyan
              Write-Host "    Line: $lineNumber" -ForegroundColor Cyan
              Write-Host "    Legacy function: $legacyFunction" -ForegroundColor Red
              Write-Host "    Suggested replacement: $($legacyFunctions[$legacyFunction])" -ForegroundColor Green
            }
          }
        }
      }
    } catch {
      Write-Host "  Error reading file $($file.Name): $_" -ForegroundColor Red
    }
  }

  Write-Host ""
  if ($warningCount -eq 0) {
    Write-Host "No legacy functions found - code is up to date!" -ForegroundColor Green
  } else {
    Write-Host "Found $warningCount legacy function usage(s)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Legacy functions are deprecated and may be removed in future versions." -ForegroundColor Yellow
    Write-Host "Please update your code to use the suggested replacements." -ForegroundColor Yellow
  }
  Write-Host "================================" -ForegroundColor Cyan

  return @{
    WarningCount = $warningCount
    Issues = $foundIssues
  }
}

