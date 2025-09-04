## 3.0.0-rc2
  - **IMPROVEMENTS**:
    - **Graphics destroy functions optimization**: Improved sprite destruction with proper shrinking reset
      - **Enhancement**: `nc_destroy_gfx_animated_sprite` and `nc_destroy_gfx_picture` now properly reset sprite shrinking to default value (0xFFF)
      - **Benefit**: Ensures clean sprite state after destruction, preventing visual artifacts from lingering shrink effects

  - **BUG FIXES**:
    - **Sprite Index Manager Critical Fixes**:
      - **Bug**: `use_sprite_manager_index()` returned incorrect error code (0x00) on allocation failure
      - **Fix**: Function now returns proper error code (0xFFFF) when no sprites are available
      - **Impact**: Error handling in display functions now works correctly, preventing undefined behavior
      - **Bug**: Display functions (`nc_display_gfx_picture`, `nc_display_gfx_animated_sprite`) did not handle sprite allocation failures
      - **Fix**: Added proper error checking and early return when sprite allocation fails
      - **Impact**: Prevents attempting to display graphics with invalid sprite indices, improving stability
    - **Bootstrap System Fixes**:
      - **Problem**: Path length limitations in GCC 2.95.2 causing segmentation faults during compilation (Bug #165: https://github.com/David-Vandensteen/neocore/issues/165)
      - **Solution**: Added proactive path length validation to prevent projects with incompatible path lengths
      - **Impact**: Bootstrap system now creates only compatible projects that compile successfully
      - **Project creation validation**: Enhanced `_create.ps1` script with proactive path length validation

## 3.0.0-r1

  - **MAJOR RELEASE** - DATLib 0.3, toolchain refactoring and quality improvement
  - **TOOLCHAIN IMPROVEMENTS**:
    - **PowerShell Refactoring**: Complete refactoring of PowerShell toolchain modules with improved error handling and return values
    - **Build System Enhancements**:
      - **Real-time Monitoring**: BuildChar output monitoring with immediate process termination on color overload errors
      - **Error Handling**: Comprehensive error parsing and propagation across all build scripts with detailed logging
      - **Process Execution**: Enhanced make process execution with separate output/error log files
      - **CRT Configuration System**: Added configurable `crtPath` in project.xml
      - **Embedded CRT Runtime**: Runtime files (crt0_cd.s, common_crt0_cd.s, etc.) are now automatically embedded in each build from centralized `src-lib/crt/` source
      - **CRT Cleanup**: Removed duplicate CRT files from samples/ directory - now sourced from single authoritative location
      - **Makefile Improvements**: Added `-I$(PROJECT_PATH)` to ASFLAGS for correct assembler include path handling
    - **Module Robustness**: Improved robustness of Set-EnvPath, Stop-Emulators, and Watch-Folder modules with fixed infinite loops and blocking risks
    - **Embedded Dependencies**: Neodev and DATlib headers are now embedded in NeoCore instead of being installed as external dependencies
    - **Configuration Validation**:
      - Enhanced Assert-Project function
      - Improved XML path resolution and template variable handling
      - Better error messages for missing or invalid project configurations
  - **DOCUMENTATION IMPROVEMENTS**:
    - **Doxygen Integration**: Added comprehensive documentation tags throughout neocore.h
    - **API Documentation**: Documentation for major structures (Position, Box, RGB16, GFX_*)
    - **Function Documentation**: Detailed parameter descriptions, return values, and usage notes
  - **NEW FEATURES**:
    - **NeoCore API Enhancements**:
      - **New function**: `nc_get_free_sprite_index()` - Returns the first available sprite index for allocation
        - **Purpose**: Provides direct access to next free sprite slot for manual sprite management
        - **Return value**: First free sprite index (0-383) or 0xFFFF if no sprites available
        - **Complement**: Works alongside existing `nc_get_max_free_sprite_index()` which counts total free sprites
      - **Enhanced sprite management**: `nc_display_gfx_with_sprite_id()` integration
        - **Purpose**: Allows forcing a specific sprite ID for graphics display functions
        - **Behavior**: When `nc_display_gfx_with_sprite_id(sprite_id)` is called with a value different from 0xFFFF, all subsequent display functions (`nc_display_gfx_picture`, `nc_display_gfx_animated_sprite`, `nc_display_gfx_scroller`) will use the specified sprite ID instead of the automatic sprite manager
        - **Usage**: Call `nc_display_gfx_with_sprite_id(desired_sprite_id)` before displaying graphics to override automatic sprite allocation
        - **Auto-reset**: The forced sprite ID is automatically reset to 0xFFFF after use, ensuring it only affects the next graphics allocation
        - **Table management**: Forced sprite IDs are properly registered in the sprite manager table to prevent conflicts
      - **Display functions return sprite index**: Updated graphics display functions to return sprite index
        - **Functions affected**: `nc_display_gfx_picture()`, `nc_display_gfx_picture_physic()`, `nc_display_gfx_animated_sprite()`, `nc_display_gfx_animated_sprite_physic()`, `nc_display_gfx_scroller()`
        - **Functions affected**: `nc_init_display_gfx_picture()`, `nc_init_display_gfx_picture_physic()`, `nc_init_display_gfx_animated_sprite()`, `nc_init_display_gfx_animated_sprite_physic()`, `nc_init_display_gfx_scroller()`
        - **Change**: Return type changed from `void` to `WORD`
        - **Return value**: Sprite index used for display (either forced via `nc_display_gfx_with_sprite_id()` or automatically allocated)
        - **Benefit**: Enables sprite index tracking and debugging, facilitates manual sprite management
  - **BREAKING CHANGES**:
    - **PowerShell Toolchain**:
      - **Command deprecations**: mak mame and mak raine deprecated (use mak run:mame and mak run:raine instead)
      - **Rule removals**: `iso` and `only:iso` rules have been removed from the build system
        - **Alternative**: Use `mak dist:iso` for ISO distribution packaging
        - **Reason**: Simplified build system by consolidating ISO-related commands
      - **Build workflow changes**: Build steps are now explicit and must be run manually instead of automatic execution
        - **Before**: `mak run:raine` or `mak run:mame` automatically executed all build steps
        - **Now**: Manual execution required: `mak sprite` → `mak` → `mak run:raine`
        - **Reason**: Better control over build process, clearer separation of build phases, faster development cycle by leveraging cache (skip sprite generation when unchanged), and reduced build time
        - **Usage examples**:
          ```bash
          # Initial development (do everything)
          mak sprite && mak && mak run:raine

          # Code-only modifications (sprites unchanged)
          mak && mak run:raine  # ⚡ Faster!

          # Quick test without recompilation
          mak run:raine  # 🚀 Instant!
          ```
    - **Dependencies**:
      - **DATlib upgraded to version 0.3** - Breaking compatibility with previous DATlib version
      - **Package updates in manifest.xml**:
        - Updated DATlib package
        - Refreshed toolchain component packages (mame, raine, gcc, etc.)
        - Updated build tools and runtime dependencies
    - **Project Configuration**:
      - **project.xml schema changes**: Enhanced structure - prepares cartridge compatibility for future version
      - **Templated path system**: Build paths now use template variables ({{neocore}}, {{build}})
      - **Sound structure changes**: Reorganized sound.cd.cdda hierarchy
      - **Path resolution**: Improved neocorePath and buildPath handling mechanisms
    - **C API Changes**:
      - **Function removals**:
        - nc_log() function removed - use nc_log_info() for logging functionality
        - nc_clear_vram() function removed - use nc_clear_display() to clear display or nc_reset() for full reset
      - **Type removals**:
        - typedef char Hex_Color[3]; removed - no longer supported
        - typedef char Hex_Packed_Color[5]; removed - no longer supported
      - **GFX getter functions**: Breaking signature changes - now require Position* parameter:
        - nc_get_position_gfx_animated_sprite() now takes Position* instead of returning values
        - nc_get_position_gfx_animated_sprite_physic() now takes Position* instead of returning values
        - nc_get_position_gfx_picture() now takes Position* instead of returning values
        - nc_get_position_gfx_picture_physic() now takes Position* instead of returning values
        - nc_get_position_gfx_scroller() now takes Position* instead of returning values
      - **Function signatures**: All coordinate-related functions standardized to short type
      - **Logging behavior changes**: nc_log_info(), nc_log_short(), nc_log_word(), and other nc_log_* functions no longer automatically add line breaks - use nc_log_info_line() for automatic line breaks or nc_log_next_line() to manually control line breaks
      - **Logging parameter changes**: Some logging functions no longer accept the `label` parameter - use simplified function signatures without label parameter
  - **NEW C API FUNCTIONS**:
    - **Logging Functions**:
      - nc_log_info_line() - Log with automatic line break
      - nc_log_next_line() - Move to next log line
      - nc_init_log() - Initialize logging system
      - nc_set_position_log() - Set log cursor position
  - **MIGRATION TOOLS ENHANCEMENTS**:
    - **C Code Analysis**: Automatic scanning of C files for v2/v3 compatibility issues with detailed reporting of deprecated patterns and breaking changes
    - **Automated Cleanup**: Automatically removes obsolete files (common_crt0_cd.s, crt0_cd.s) during migration
    - **Sound Section Migration**: Automatically migrates `<sound>` sections to v3 format (`<sound><cd>` structure) while preserving content and formatting
    - **Comprehensive Logging**: Detailed migration logging
    - **Full XML Rewrite**: Complete project.xml rewrite using v3 template structure while preserving some user data

## 2.9.0

  - add formatting arguments support in nc log info (check out samples\hello)
  - add some log functions :
    - nc_get_position_x_log
    - nc_get_position_y_log
    - nc_next_line_log
    - nc_set_auto_next_line_log
  - improve pal rgb mixer sample
  - improve install doxygen script
  - update doxygen doc
  - update roadmap in readme

## 2.8.1

  - optimize char buffer in nc log rgb16
  - optimize char buffer in nc log packed color16
  - change nc log palette info to display values with hex format
  - remove useless nc debug paletteInfo

## 2.8.0

  - add nc_byte_to_hex macro
  - add nc_word_to_hex macro
  - add RGB color handlers :
    - RGB16 struct
    - Hex_Color type
    - Hex_Packed_Color type
    - nc_rgb16_to_packed_color16
    - nc_packet_color16_to_rgb16
    - nc_log_palette_info
    - nc_set_palette_by_packed_color16
    - nc_set_palette_by_rgb16
    - nc_get_palette_packed_color16
    - nc_read_palette_rgb16
    - nc_set_palette_backdrop_by_packed_color16
    - nc_set_palette_backdrop_by_rgb16
    - nc_log_packed_color16
    - nc_log_rgb16
  - add samples :
    - pal rgb
    - pal backdrop
    - pal rgb mixer

## 2.7.2

  - build templated path (see bootstrap/standalone/project.xml)
  - centralize toolchain import modules

## 2.7.1

  - fix mak serve:mame
  - refactor toolchain scripts
  - improve toolchain log

## 2.7.0

  - add raine config switcher
  - externalize dependencies into manifest.xml
  - add mak clean:build
  - improve toolchain scripts
  - add mak.log in build folder
  - add gcc.log in build\project.name folder

## 2.6.1

  - update sh get headers script
  - add force parameter on create project script

## 2.6.0

  - add mame profiles in project.xml
  - deprecated mak run (use run:mame instead)
  - add mak --help

## 2.5.1

  - rename few static functions
  - deprecated mak mame and raine (use run:mame and run:raine)

## 2.5.0

  - add functions :
    - nc_pause_cdda
    - nc_resume_cdda
    - nc_stop_cdda
  - add mak lib rule to build neocore c lib
  - use chd compression only with mak dist:mame & dist:exe rules

## 2.4.0

  - add gfx init display combo functions :
    - nc_init_display_gfx_animated_sprite
    - nc_init_display_gfx_animated_sprite_physic
    - nc_init_display_gfx_picture
    - nc_init_display_gfx_picture_physic
    - nc_init_display_gfx_scroller
  - update gitignore in bootstrap (/build/)
  - shadow init system on play cdda

## 2.3.4

  - add project name header in Neo Geo program (for new project scaffolded with the create script)
  - project name assert (16 char max)
  - add project name assert in project create script

## 2.3.3

  - toolchain refactor

## 2.3.2

  - use web request instead bits transfert in powershell toolchain
  - move check project name toolchain code
  - move check rule toolchain code

## 2.3.1

  - make doxygen install as optional
  - add "Requirements" in readme

## 2.3.0

  - add "Release a project" in readme
  - add bootstrap upgrade project script
  - add mak --version

## 2.2.1

  - sanitize build neocore script
  - add bootstrap create project script

## 2.2.0

  - update commands in readme for create a project
  - add commands in readme for upgrade neocore
  - add nc stop adpcm function
  - add nc wait vbl macro
  - update doxygen doc
  - add mak dist:exe for create a Windows standalone executable with embedded Mame emulator
  - improve toolchain log
  - update DATlib ref link in readme
  - update sample sound fx to use nc stop adpcm
  - update sample sound fx poly to use nc stop adpcm and nc wait vbl

## 2.1.1

  - sanitize Makefile
  - CDDA sample : call assets download from mak.ps1

## 2.1.0

  - add mak animator (to launch Animator application)
  - add mak framer (to launch Framer application)

## 2.0.4

  - remove git ignore wav file for standalone project
  - add sound fx poly sample

## 2.0.3

  - split toolchain code
  - update sound fx sample

## 2.0.2

  - remove doxygen script useless commented code
  - move compare filehash toolchain script in module

## 2.0.1

  - fix missing nc sin prototype

## 2.0.0

  - refactor bitwise macros
  - remove useless joypad code
  - remove useless align macro
  - remove useless nc log gas code
  - remove useless LOGGER_ON macro
  - remove useless sin
  - remove useless init all function
  - update enum direction
  - update sound state
  - update copy box
  - update shrunk extract macro
  - update second to frame
  - update random
  - update issue 80 sample
  - add math sample
  - add min, max, abs
  - add fix macro
  - add nc reset
  - add nc prefix

## 1.0.7

## 1.0.6

## 1.0.5

## 1.0.4

## 1.0.3

## 1.0.2

## 1.0.1

## 1.0.0
