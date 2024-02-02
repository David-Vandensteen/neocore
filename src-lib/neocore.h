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

#define SHRUNK_TABLE_PROP_SIZE 0x2fe

#define MANUALBOX 0
#define AUTOBOX 1

enum Direction { NONE, UP, DOWN, LEFT, RIGHT };
enum Sound_state { IDLE, PLAYING };

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
  enum Sound_state state;
  DWORD remaining_frame;
} Adpcm_player;

  //--------------------------------------------------------------------------//
 //                                   GFX                                    //
//--------------------------------------------------------------------------//

  /*------------------*/
 /*  GFX INIT        */
/*------------------*/

void nc_init_gfx_scroller(
  GFX_Scroller *gfx_scroller,
  scrollerInfo *scrollerInfo,
  paletteInfo *paletteInfo
);

void nc_init_gfx_picture(GFX_Picture *gfx_picture, pictureInfo *pictureInfo, paletteInfo *paletteInfo);
void nc_init_gfx_picture_physic(
  GFX_Picture_Physic *gfx_picture_physic,
  pictureInfo *pi,
  paletteInfo *pali,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset,
  BOOL autobox_enabled
);

void nc_init_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  spriteInfo *spriteInfo,
  paletteInfo *paletteInfo
);

void nc_init_gfx_animated_sprite_physic(
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

void nc_display_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y);
void nc_display_gfx_picture(GFX_Picture *gfx_picture, short x, short y);
void nc_display_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic, short x, short y);

void nc_display_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  short x,
  short y,
  WORD anim
);

void nc_display_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  short x,
  short y,
  WORD anim
);

void nc_debug_paletteInfo(paletteInfo *palette, BOOL palCount, BOOL data);

  /*------------------*/
 /*  GFX VISIBILITY  */
/*------------------*/

void nc_hide_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

void nc_hide_gfx_picture(GFX_Picture *gfx_picture);
void nc_hide_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic);
void nc_hide_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);

void nc_show_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);
void nc_show_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);
void nc_show_gfx_picture(GFX_Picture *gfx_picture);
void nc_show_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic);

  /*------------------*/
 /*  GFX POSITION    */
/*------------------*/

/* GFX POSITION GETTER */

Vec2short nc_get_position_gfx_animated_sprite(GFX_Animated_Sprite gfx_animated_sprite);

Vec2short nc_get_position_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic gfx_animated_sprite_physic
);

Vec2short nc_get_position_gfx_picture(GFX_Picture gfx_picture);
Vec2short nc_get_position_gfx_picture_physic(GFX_Picture_Physic gfx_picture_physic);
Vec2short nc_get_position_gfx_scroller(GFX_Scroller gfx_scroller);

/* GFX POSITION SETTER */

void nc_set_position_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic, short x, short y);

void nc_set_position_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  short x,
  short y
);

void nc_set_position_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y);
void nc_set_position_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite, short x, short y);
void nc_set_position_gfx_picture(GFX_Picture *gfx_picture, short x, short y);

/* GFX POSITION MOVE*/

void nc_move_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic, short x_offset, short y_offset);

void nc_move_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  short x_offset,
  short y_offset
);

void nc_move_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  short x_offset,
  short y_offset
);

void nc_move_gfx_picture(GFX_Picture *gfx_picture, short x, short y);
void nc_move_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y);

  /*-------------------*/
 /*  GFX SHRUNK       */
/*-------------------*/

#define nc_shrunk_extract_x(value) value >> 8
#define nc_shrunk_extract_y(value) (BYTE)value

void nc_shrunk_centroid_gfx_picture(
  GFX_Picture *gfx_picture,
  short center_x,
  short center_y,
  WORD shrunk_value
);

  /*-------------------*/
 /*  GFX ANIMATION    */
/*-------------------*/

void nc_set_animation_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite, WORD anim);

void nc_set_animation_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  WORD anim
);

void nc_update_animation_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

void nc_update_animation_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic
);

  /*-------------------*/
 /*  GFX DESTROY      */
/*-------------------*/

void nc_destroy_gfx_scroller(GFX_Scroller *gfx_scroller);
void nc_destroy_gfx_picture(GFX_Picture *gfx_picture);
void nc_destroy_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

void nc_destroy_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic);
void nc_destroy_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);

  //--------------------------------------------------------------------------//
 //                                   GPU                                    //
//--------------------------------------------------------------------------//

void nc_init_gpu();
void nc_clear_vram();

  /*------------------------------*/
 /* GPU VBL                      */
/*------------------------------*/

void nc_update();
DWORD nc_wait_vbl_max(WORD nb);

  /*------------------------------*/
 /* GPU SPRITE INDEX MANAGEMENT  */
/*------------------------------*/

void nc_clear_sprite_index_table();
WORD nc_get_max_free_sprite_index();
WORD nc_get_max_sprite_index_used();

  /*---------------*/
 /* GPU PALETTE   */
/*---------------*/

void nc_destroy_palette(paletteInfo* paletteInfo);
void nc_clear_palette_index_table();
WORD nc_get_max_free_palette_index();
WORD nc_get_max_palette_index_used();

  /*--------------*/
 /* GPU shrunk   */
/*--------------*/

WORD nc_get_shrunk_proportional_table(WORD index);
int nc_shrunk_centroid_get_translated_x(short centerPosX, WORD tileWidth, BYTE shrunkX);
int nc_shrunk_centroid_get_translated_y(short centerPosY, WORD tileHeight, BYTE shrunkY);
void nc_shrunk(WORD base_sprite, WORD max_width, WORD value);
WORD nc_shrunk_forge(BYTE xc, BYTE yc);
void nc_shrunk_addr(WORD addr, WORD shrunk_value);
WORD nc_shrunk_range(WORD addr_start, WORD addr_end, WORD shrunk_value);

  //--------------------------------------------------------------------------//
 //                                MATH                                      //
//--------------------------------------------------------------------------//

#define nc_bitwise_division_2(value) (value >> 1)
#define nc_bitwise_division_4(value) (value >> 2)
#define nc_bitwise_division_8(value) (value >> 3)
#define nc_bitwise_division_16(value) (value >> 4)
#define nc_bitwise_division_32(value) (value >> 5)
#define nc_bitwise_division_64(value) (value >> 6)
#define nc_bitwise_division_128(value) (value >> 7)
#define nc_bitwise_division_256(value) (value >> 8)

#define nc_bitwise_multiplication_2(value) (value << 1)
#define nc_bitwise_multiplication_4(value) (value << 2)
#define nc_bitwise_multiplication_8(value) (value << 3)
#define nc_bitwise_multiplication_16(value) (value << 4)
#define nc_bitwise_multiplication_32(value) (value << 5)
#define nc_bitwise_multiplication_64(value) (value << 6)
#define nc_bitwise_multiplication_128(value) (value << 7)
#define nc_bitwise_multiplication_256(value) (value << 8)

#define nc_random(range) rand() % range

#define nc_min(a,b) ((a) < (b) ? (a) : (b))
#define nc_max(a,b) ((a) > (b) ? (a) : (b))

#define nc_abs(num) ((num) < 0 ? ~(num) + 1 : (num))
#define nc_negative(num) -num

#define nc_fix(num) num * 65536
#define nc_fix_to_int(num) fixtoi(num)
#define nc_int_to_fix(num) itofix(num)
#define nc_fix_add(num1, num2) fadd(num1, num2)
#define nc_fix_sub(num1, num2) fsub(num1, num2)
#define nc_fix_mul(num1, num2) fmul(num1, num2)
#define nc_cos(num) fcos(num)
#define nc_tan(num) ftan(num)

  //--------------------------------------------------------------------------//
 //                                PHYSIC                                    //
//--------------------------------------------------------------------------//

#define nc_copy_box(box_src, box_dest) memcpy(box_dest, box_src, sizeof(Box))

BYTE nc_collide_boxes(Box *box, Box *boxes[], BYTE box_max);
BOOL nc_collide_box(Box *box1, Box *box2);
void nc_init_box(Box *box, short width, short height, short widthOffset, short heightOffset);
void nc_update_box(Box *box, short x, short y);

//void mask_display(picture pic[], Vec2short vec[], BYTE vector_max); // todo (minor) - rename ? (vectorsDisplay)
void nc_update_mask(short x, short y, Vec2short vec[], Vec2short offset[], BYTE vector_max); // todo (minor) - rename ? (vectorsDebug)

void nc_shrunk_box(Box *box, Box *bOrigin, WORD shrunkValue);
void nc_resize_box(Box *Box, short edge); // todo (minor) - deprecated ?

  //--------------------------------------------------------------------------//
 //                                SOUND                                     //
//--------------------------------------------------------------------------//

void nc_play_cdda(BYTE track);

  //----------------------------------------------------------------------------//
 //                                  JOYPAD                                    //
//----------------------------------------------------------------------------//

void nc_set_joypad_edge_mode(BOOL actived);
void nc_update_joypad(BYTE id);
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

void nc_debug_joypad(BYTE id);

  //----------------------------------------------------------------------------//
 //                                  UTIL                                      //
//----------------------------------------------------------------------------//

DWORD nc_frame_to_second(DWORD frame);
DWORD nc_second_to_frame(DWORD second);
void nc_init_system();
void nc_reset();
Vec2short nc_get_relative_position(Box box, Vec2short world_coord);
void nc_pause(BOOL (*exitFunc)());
void nc_sleep(DWORD frame);
BOOL nc_each_frame(DWORD frame);
void nc_print(int x, int y, char *label);
WORD nc_free_ram_info();
#define nc_get_frame_counter() DAT_frameCounter

  /*---------------*/
 /* UTIL LOGGER   */
/*---------------*/

void nc_init_log();
void nc_set_position_log(WORD _x, WORD _y);

WORD nc_log_info(char *txt);
void nc_log(char *message);

void nc_log_word(char *label, WORD value);
void nc_log_int(char *label, int value);
void nc_log_dword(char *label, DWORD value);
void nc_log_short(char *label, short value);
void nc_log_byte(char *label, BYTE value);
void nc_log_bool(char *label, BOOL value);
void nc_log_spriteInfo(char *label, spriteInfo *si);
void nc_log_box(char *label, Box *b);
void nc_log_pictureInfo(char *label, pictureInfo *pi);
void nc_log_vec2short(char *label, Vec2short vec2short);

  /*---------------*/
 /* SOUND         */
/*---------------*/

void nc_init_adpcm();
void nc_update_adpcm_player();
void nc_push_remaining_frame_adpcm_player(DWORD frame);
Adpcm_player *nc_get_adpcm_player();

  /*---------------*/
 /* UTIL VECTOR   */
/*---------------*/

BOOL nc_vectors_collide(Box *box, Vec2short vec[], BYTE vector_max);
BOOL nc_vector_is_left(short x, short y, short v1x, short v1y, short v2x, short v2y);

#endif
