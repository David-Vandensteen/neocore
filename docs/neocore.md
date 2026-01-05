# NeoCore API Documentation (Complete)

## Overview

### Table of Contents

1. Core Types and Structures
2. Graphics Module (GFX)
3. GPU Module (low level)
4. Math and Utilities
5. Physics and Collisions
6. Sound and Audio
7. Input (Joypad)
8. System Utilities and Log
9. DATlib Types (compatibility)
10. Legacy Functions (deprecated)
11. Usage Examples

## 12. Using the NeoCore Toolchain

The NeoCore toolchain provides a set of scripts and tools to automate the creation, compilation, testing, validation, and distribution of Neo Geo CD projects. Here is a summary of the main usages:

### Project creation (recommended):

From anywhere, without cloning the repo:

```cmd
md C:\MyGame && cd C:\MyGame
curl -L https://raw.githubusercontent.com/David-Vandensteen/neocore/master/bootstrap/scripts/project/create_from_oneliner.bat -o c.bat && c.bat && del c.bat
```

This script creates the full project structure, downloads the latest stable version, and prepares everything automatically.

### Build and development cycle:

From your project's `src` folder:

| Command                  | Description                                 |
|--------------------------|---------------------------------------------|
| `mak.bat sprite`         | Generate sprites from assets                |
| `mak.bat`                | Compile and link C code                     |
| `mak.bat run:raine`      | Run in Raine emulator                       |
| `mak.bat run:mame`       | Run in MAME emulator                        |
| `mak.bat run:mame:debug` | Run MAME in debug mode (ngdev plugin)       |
| `mak.bat serve:mame`     | Hot reload: auto recompilation              |
| `mak.bat clean`          | Clean compiled resources                    |
| `mak.bat clean:build`    | Remove the entire build folder              |

### Validation and tools:

| Command            | Description                                    |
|---------------------|------------------------------------------------|
| `mak.bat lint`      | Validate project (XML, .gitignore, legacy)     |
| `mak.bat framer`    | Launch DATlib Framer                           |
| `mak.bat animator`  | Launch DATlib Animator                         |

### Distribution:

| Command              | Description                                   |
|-----------------------|-----------------------------------------------|
| `mak.bat dist:iso`    | Create a ready-to-burn ISO                    |
| `mak.bat dist:mame`   | Create a MAME distribution package            |
| `mak.bat dist:exe`    | Create a standalone Windows executable        |

### Custom emulator profiles:

You can define MAME or Raine profiles in `project.xml` for specific test scenarios:

```xml
<project>
  <emulator>
    <mame>
      <profile>
        <myprofile>-window -skip_gameinfo -throttle neocdz</myprofile>
      </profile>
    </mame>
    <raine>
      <config>
        <myconfig>raine\config\myconfig.cfg</myconfig>
      </config>
    </raine>
  </emulator>
</project>
```

Usage:

```cmd
mak.bat run:mame:myprofile
mak.bat run:raine:myconfig
```

### Project upgrade:

From the project root:

```cmd
neocore-version-switcher.bat master      # Upgrade to latest stable version
neocore-version-switcher.bat 3.2.0       # Switch to a specific version
neocore-version-switcher.bat --list      # List available versions
```

### DATlib tools:

| Command            | Description                                    |
|---------------------|------------------------------------------------|
| `mak.bat framer`    | Launch DATlib Framer (frame editor)            |
| `mak.bat animator`  | Launch DATlib Animator (sprite animation)      |

### Hot reload:

Allows you to automatically recompile and restart the project on changes:

```cmd
mak.bat serve:mame
```

### C89 tips:

- Declare all variables at the beginning of blocks
- No declaration in for loops (C99 forbidden)
- No initialization in declaration except for constants

See README.md for more details, advanced options, and asset, audio, and profile management.

## 1. Core Types and Structures

### Types de base (définis dans stdtypes.h) :

- BYTE  : unsigned char
- WORD  : unsigned short
- DWORD : unsigned int
- BOOL  : unsigned int (TRUE/FALSE)

### Structures principales :

```c
typedef struct Position { short x; short y; } Position;
// Coordonnées 2D signées (pixels, origine en haut à gauche)

typedef struct Box {
  Position p0, p1, p2, p3, p4; // coins et centre
  short width, height;
  short widthOffset, heightOffset;
} Box;
// Boîte de collision (AABB) pour la détection de collisions

typedef struct RGB16 {
  BYTE dark : 4, r : 4, g : 4, b : 4;
} RGB16;
// Couleur Neo Geo 16 bits (4 bits par composant + niveau de noirceur)

// Structures graphiques haut niveau :
typedef struct GFX_Animated_Sprite { ... } GFX_Animated_Sprite;
typedef struct GFX_Animated_Physic_Sprite { ... } GFX_Animated_Physic_Sprite;
typedef struct GFX_Picture { ... } GFX_Picture;
typedef struct GFX_Physic_Picture { ... } GFX_Physic_Picture;
typedef struct GFX_Scroller { ... } GFX_Scroller;

// Structure audio :
typedef struct Sound_Adpcm_Player { enum Sound_state state; DWORD remaining_frame; } Sound_Adpcm_Player;
```

## 2. Graphics Module (GFX)

### Initialisation des objets graphiques :

```c
void nc_gfx_init_animated_sprite(GFX_Animated_Sprite *sprite, const spriteInfo *si, const paletteInfo *pi);
void nc_gfx_init_animated_physic_sprite(GFX_Animated_Physic_Sprite *sprite, const spriteInfo *si, const paletteInfo *pi, short w, short h, short xoff, short yoff);
void nc_gfx_init_picture(GFX_Picture *pic, const pictureInfo *pi, const paletteInfo *pal);
void nc_gfx_init_physic_picture(GFX_Physic_Picture *pic, const pictureInfo *pi, const paletteInfo *pal, short w, short h, short xoff, short yoff, BOOL autobox);
void nc_gfx_init_scroller(GFX_Scroller *scroller, const scrollerInfo *si, const paletteInfo *pal);
```

### Display:

```c
WORD nc_gfx_display_animated_sprite(GFX_Animated_Sprite *sprite, short x, short y, WORD anim);
WORD nc_gfx_display_animated_physic_sprite(GFX_Animated_Physic_Sprite *sprite, short x, short y, WORD anim);
WORD nc_gfx_display_picture(GFX_Picture *pic, short x, short y);
WORD nc_gfx_display_physic_picture(GFX_Physic_Picture *pic, short x, short y);
WORD nc_gfx_display_scroller(GFX_Scroller *scroller, short x, short y);
```

### Visibility:

```c
void nc_gfx_hide_animated_sprite(GFX_Animated_Sprite *sprite);
void nc_gfx_show_animated_sprite(GFX_Animated_Sprite *sprite);
// Same for picture, physic_picture, scroller, animated_physic_sprite
```

### Position:

```c
void nc_gfx_set_animated_sprite_position(GFX_Animated_Sprite *sprite, short x, short y);
// 2D signed coordinates (pixels, origin at top-left)
// Same for picture, physic_picture, scroller, animated_physic_sprite
```

### Animation:

```c
void nc_gfx_set_animated_sprite_animation(GFX_Animated_Sprite *sprite, WORD anim);
void nc_gfx_update_animated_sprite_animation(GFX_Animated_Sprite *sprite);
// Same for animated_physic_sprite
```

### Collision box (AABB) for collision detection:

```c
void nc_gfx_destroy_animated_sprite(GFX_Animated_Sprite *sprite);
// Same for picture, physic_picture, scroller, animated_physic_sprite
```

## 3. GPU Module (low level)

```c
void nc_gpu_clear_display();
void nc_gpu_update();
void nc_gpu_pause(BOOL (*exitFunc)());
void nc_gpu_sleep(DWORD frame);
BOOL nc_gpu_each_frame(DWORD frame);
DWORD nc_gpu_wait_vbl_max(WORD nb);
```

### Sprite/palette index management:

```c
void nc_sprite_manager_clear_table();
WORD nc_sprite_manager_get_max_free_index();
WORD nc_sprite_manager_get_max_used_index();
void nc_palette_manager_unset_palette_info(const paletteInfo* pi);
void nc_palette_manager_clear_table();
WORD nc_sprite_manager_get_free_index();
WORD nc_palette_manager_get_max_free_index();
WORD nc_palette_manager_get_max_used_index();
void nc_palette_manager_read_rgb16(BYTE pal_num, BYTE pal_idx, RGB16 *color);
void nc_palette_color16_to_rgb16(WORD packed, RGB16 *color);
```

### Palette:

```c
#define nc_palette_rgb16_to_packed_color16(color) ...
#define nc_palette_manager_set_packed_color16(pal_num, pal_idx, color) ...
#define nc_palette_manager_set_rgb16(pal_num, pal_idx, color) ...
#define nc_palette_manager_get_packed_color16(pal_num, pal_idx) ...
#define nc_palette_set_backdrop_packed_color16(packed) ...
#define nc_palette_set_backdrop_rgb16(color) ...
```

## 4. Math and Utilities

### Macros bitwise :

```c
#define nc_math_bitwise_division_2(value) (value >> 1)
#define nc_math_bitwise_multiplication_2(value) (value << 1)
#define nc_math_random(range) rand() % range
#define nc_math_min(a,b) ((a) < (b) ? (a) : (b))
#define nc_math_max(a,b) ((a) > (b) ? (a) : (b))
#define nc_math_abs(num) ((num) < 0 ? ~(num) + 1 : (num))
```

### Fix-point :

```c
typedef int FIXED;
extern FIXED inline itofix(int x);
extern int inline fixtoi(FIXED x);
extern double inline fixtof(FIXED x);
extern FIXED inline fcos(int x);
extern FIXED inline fsin(int x);
extern FIXED inline ftan(int x);
extern FIXED inline fadd(FIXED x, FIXED y);
extern FIXED inline fsub(FIXED x, FIXED y);
extern FIXED fmul(FIXED a, FIXED b);
```

### Conversions et utilitaires :

```c
void nc_math_byte_to_hex(BYTE value, char *hexchar);
void nc_math_word_to_hex(WORD value, char *hexchar);
char nc_math_sin(WORD index);
DWORD nc_math_frame_to_second(DWORD frame);
DWORD nc_math_second_to_frame(DWORD second);
BOOL nc_math_vectors_is_collide(Box *box, Position vec[], BYTE vector_max);
BOOL nc_math_vector_is_left(short x, short y, short v1x, short v1y, short v2x, short v2y);
void nc_math_get_relative_position(Position *position, Box box, Position world_coord);
```

## 5. Physics and Collisions

```c
BYTE nc_physic_collide_boxes(Box *box, Box *boxes[], BYTE box_max);
BOOL nc_physic_collide_box(Box *box1, Box *box2);
void nc_physic_init_box(Box *box, short width, short height, short widthOffset, short heightOffset);
void nc_physic_update_box(Box *box, short x, short y);
void nc_physic_shrunk_box(Box *box, Box *bOrigin, WORD shrunkValue);
void nc_physic_resize_box(Box *Box, short edge);
void nc_physic_update_mask(short x, short y, Position vec[], Position offset[], BYTE vector_max);
#define nc_physic_copy_box(box_src, box_dest) memcpy(box_dest, box_src, sizeof(Box))
```

## 6. Sound and Audio

### CDDA

```c
void nc_sound_pause_cdda();
void nc_sound_resume_cdda();
void nc_sound_play_cdda(BYTE track);
#define nc_sound_stop_cdda() nc_sound_pause_cdda()
```

### ADPCM

```c
void nc_sound_stop_adpcm();
void nc_sound_init_adpcm();
void nc_sound_update_adpcm_player();
void nc_sound_set_adpcm_remaining_frame(DWORD frame);
Sound_Adpcm_Player *nc_sound_get_adpcm_player();
```

## 7. Input (Joypad)

```c
void nc_joypad_set_edge_mode(BOOL actived);
void nc_joypad_update(BYTE id);
BOOL nc_joypad_is_up(BYTE id);
BOOL nc_joypad_is_down(BYTE id);
BOOL nc_joypad_is_left(BYTE id);
BOOL nc_joypad_is_right(BYTE id);
BOOL nc_joypad_is_start(BYTE id);
BOOL nc_joypad_is_a(BYTE id);
BOOL nc_joypad_is_b(BYTE id);
BOOL nc_joypad_is_c(BYTE id);
BOOL nc_joypad_is_d(BYTE id);
void nc_joypad_debug(BYTE id);
```

## 8. System Utilities and Log

```c
void nc_system_init();
void nc_system_reset();
WORD nc_system_get_free_ram_info();
#define nc_gpu_get_frame_number() DAT_frameCounter
```

### Log et affichage texte

```c
void nc_log_init();
WORD nc_log_get_x_position();
WORD nc_log_get_y_position();
void nc_log_set_position(WORD x, WORD y);
void nc_log_print(int x, int y, char *label);
void nc_log_next_line();
void nc_fix_set_bank(WORD bank);
void nc_fix_set_palette_id(WORD palette);
WORD nc_palette_set_info(const paletteInfo *paletteInfo, WORD palette_index);
WORD nc_fix_load_palette_info(const paletteInfo *palette_info);
BOOL nc_fix_unload_palette_info(const paletteInfo *palette_info);
BOOL nc_fix_unload_palette_id(WORD palette_id);
WORD nc_log_info(char *txt, ...);
WORD nc_log_info_line(char *txt, ...);
void nc_log_word(WORD value);
void nc_log_int(int value);
void nc_log_dword(DWORD value);
void nc_log_short(short value);
void nc_log_byte(BYTE value);
void nc_log_bool(BOOL value);
void nc_log_spriteInfo(spriteInfo *si);
void nc_log_box(Box *b);
void nc_log_pictureInfo(pictureInfo *pi);
void nc_log_palette_info(paletteInfo *paletteInfo);
void nc_log_packed_color16(WORD packed_color);
void nc_log_rgb16(RGB16 *color);
```

## 9. DATlib Types (compatibility)

```c
// Main DATlib types (see src-lib/include/DATlib.h):
typedef struct paletteInfo { ushort count; ushort data[0]; } paletteInfo;
typedef struct pictureInfo { ... } pictureInfo;
typedef struct picture { ... } picture;
typedef struct spriteInfo { ... } spriteInfo;
typedef struct aSprite { ... } aSprite;
typedef struct scrollerInfo { ... } scrollerInfo;
typedef struct scroller { ... } scroller;
```

## 10. Legacy Functions (deprecated)

Toutes les fonctions commençant par nc_init_gfx_*, nc_display_gfx_*, nc_hide_gfx_*, nc_show_gfx_*, nc_get_position_gfx_*, nc_set_position_gfx_*, nc_move_gfx_*, nc_shrunk_*, nc_set_animation_gfx_*, nc_update_animation_gfx_*, nc_destroy_gfx_*, nc_pause_cdda, nc_resume_cdda, nc_stop_cdda, nc_stop_adpcm, nc_init_adpcm, nc_update_adpcm_player, nc_push_remaining_frame_adpcm_player, nc_get_adpcm_player, nc_set_joypad_edge_mode, nc_update_joypad, nc_debug_joypad, nc_reset, nc_free_ram_info, nc_get_frame_counter, nc_init_log, nc_get_position_x_log, nc_get_position_y_log, nc_set_position_log, nc_print, nc_pause, nc_sleep, nc_update, nc_each_frame, nc_shrunk_extract_x, nc_shrunk_extract_y, etc. sont dépréciées et remplacées par les fonctions modernes ci-dessus.

## 11. Usage Examples

```c
// Animated sprite initialization
GFX_Animated_Sprite player;
nc_gfx_init_animated_sprite(&player, &playerSpriteInfo, &playerPaletteInfo);
nc_gfx_display_animated_sprite(&player, 100, 120, 0);

// Movement
nc_gfx_move_animated_sprite(&player, 4, 0);

// Collision
if (nc_physic_collide_box(&box1, &box2)) { /* ... */ }

// Button input
if (nc_joypad_is_a(0)) { /* ... */ }

// Text display
nc_log_print(2, 5, "Hello NeoCore!");

// Sound
nc_sound_play_cdda(3); // Joue la piste CDDA 3

// Main loop
while (1) {
    nc_gpu_update();
    nc_joypad_update(0);
    // ...
}

// See also: README.md, samples/, and the source code for advanced examples.
```