function Assert-ProgramLegacy {
  param(
    [Parameter(Mandatory=$true)][String] $ProjectPath
  )

  Write-Host ""
  Write-Host "=== LEGACY FUNCTION ANALYSIS ===" -ForegroundColor Cyan
  Write-Host "Checking for deprecated function usage..." -ForegroundColor Yellow

  # List of legacy functions with their suggested replacements
  $legacyFunctions = @{
    # Original legacy functions
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
    'nc_rgb16_to_packed_color16' = 'nc_palette_rgb16_to_packed_color16'
    'nc_set_palette_by_packed_color16' = 'nc_palette_manager_set_packed_color16'
    'nc_set_palette_by_rgb16' = 'nc_palette_manager_set_rgb16'
    'nc_get_palette_packed_color16' = 'nc_palette_manager_get_packed_color16'
    'nc_set_palette_backdrop_by_packed_color16' = 'nc_palette_set_backdrop_packed_color16'
    'nc_set_palette_backdrop_by_rgb16' = 'nc_palette_set_backdrop_rgb16'
    'nc_palette_manager_set_backdrop_packed_color16' = 'nc_palette_set_backdrop_packed_color16'
    'nc_bitwise_division_2' = 'nc_math_bitwise_division_2'
    'nc_bitwise_division_4' = 'nc_math_bitwise_division_4'
    'nc_bitwise_division_8' = 'nc_math_bitwise_division_8'
    'nc_bitwise_division_16' = 'nc_math_bitwise_division_16'
    'nc_bitwise_division_32' = 'nc_math_bitwise_division_32'
    'nc_bitwise_division_64' = 'nc_math_bitwise_division_64'
    'nc_bitwise_division_128' = 'nc_math_bitwise_division_128'
    'nc_bitwise_division_256' = 'nc_math_bitwise_division_256'
    'nc_bitwise_multiplication_2' = 'nc_math_bitwise_multiplication_2'
    'nc_bitwise_multiplication_4' = 'nc_math_bitwise_multiplication_4'
    'nc_bitwise_multiplication_8' = 'nc_math_bitwise_multiplication_8'
    'nc_bitwise_multiplication_16' = 'nc_math_bitwise_multiplication_16'
    'nc_bitwise_multiplication_32' = 'nc_math_bitwise_multiplication_32'
    'nc_bitwise_multiplication_64' = 'nc_math_bitwise_multiplication_64'
    'nc_bitwise_multiplication_128' = 'nc_math_bitwise_multiplication_128'
    'nc_bitwise_multiplication_256' = 'nc_math_bitwise_multiplication_256'
    'nc_random' = 'nc_math_random'
    'nc_min' = 'nc_math_min'
    'nc_max' = 'nc_math_max'
    'nc_abs' = 'nc_math_abs'
    'nc_negative' = 'nc_math_negative'
    'nc_fix' = 'nc_math_fix'
    'nc_fix_to_int' = 'nc_math_fix_to_int'
    'nc_int_to_fix' = 'nc_math_int_to_fix'
    'nc_fix_add' = 'nc_math_fix_add'
    'nc_fix_sub' = 'nc_math_fix_sub'
    'nc_fix_mul' = 'nc_math_fix_mul'
    'nc_cos' = 'nc_math_cos'
    'nc_tan' = 'nc_math_tan'
    'nc_copy_box' = 'nc_physic_copy_box'
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
    'nc_palette_manager_read_rgb16' = 'nc_palette_manager_read_rgb16 (use nc_read_palette_rgb16 instead)'
    'nc_packet_color16_to_rgb16' = 'nc_palette_color16_to_rgb16'
    'nc_get_shrunk_proportional_table' = 'nc_gpu_get_shrunk_proportional_table'
    'nc_shrunk_centroid_get_translated_x' = 'nc_gpu_get_shrunk_centroid_translated_x_position'
    'nc_shrunk_centroid_get_translated_y' = 'nc_gpu_get_shrunk_centroid_translated_y_position'
    'nc_shrunk_centroid_gfx_picture' = 'nc_gpu_shrunk_centroid_gfx_picture'
    'nc_wait_vbl_max' = 'nc_gpu_wait_vbl_max'
    
    # GFX Functions - Legacy to new naming convention
    # GFX Init functions
    'nc_init_gfx_animated_sprite' = 'nc_gfx_init_animated_sprite'
    'nc_init_gfx_animated_sprite_physic' = 'nc_gfx_init_animated_physic_sprite'
    'nc_init_gfx_picture' = 'nc_gfx_init_picture'
    'nc_init_gfx_picture_physic' = 'nc_gfx_init_physic_picture'
    'nc_init_gfx_scroller' = 'nc_gfx_init_scroller'
    
    # GFX Display functions
    'nc_display_gfx_with_sprite_id' = 'nc_gfx_display_with_sprite_id'
    'nc_display_gfx_animated_sprite' = 'nc_gfx_display_animated_sprite'
    'nc_display_gfx_animated_sprite_physic' = 'nc_gfx_display_animated_physic_sprite'
    'nc_display_gfx_picture' = 'nc_gfx_display_picture'
    'nc_display_gfx_picture_physic' = 'nc_gfx_display_physic_picture'
    'nc_display_gfx_scroller' = 'nc_gfx_display_scroller'
    
    # GFX Init & Display functions
    'nc_init_display_gfx_animated_sprite' = 'nc_gfx_init_and_display_animated_sprite'
    'nc_init_display_gfx_animated_sprite_physic' = 'nc_gfx_init_and_display_animated_physic_sprite'
    'nc_init_display_gfx_picture' = 'nc_gfx_init_and_display_picture'
    'nc_init_display_gfx_picture_physic' = 'nc_gfx_init_and_display_physic_picture'
    'nc_init_display_gfx_scroller' = 'nc_gfx_init_and_display_scroller'
    
    # GFX Visibility functions
    'nc_hide_gfx_animated_sprite' = 'nc_gfx_hide_animated_sprite'
    'nc_hide_gfx_picture' = 'nc_gfx_hide_picture'
    'nc_hide_gfx_picture_physic' = 'nc_gfx_hide_physic_picture'
    'nc_hide_gfx_animated_sprite_physic' = 'nc_gfx_hide_animated_physic_sprite'
    'nc_show_gfx_animated_sprite' = 'nc_gfx_show_animated_sprite'
    'nc_show_gfx_animated_sprite_physic' = 'nc_gfx_show_animated_physic_sprite'
    'nc_show_gfx_picture' = 'nc_gfx_show_picture'
    'nc_show_gfx_picture_physic' = 'nc_gfx_show_physic_picture'
    
    # GFX Animation functions
    'nc_set_animation_gfx_animated_sprite' = 'nc_gfx_set_animated_sprite_animation'
    'nc_set_animation_gfx_animated_sprite_physic' = 'nc_gfx_set_animated_sprite_animation_physic'
    'nc_update_animation_gfx_animated_sprite' = 'nc_gfx_update_animated_sprite_animation'
    'nc_update_animation_gfx_animated_sprite_physic' = 'nc_gfx_update_animated_physic_sprite_animation'
    
    # GFX Position functions
    # Position getters
    'nc_get_position_gfx_animated_sprite' = 'nc_gfx_get_animated_sprite_position'
    'nc_get_position_gfx_animated_sprite_physic' = 'nc_gfx_get_animated_physic_sprite_position'
    'nc_get_position_gfx_picture' = 'nc_gfx_get_picture_position'
    'nc_get_position_gfx_picture_physic' = 'nc_gfx_get_physic_picture_position'
    'nc_get_position_gfx_scroller' = 'nc_gfx_get_scroller_position'
    
    # Position setters
    'nc_set_position_gfx_picture_physic' = 'nc_gfx_set_physic_picture_position'
    'nc_set_position_gfx_animated_sprite_physic' = 'nc_gfx_set_animated_physic_sprite_position'
    'nc_set_position_gfx_scroller' = 'nc_gfx_set_scroller_position'
    'nc_set_position_gfx_animated_sprite' = 'nc_gfx_set_animated_sprite_position'
    'nc_set_position_gfx_picture' = 'nc_gfx_set_picture_position'
    
    # Position movers
    'nc_move_gfx_picture_physic' = 'nc_gfx_move_physic_picture'
    'nc_move_gfx_animated_sprite_physic' = 'nc_gfx_move_animated_physic_sprite'
    'nc_move_gfx_animated_sprite' = 'nc_gfx_move_animated_sprite'
    'nc_move_gfx_picture' = 'nc_gfx_move_picture'
    'nc_move_gfx_scroller' = 'nc_gfx_move_scroller'
    
    # GFX Destroy functions
    'nc_destroy_gfx_animated_sprite' = 'nc_gfx_destroy_animated_sprite'
    'nc_destroy_gfx_animated_sprite_physic' = 'nc_gfx_destroy_animated_physic_sprite'
    'nc_destroy_gfx_picture' = 'nc_gfx_destroy_picture'
    'nc_destroy_gfx_picture_physic' = 'nc_gfx_destroy_physic_picture'
    'nc_destroy_gfx_scroller' = 'nc_gfx_destroy_scroller'
    
    # Physic functions
    'nc_collide_boxes' = 'nc_physic_collide_boxes'
    'nc_collide_box' = 'nc_physic_collide_box'
    'nc_init_box' = 'nc_physic_init_box'
    'nc_update_box' = 'nc_physic_update_box'
    'nc_shrunk_box' = 'nc_physic_shrunk_box'
    'nc_resize_box' = 'nc_physic_resize_box'
    
    # Math functions
    'nc_byte_to_hex' = 'nc_math_byte_to_hex'
    'nc_word_to_hex' = 'nc_math_word_to_hex'
    'nc_sin' = 'nc_math_sin'
    
    # Joypad functions
    'nc_set_joypad_edge_mode' = 'nc_joypad_set_edge_mode'
    'nc_update_joypad' = 'nc_joypad_update'
    'nc_debug_joypad' = 'nc_joypad_debug'
    
    # Log functions
    'nc_set_position_log' = 'nc_log_set_position'
    
    # Sound/CDDA functions
    'nc_play_cdda' = 'nc_sound_play_cdda'
    'nc_push_remaining_frame_adpcm_player' = 'nc_sound_set_adpcm_remaining_frame'
    'nc_get_adpcm_player' = 'nc_sound_get_adpcm_player'
    
    # Math/Vector functions
    'nc_vectors_collide' = 'nc_math_vectors_is_collide'
    'nc_vector_is_left' = 'nc_math_vector_is_left'
    'nc_frame_to_second' = 'nc_math_frame_to_second'
    'nc_second_to_frame' = 'nc_math_second_to_frame'
    'nc_get_relative_position' = 'nc_math_get_relative_position'

    # System functions
    'nc_init_system' = 'nc_system_init'
    'nc_reset' = 'nc_system_reset'
    'nc_pause' = 'nc_gpu_pause'
    'nc_sleep' = 'nc_gpu_sleep'
    'nc_update' = 'nc_gpu_update'
    'nc_each_frame' = 'nc_gpu_each_frame'
    'nc_free_ram_info' = 'nc_system_get_free_ram_info'
    'nc_get_frame_counter' = 'nc_gpu_get_frame_number'
    'nc_update_mask' = 'nc_physic_update_mask'
    'nc_print' = 'nc_log_print'
  }

  # List of legacy type/structure names with their suggested replacements
  $legacyTypes = @{
    'GFX_Animated_Sprite_Physic' = 'GFX_Animated_Physic_Sprite'
    'GFX_Picture_Physic' = 'GFX_Physic_Picture'
    'Adpcm_player' = 'Sound_Adpcm_Player'
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

      # Check for legacy types/structures
      foreach ($legacyType in $legacyTypes.Keys) {
        # Search for type usage (variable declarations, casts, etc.)
        # Pattern matches: type varName, type*, type *, (type), (type*)
        $pattern = "\b$([regex]::Escape($legacyType))\b"

        if ($content -match $pattern) {
          # Find exact lines
          for ($i = 0; $i -lt $lines.Count; $i++) {
            # Skip typedef lines (the actual legacy typedef declarations)
            if ($lines[$i] -match "typedef.*$([regex]::Escape($legacyType))") {
              continue
            }

            if ($lines[$i] -match $pattern) {
              $lineNumber = $i + 1
              $warningCount++

              $issue = @{
                File = $relativePath
                Line = $lineNumber
                LegacyType = $legacyType
                Replacement = $legacyTypes[$legacyType]
                LineContent = $lines[$i].Trim()
              }
              $foundIssues += $issue

              Write-Host ""
              Write-Host "  WARNING: Legacy type detected" -ForegroundColor Yellow
              Write-Host "    File: $relativePath" -ForegroundColor Cyan
              Write-Host "    Line: $lineNumber" -ForegroundColor Cyan
              Write-Host "    Legacy type: $legacyType" -ForegroundColor Red
              Write-Host "    Suggested replacement: $($legacyTypes[$legacyType])" -ForegroundColor Green
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
    Write-Host "No legacy functions or types found - code is up to date!" -ForegroundColor Green
  } else {
    Write-Host "Found $warningCount legacy function/type usage(s)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Legacy functions and types are deprecated and may be removed in future versions." -ForegroundColor Yellow
    Write-Host "Please update your code to use the suggested replacements." -ForegroundColor Yellow
  }
  Write-Host "================================" -ForegroundColor Cyan

  return @{
    WarningCount = $warningCount
    Issues = $foundIssues
  }
}

