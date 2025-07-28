## 3.0.0

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
