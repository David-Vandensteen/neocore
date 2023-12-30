/*
  David Vandensteen
*/

  //--------------------------------------------------------------------------//
 //                             DEFINE                                       //
//--------------------------------------------------------------------------//

#ifndef NEOCORE_H
#define NEOCORE_H

#include <DATlib.h>
#include <math.h>

#define __ALIGN1__      __attribute__ ((aligned (1)))
#define __ALIGN2__      __attribute__ ((aligned (2)))
#define __ALIGN4__      __attribute__ ((aligned (4)))
#define __ALIGN64__     __attribute__ ((aligned (64)))
#define __ALIGN128__    __attribute__ ((aligned (128)))

#define MULT2              << 1
#define MULT4              << 2
#define MULT8              << 3
#define MULT16             << 4
#define MULT32             << 5
#define MULT64             << 6
#define DIV2               >> 1
#define DIV4               >> 2
#define DIV8               >> 3
#define DIV16              >> 4
#define DIV32              >> 5
#define DIV64              >> 6

#define SHRUNK_TABLE_PROP_SIZE    0x2fe

#define BOXCOPY(bFrom, bTo)   memcpy(bTo, bFrom, sizeof(Box))

#define FIX(value) value * 65536
#define RAND(value) rand() % value

#define SHRUNK_EXTRACT_X(value) value >> 8
#define SHRUNK_EXTRACT_Y(value) (BYTE)value

#define MANUALBOX 0
#define AUTOBOX 1

enum direction { NONE, UP, DOWN, LEFT, RIGHT };
enum sound_state { IDLE, PLAYING };

  //--------------------------------------------------------------------------//
 //                          STRUCTURE                                       //
//--------------------------------------------------------------------------//

typedef struct Vec2int { int x; int y; } Vec2int;
typedef struct Vec2short { short x; short y; } Vec2short;
typedef struct Vec2byte { BYTE x; BYTE y; } Vec2byte;

typedef struct Box {
  Vec2short p0;
  Vec2short p1;
  Vec2short p2;
  Vec2short p3;
  Vec2short p4;
  short width;
  short height;
  short widthOffset;
  short heightOffset;
} Box;

typedef struct GFX_Animated_Sprite {
  aSprite aSpriteDAT;
  spriteInfo *spriteInfoDAT;
  paletteInfo *paletteInfoDAT;
} GFX_Animated_Sprite;

typedef struct GFX_Picture {
  picture pictureDAT;
  pictureInfo *pictureInfoDAT;
  paletteInfo *paletteInfoDAT;
  WORD pixel_height;
  WORD pixel_width;
} GFX_Picture;

typedef struct GFX_Animated_Sprite_Physic {
  GFX_Animated_Sprite gfx_animated_sprite;
  Box box;
  BOOL physic_enabled;
} GFX_Animated_Sprite_Physic;

typedef struct GFX_Picture_Physic {
  GFX_Picture gfx_picture;
  Box box;
  BOOL autobox_enabled;
  BOOL physic_enabled;
} GFX_Picture_Physic;

typedef struct GFX_Scroller {
  scroller scrollerDAT;
  scrollerInfo *scrollerInfoDAT;
  paletteInfo *paletteInfoDAT;
} GFX_Scroller;

typedef struct Adpcm_player {
  enum sound_state state;
  DWORD remaining_frame;
} Adpcm_player;

  //--------------------------------------------------------------------------//
 //                                   GFX                                    //
//--------------------------------------------------------------------------//

  /*------------------*/
 /*  GFX INIT        */
/*------------------*/

void init_gfx_scroller(
  GFX_Scroller *gfx_scroller,
  scrollerInfo *scrollerInfo,
  paletteInfo *paletteInfo
);

void init_gfx_picture(GFX_Picture *gfx_picture, pictureInfo *pictureInfo, paletteInfo *paletteInfo);
void init_gfx_picture_physic(
  GFX_Picture_Physic *gfx_picture_physic,
  pictureInfo *pi,
  paletteInfo *pali,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset,
  BOOL autobox_enabled
);

void init_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  spriteInfo *spriteInfo,
  paletteInfo *paletteInfo
);

void init_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  spriteInfo *spriteInfo,
  paletteInfo *paletteInfo,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset
);

  /*------------------*/
 /*  GFX DISPLAY     */
/*------------------*/

void display_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y);
void display_gfx_picture(GFX_Picture *gfx_picture, short x, short y);
void display_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic, short x, short y);

void display_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  short x,
  short y,
  WORD anim
);

void display_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  short x,
  short y,
  WORD anim
);

void debug_paletteInfo(paletteInfo *palette, BOOL palCount, BOOL data);

  /*------------------*/
 /*  GFX VISIBILITY  */
/*------------------*/

void hide_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

void hide_gfx_picture(GFX_Picture *gfx_picture);
void hide_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic);
void hide_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);

void show_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);
void show_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);
void show_gfx_picture(GFX_Picture *gfx_picture);
void show_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic);

  /*------------------*/
 /*  GFX POSITION    */
/*------------------*/

/* GFX POSITION GETTER */

Vec2short get_position_gfx_animated_sprite(GFX_Animated_Sprite gfx_animated_sprite);

Vec2short get_position_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic gfx_animated_sprite_physic
);

Vec2short get_position_gfx_picture(GFX_Picture gfx_picture);
Vec2short get_position_gfx_picture_physic(GFX_Picture_Physic gfx_picture_physic);
Vec2short get_position_gfx_scroller(GFX_Scroller gfx_scroller);

/* GFX POSITION SETTER */

void set_position_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic, short x, short y);

void set_position_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  short x,
  short y
);

void set_position_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y);
void set_position_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite, short x, short y);
void set_position_gfx_picture(GFX_Picture *gfx_picture, short x, short y);

/* GFX POSITION MOVE*/

void move_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic, short x_offset, short y_offset);

void move_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  short x_offset,
  short y_offset
);

void move_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  short x_offset,
  short y_offset
);

void move_gfx_picture(GFX_Picture *gfx_picture, short x, short y);
void move_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y);

  /*-------------------*/
 /*  GFX SHRUNK       */
/*-------------------*/

void shrunk_centroid_gfx_picture(
  GFX_Picture *gfx_picture,
  short center_x,
  short center_y,
  WORD shrunk_value
);

  /*-------------------*/
 /*  GFX ANIMATION    */
/*-------------------*/

void set_animation_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite, WORD anim);

void set_animation_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  WORD anim
);

void update_animation_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

void update_animation_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic
);

  /*-------------------*/
 /*  GFX DESTROY      */
/*-------------------*/

void destroy_gfx_scroller(GFX_Scroller *gfx_scroller);
void destroy_gfx_picture(GFX_Picture *gfx_picture);
void destroy_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

void destroy_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic);
void destroy_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);

  //--------------------------------------------------------------------------//
 //                                   GPU                                    //
//--------------------------------------------------------------------------//

void init_gpu();
void clear_vram();
char get_sin(WORD index);

  /*------------------------------*/
 /* GPU VBL                      */
/*------------------------------*/

DWORD wait_vbl_max(WORD nb);
#define wait_vbl() update_adpcm_player(); waitVBlank()

  /*------------------------------*/
 /* GPU SPRITE INDEX MANAGEMENT  */
/*------------------------------*/

void clear_sprite_index_table();
WORD get_max_free_sprite_index();
WORD get_max_sprite_index_used();

  /*---------------*/
 /* GPU PALETTE   */
/*---------------*/

void destroy_palette(paletteInfo* paletteInfo);
void clear_palette_index_table();
WORD get_max_free_palette_index();
WORD get_max_palette_index_used();

  /*--------------*/
 /* GPU shrunk   */
/*--------------*/

WORD get_shrunk_proportional_table(WORD index);
int shrunk_centroid_get_translated_x(short centerPosX, WORD tileWidth, BYTE shrunkX);
int shrunk_centroid_get_translated_y(short centerPosY, WORD tileHeight, BYTE shrunkY);
void shrunk(WORD base_sprite, WORD max_width, WORD value);
WORD shrunk_forge(BYTE xc, BYTE yc);
void shrunk_addr(WORD addr, WORD shrunk_value);
WORD shrunk_range(WORD addr_start, WORD addr_end, WORD shrunk_value);

  //--------------------------------------------------------------------------//
 //                                PHYSIC                                    //
//--------------------------------------------------------------------------//

BYTE collide_boxes(Box *box, Box *boxes[], BYTE box_max);
BOOL collide_box(Box *box1, Box *box2);
void init_box(Box *box, short width, short height, short widthOffset, short heightOffset);
void update_box(Box *box, short x, short y);

//void mask_display(picture pic[], Vec2short vec[], BYTE vector_max); // todo (minor) - rename ? (vectorsDisplay)
void update_mask(short x, short y, Vec2short vec[], Vec2short offset[], BYTE vector_max); // todo (minor) - rename ? (vectorsDebug)

void shrunk_box(Box *box, Box *bOrigin, WORD shrunkValue);
void resize_box(Box *Box, short edge); // todo (minor) - deprecated ?

  //--------------------------------------------------------------------------//
 //                                SOUND                                     //
//--------------------------------------------------------------------------//

void play_cdda(BYTE track);

  //----------------------------------------------------------------------------//
 //                                  JOYPAD                                    //
//----------------------------------------------------------------------------//

void update_joypad(BYTE id);
void update_joypad_edge(BYTE id);

void joypad_update(BYTE id);
BOOL joypad_is_up(BYTE id);
BOOL joypad_is_down(BYTE id);
BOOL joypad_is_left(BYTE id);
BOOL joypad_is_right(BYTE id);
BOOL joypad_is_start(BYTE id);
BOOL joypad_is_a(BYTE id);
BOOL joypad_is_b(BYTE id);
BOOL joypad_is_c(BYTE id);
BOOL joypad_is_d(BYTE id);

BOOL joypad_0_is_a();
BOOL joypad_0_is_b();
BOOL joypad_0_is_c();
BOOL joypad_0_is_d();
BOOL joypad_0_is_left();
BOOL joypad_0_is_right();
BOOL joypad_0_is_up();
BOOL joypad_0_is_down();
BOOL joypad_0_is_select();
BOOL joypad_0_is_start();

void debug_joypad(BYTE id);

  //----------------------------------------------------------------------------//
 //                                  UTIL                                      //
//----------------------------------------------------------------------------//

DWORD get_frame_to_second(DWORD frame);
DWORD get_second_to_frame(DWORD second);
void init_system();
void init_all_system();
Vec2short get_relative_position(Box box, Vec2short world_coord);
void pause(BOOL (*exitFunc)());
void sleep(DWORD frame);
BOOL each_frame(DWORD frame);
short get_positive(short num);
short get_inverse(int num); // TODO TEST
int get_random(int range);
void fix_print_neocore(int x, int y, char *label);
WORD free_ram_info();
#define close_vbl() SCClose()
#define get_frame_counter() DAT_frameCounter

  /*---------------*/
 /* UTIL LOGGER   */
/*---------------*/

void init_log();
void set_position_log(WORD _x, WORD _y);

WORD log_info(char *txt);
void log(char *message);

void log_word(char *label, WORD value);
void log_int(char *label, int value);
void log_dword(char *label, DWORD value);
void log_short(char *label, short value);
void log_byte(char *label, BYTE value);
void log_bool(char *label, BOOL value);
void log_gas(char *label, GFX_Animated_Sprite *gfx_animated_sprite);
void log_spriteInfo(char *label, spriteInfo *si);
void log_box(char *label, Box *b);
void log_pictureInfo(char *label, pictureInfo *pi);
void log_vec2short(char *label, Vec2short vec2short);

  /*---------------*/
 /* SOUND         */
/*---------------*/

void init_adpcm();
void update_adpcm_player();
void push_remaining_frame_adpcm_player(DWORD frame);
Adpcm_player *get_adpcm_player();

  /*---------------*/
 /* UTIL VECTOR   */
/*---------------*/

BOOL vectors_collide(Box *box, Vec2short vec[], BYTE vector_max);
BOOL vector_is_left(short x, short y, short v1x, short v1y, short v2x, short v2y);

#endif
