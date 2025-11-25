## 3.3.4

  - Upgrade mame from 0.227 to 0.251
  - Update roadmap in README

## 3.3.3

  - Fix issue 198: undefined reference to nc_gfx_destroy_scroller

## 3.3.2

  - Fix issue 197: NeoCore 3.3.0 & 3.3.1 - neocore-version-switcher - failed to checkout and refactor neocore version switcher
  
## 3.3.1

  - Fix URL in readme for project creation script

## 3.3.0

  - **NEW FEATURES**:
    - **One-liner Project Creation**: Create NeoCore projects without cloning yourself the repository
    - **Mak Lint**: Added `mak lint` command for project validation (project.xml, .gitignore, legacy code detection)
  - **IMPROVEMENTS**:
    - **Version Switcher**: Improved temporary directory naming with timestamp-based unique identifiers

## 3.2.0

  - **NEW FEATURES**:
    - **Version Switcher**: Added `neocore-version-switcher.bat` to allow switching between NeoCore versions in standalone project
      - Switch to any tagged version or branch from the repository
      - Use `--list` option to see all available versions
  - **IMPROVEMENTS**:
    - **Project Creation**: Version switcher automatically copied to new projects
    - **Project Upgrade**: Version switcher updated/added during project upgrades
    - **Version Management**: Simplified workflow for testing and switching between NeoCore versions

## 3.1.4

  - Add gitignore recommendation for upgrade.log

## 3.1.3

  - Add gitignore recommendations after program build

## 3.1.2

  - **BUG FIXES**:
    - **mak run:dist**: Fixed standalone executable build with proper path resolution (Issue #176)
      - Fixed NSIS output path mismatch causing "Can't open output file" error
      - Replaced hardcoded "cd" directory with dynamic platform-specific paths
      - Added absolute path resolution using `Resolve-TemplatePath` for consistency
      - Improved build status messages and error reporting
      - Added proper return value handling for build success/failure detection
      - See: https://github.com/David-Vandensteen/neocore/issues/176

## 3.1.1

  - **IMPROVEMENTS**:
    - **Function Naming**: Renamed several functions for better API consistency and clarity
    - **Naming Convention**: New consistent pattern `nc_[module]_[action]_[object]()` for all functions
      - Examples: `nc_gfx_display_animated_sprite()`, `nc_palette_set_color()`, `nc_sound_play_adpcm()`
      - Module prefixes: `nc_gfx_`, `nc_gpu_`, `nc_palette_`, `nc_sound_`, `nc_physic_`, `nc_math_`, etc.
      - Structures follow similar pattern: `GFX_Animated_Sprite`, `Sound_Adpcm_Player`, etc.
    - **Legacy Detection**: Implemented automated legacy function detection script in toolchain for migration assistance
  - **DEPRECATION NOTICE**:
    - **API Modernization**: Many macros, functions, and structures have been renamed to follow consistent naming conventions
    - **Legacy Compatibility**: Old names remain available as deprecated aliases for backward compatibility
    - **Future Removal**: All legacy aliases will be removed in version 4.0.0. Projects should migrate to new names before upgrading to v4

## 3.1.0

  - **NEW FEATURES**:
    - **Fix layer palette management**: Added `nc_fix_load_palette_info()`, `nc_fix_unload_palette_info()`, `nc_fix_unload_palette_id()`
    - **Enhanced fix layer API**: Added `nc_fix_set_bank()`, `nc_fix_set_palette_id()`, `nc_palette_set_info()`
  - **IMPROVEMENTS**:
    - **Palette manager**: Type-based allocation (fix layer: indices 2-16, sprites: 17-255, system reserved: 0-1)

## 3.0.1

  - **TOOLCHAIN IMPROVEMENTS**:
    - **New Assert Module**: Added fix files validation
    - **Enhanced Validation**: Fix graphics files existence checking integrated in project assertions
  - **BUG FIXES**:
    - **Migration System**: Fixed version comparison logic for patch/RC updates (3.0.0 → 3.0.1-rc now correctly returns "minor")
  - **MAINTENANCE**:
    - **Bootstrap**: Updated project creation script instructions
    - **Configuration**: Improved .gitignore handling and validation

## 3.0.0

  - **MAJOR RELEASE** - DATLib 0.3, toolchain refactoring and quality improvement
  - **TOOLCHAIN IMPROVEMENTS**:
    - **PowerShell Refactoring**: Complete refactoring with improved error handling
    - **Build System**: Enhanced monitoring, error handling, embedded CRT runtime, and makefile improvements
    - **Dependencies**: Embedded Neodev and DATlib headers, improved configuration validation
  - **DOCUMENTATION**:
    - Added comprehensive Doxygen tags and API documentation throughout neocore.h
    - **Sample Documentation**: Added comprehensive README.md files for all samples with learning objectives and enhanced categorization
    - **Migration Guide**: Consolidated and enhanced v2→v3 migration documentation with comprehensive C code migration patterns and examples
  - **NEW FEATURES**:
    - **New function**: `nc_get_free_sprite_index()` - Returns first available sprite index
    - **Enhanced sprite management**: `nc_display_gfx_with_sprite_id()` for forced sprite ID allocation
    - **Display functions**: Now return sprite index instead of void
  - **IMPROVEMENTS**:
    - **Graphics destroy functions**: `nc_destroy_gfx_animated_sprite` and `nc_destroy_gfx_picture` now properly reset sprite shrinking
  - **BUG FIXES**:
    - **Sprite Index Manager**: Fixed error handling in sprite allocation and display functions
    - **Bootstrap System**: Added path length validation to prevent GCC compilation issues (Bug #165)
    - **Logging Coordinates**: Fixed `nc_set_position_log(0, 0)` to display at top-left corner (Bug #166)
  - **BREAKING CHANGES**:
    - **Toolchain**: Command deprecations, rule removals, manual build workflow (`mak sprite` → `mak` → `mak run:raine`)
    - **Dependencies**: DATlib 0.3 upgrade breaks compatibility with previous versions
    - **Configuration**: project.xml schema changes, templated path system, sound structure reorganization
    - **C API**: Multiple function signature changes - see [Migration Guide](docs/migration_guides/v2tov3/v2tov3.md#manual-c-code-migration)
  - **NEW C API FUNCTIONS**: nc_log_info_line(), nc_log_next_line(), nc_init_log(), nc_set_position_log()
  - **MIGRATION TOOLS**: Enhanced with C code analysis, automated cleanup, sound section migration, and comprehensive logging

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
