/*
  David Vandensteen
  2018
*/

// TODO : rename loggers (ex logger_animate_sprite to log_gas)
// TODO : parametric macro for CDDA play

  //--------------------------------------------------------------------------//
 //                             DEFINE                                       //
//--------------------------------------------------------------------------//

#ifndef NEOCORE_H
#define NEOCORE_H
#include <DATlib.h>
#include <math.h>

#define NEOCORE_INIT \
  typedef struct bkp_ram_info { \
    WORD debug_dips; \
    BYTE stuff[254]; \
  } bkp_ram_info; \
  bkp_ram_info bkp_data;

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

#define Y_OFFSCREEN 240
#define X 0
#define Y 1

#define SHRUNK_TABLE_PROP_SIZE    0x2fe

#define JOYPAD            BYTE p1, ps;
#define JOYPAD_READ       p1 = volMEMBYTE(P1_CURRENT); ps = volMEMBYTE(PS_CURRENT);
#define JOYPAD_READ_EDGE  p1 = volMEMBYTE(P1_EDGE); ps = volMEMBYTE(PS_EDGE);
#define JOYPAD_IS_UP      p1&JOY_UP
#define JOYPAD_IS_DOWN    p1&JOY_DOWN
#define JOYPAD_IS_LEFT    p1&JOY_LEFT
#define JOYPAD_IS_RIGHT   p1&JOY_RIGHT
#define JOYPAD_IS_START   ps&P1_START
#define JOYPAD_IS_A       p1&JOY_A
#define JOYPAD_IS_B       p1&JOY_B
#define JOYPAD_IS_C       p1&JOY_C
#define JOYPAD_IS_D       p1&JOY_D

#define LOGGER_ON
#define LOGGER_X_INIT   1
#define LOGGER_Y_INIT   2

#define BOXCOPY(bFrom, bTo)   memcpy(bTo, bFrom, sizeof(Box))

#define FIX(value) value * 65536
#define RAND(value) rand() % value

#define SHRUNK_EXTRACT_X(value) value >> 8
#define SHRUNK_EXTRACT_Y(value) (BYTE)value

#define SPRITE_INDEX_MANAGER_MAX  384
#define PALETTE_INDEX_MANAGER_MAX 256

#define MANUALBOX 0
#define AUTOBOX 1

  /*----------------*/
 /* REFACTOR       */
/*----------------*/

// utils

#define close_vbl() SCClose()
#define get_frame_counter() DAT_frameCounter

enum direction { NONE, UP, DOWN, LEFT, RIGHT };

  //--------------------------------------------------------------------------//
 //                          STRUCTURE                                       //
//--------------------------------------------------------------------------//

typedef struct Vec2int { int x; int y; } Vec2int;
typedef struct Vec2short { short x; short y; } Vec2short;
typedef struct Vec2byte { BYTE x; BYTE y; } Vec2byte;

typedef struct Box {
  Vec2short p0;       /*!< coordinate 0 of the box (x, y) */
  Vec2short p1;       /*!< coordinate 1 of the box (x, y) */
  Vec2short p2;       /*!< coordinate 2 of the box (x, y) */
  Vec2short p3;       /*!< coordinate 3 of the box (x, y) */
  Vec2short p4;       /*!< coordinate 4 of the box (x, y) */
  short width;        /*!< width of the box */
  short height;       /*!< height of the box */
  short widthOffset;  /*!< width box reducing */
  short heightOffset; /*!< height box reducing */
} Box;

typedef struct GFX_Animated_Sprite {
  aSprite as;         /*!< - as is aSprite DATLib definition */
  spriteInfo *si;     /*!< - si is a pointer to DATLib spriteInfo structure */
  paletteInfo *pali;  /*!< - pali is a pointer to DATLib paletteInfo structure */
} GFX_Animated_Sprite;

typedef struct GFX_Picture {
  picture pic;        /*!< - pic is picture DATLib definition */
  pictureInfo *pi;    /*!< - pi is a pointer to DATLib pictureInfo structure */
  paletteInfo *pali;  /*!< - pali is a pointer to DATLib paletteInfo structure */
} GFX_Picture;

typedef struct GFX_Animated_Sprite_Physic {
  GFX_Animated_Sprite gfx_animated_sprite;  /*!< - GFX_Animated_Sprite */
  Box box;                          /*!< - Box */
  BOOL physic_enabled;              /*!< - enable physic (for collide detection capalities) */
} GFX_Animated_Sprite_Physic;

typedef struct GFX_Picture_Physic {
  GFX_Picture gfx_picture;  /*!< - GFX_Picture */
  Box box;              /*!< - Box */
  BOOL autobox_enabled; /*!< - enable autobox */
  BOOL physic_enabled;  /*!< - enable physic (for collide detection capabilities) */
} GFX_Picture_Physic;

typedef struct GFX_Scroller {
  scroller s;          /*!< - s is a pointer to DATLib scroller struture */
  scrollerInfo *si;    /*!< - si is a pointer to DATLib scrollerInfo structure */
  paletteInfo *pali;   /*!< - pali is a pointer to DATLib paletteInfo structure */
} GFX_Scroller;

  //--------------------------------------------------------------------------//
 //                                   GFX                                    //
//--------------------------------------------------------------------------//

void gfx_image_shrunk_centroid(GFX_Picture *gfx_picture, short center_x, short center_y, WORD shrunk_value);

  /*------------------*/
 /*  GFX INIT        */
/*------------------*/

void init_gs(GFX_Scroller *s, scrollerInfo *si, paletteInfo *pali);
void init_gp(GFX_Picture *gfx_picture, pictureInfo *pi, paletteInfo *pali);
void init_gpp(
  GFX_Picture_Physic *gfx_picture_physic,
  pictureInfo *pi,
  paletteInfo *pali,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset,
  BOOL autobox_enabled
);

void init_gas(GFX_Animated_Sprite *gfx_animated_sprite ,spriteInfo *si, paletteInfo *pali);
void init_gasp(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  spriteInfo *si,
  paletteInfo *pali,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset
);

  /*------------------*/
 /*  GFX DISPLAY     */
/*------------------*/

void display_gs(GFX_Scroller *s, short x, short y);
void display_gp(GFX_Picture *gfx_picture, short x, short y);
void display_gpp(GFX_Picture_Physic *gfx_picture_physic, short x, short y);
void display_gas(GFX_Animated_Sprite *gfx_animated_sprite, short x, short y, WORD anim);
void display_gasp(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, short x, short y, WORD anim);

  /*------------------*/
 /*  GFX VISIBILITY  */
/*------------------*/

void hide_gas(GFX_Animated_Sprite *gfx_animated_sprite);

void hide_gp(GFX_Picture *gfx_picture);
void hide_gpp(GFX_Picture_Physic *gfx_picture_physic);
void hide_gasp(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);

void show_gas(GFX_Animated_Sprite *gfx_animated_sprite);
void show_gasp(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);
void show_gp(GFX_Picture *gfx_picture);
void show_gpp(GFX_Picture_Physic *gfx_picture_physic);

  /*------------------*/
 /*  GFX POSITION    */
/*------------------*/

/* GFX POSITION GETTER */

short get_x_gas(GFX_Animated_Sprite gfx_animated_sprite);
short get_y_gas(GFX_Animated_Sprite gfx_animated_sprite);

short get_x_gasp(GFX_Animated_Sprite_Physic gfx_animated_sprite_physic);
short get_y_gasp(GFX_Animated_Sprite_Physic gfx_animated_sprite_physic);

short get_x_gp(GFX_Picture gfx_picture);
short get_y_gp(GFX_Picture gfx_picture);

short get_x_gpp(GFX_Picture_Physic gfx_picture_physic);
short get_y_gpp(GFX_Picture_Physic gfx_picture_physic);

short get_x_gs(GFX_Scroller gfx_scroller);
short get_y_gs(GFX_Scroller gfx_scroller);

/* GFX POSITION SETTER */

void set_pos_gpp(GFX_Picture_Physic *gfx_picture_physic, short x, short y);
void set_pos_gasp(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, short x, short y);

void set_x_gasp(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, short x);
void set_y_gasp(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, short y);

void set_x_gs(GFX_Scroller *gfx_scroller, short x);
void set_y_gs(GFX_Scroller *gfx_scroller, short x);
void set_pos_gs(GFX_Scroller *gfx_scroller, short x, short y);

void set_pos_gas(GFX_Animated_Sprite *gfx_animated_sprite, short x,  short y);
void set_pos_gp(GFX_Picture *gfx_picture, short x, short y);

  /*-------------------*/
 /*  GFX ANIMATION    */
/*-------------------*/

void move_gpp(GFX_Picture_Physic *gfx_picture_physic, short x_offset, short y_offset);
void move_gasp(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, short x_offset, short y_offset);

void move_gas(GFX_Animated_Sprite *gfx_animated_sprite, short x_offset, short y_offset);
void move_gp(GFX_Picture *gfx_picture, short x, short y);
void move_gs(GFX_Scroller gfx_scroller, short x, short y);

void set_anim_gas(GFX_Animated_Sprite *gfx_animated_sprite, WORD anim);
void set_anim_gasp(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, WORD anim);

void update_anim_gas(GFX_Animated_Sprite *gfx_animated_sprite);
void update_anim_gasp(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);


  /*-------------------*/
 /*  GFX DESTROY      */
/*-------------------*/

void gfx_scroller_destroy(GFX_Scroller *s); // TODO
void destroy_gp(GFX_Picture *gfx_picture);
void destroy_gas(GFX_Animated_Sprite *gfx_animated_sprite);

void destroy_gpp(GFX_Picture_Physic *gfx_picture_physic);
void destroy_gasp(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);

  //--------------------------------------------------------------------------//
 //                                   GPU                                    //
//--------------------------------------------------------------------------//

void inline init_gpu();
void inline clear_vram();
char get_sin(WORD index);

  /*------------------------------*/
 /* GPU VBL                      */
/*------------------------------*/

DWORD inline wait_vbl_max(WORD nb);
#define wait_vbl(); waitVBlank();

  /*------------------------------*/
 /* GPU SPRITE INDEX MANAGEMENT  */
/*------------------------------*/

void clear_sprite_index_table();
WORD get_max_free_sprite_index();
WORD get_max_sprite_index_used();

  /*---------------*/
 /* GPU PALETTE   */
/*---------------*/

void palette_destroy(paletteInfo* pi); // TODO : change to destroy_palette
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
void inline shrunk_addr(WORD addr, WORD shrunk_value);
WORD shrunk_range(WORD addr_start, WORD addr_end, WORD shrunk_value);

  //--------------------------------------------------------------------------//
 //                                PHYSIC                                    //
//--------------------------------------------------------------------------//

BYTE boxes_collide(Box *b, Box *boxes[], BYTE box_max);
BOOL box_collide(Box *b1, Box *b2);
void box_init(Box *b, short width, short height, short widthOffset, short heightOffset);
void box_update(Box *b, short x, short y);

//void mask_display(picture pic[], Vec2short vec[], BYTE vector_max); // todo (minor) - rename ? (vectorsDisplay)
void mask_update(short x, short y, Vec2short vec[], Vec2short offset[], BYTE vector_max); // todo (minor) - rename ? (vectorsDebug)

void box_shrunk(Box *b, Box *bOrigin, WORD shrunkValue);
void box_resize(Box *Box, short edge); // todo (minor) - deprecated ?

  //--------------------------------------------------------------------------//
 //                                SOUND                                     //
//--------------------------------------------------------------------------//

void cdda_play(BYTE track); // TODO : change to play_cdda

  //--------------------------------------------------------------------------//
 //                                  -F                                      //
//--------------------------------------------------------------------------//
void inline fix_print_neocore(int x, int y, char *label);

WORD free_ram_info();

  /*----------*/
 /* JOYPAD   */
/*----------*/

void        update_joypad();
void        update_joypad_edge();
BOOL        joypad_is_up();
BOOL        joypad_is_down();
BOOL        joypad_is_left();
BOOL        joypad_is_right();
BOOL        joypad_is_start();
BOOL        joypad_is_a();
BOOL        joypad_is_b();
BOOL        joypad_is_c();
BOOL        joypad_is_d();
void inline joypad_debug();

  //--------------------------------------------------------------------------//
 //                               LOGGER                                     //
//--------------------------------------------------------------------------//

void init_logger(); // TODO : change to init_logger
void logger_set_position(WORD _x, WORD _y);
WORD inline logger_info(char *txt); // TODO : change to log_info
void inline logger_word(char *label, WORD value);
void inline logger_int(char *label, int value);
void inline logger_dword(char *label, DWORD value);
void inline logger_short(char *label, short value);
void inline logger_byte(char *label, BYTE value);
void inline logger_bool(char *label, BOOL value);
void inline logger_animated_sprite(char *label, GFX_Animated_Sprite *gfx_animated_sprite);
void inline logger_spriteInfo(char *label, spriteInfo *si);
void inline logger_box(char *label, Box *b);
void inline logger_pictureInfo(char *label, pictureInfo *pi);

  //--------------------------------------------------------------------------//
 //                                  -V                                      //
//--------------------------------------------------------------------------//
void vec2int_init(Vec2int *vec, int x, int y);
void vec2short_init(Vec2short *vec, short x, short y);
void vec2byte_init(Vec2byte *vec, BYTE x, BYTE y);
BOOL vectors_collide(Box *box, Vec2short vec[], BYTE vector_max);
BOOL vector_is_left(short x, short y, short v1x, short v1y, short v2x, short v2y);

#endif
