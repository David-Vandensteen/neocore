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
#define init_logger() logger_init()
#define update_joypad_edge() joypad_update_edge()
#define update_joypad() joypad_update()

#define close_vbl() SCClose()
#define init_gpu() gpu_init()

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

#define hide_gp(gfx_picture_pointer) pictureHide(gfx_picture_pointer.pic)
#define hide_gpp(gfx_picture_physic_pointer) pictureHide(gfx_picture_physic_pointer.gfx_picture.pic)
#define hide_gasp(gfx_animated_sprite_physic_pointer) hide_gas(gfx_animated_sprite_physic_pointer.gfx_animated_sprite)

#define show_gas(gfx_animated_sprite_pointer) aSpriteShow(gfx_animated_sprite_pointer.as)
#define show_gasp(gfx_animated_sprite_physic_pointer) aSpriteShow(gfx_animated_sprite_physic_pointer.gfx_animated_sprite.as)
#define show_gp(gfx_picture_pointer) pictureShow(gfx_picture_pointer.pic)
#define show_gpp(gfx_picture_physic_pointer) pictureShow(gfx_picture_physic_pointer.gfx_picture.pic);

  /*------------------*/
 /*  GFX POSITION    */
/*------------------*/

/* GFX POSITION GETTER */

#define get_x_gas(gfx_animated_sprite) gfx_animated_sprite.as.posX
#define get_y_gas(gfx_animated_sprite) gfx_animated_sprite.as.posY

#define get_x_gasp(gfx_animated_sprite_physic) gfx_animated_sprite_physic.gfx_animated_sprite.as.posX
#define get_y_gasp(gfx_animated_sprite_physic) gfx_animated_sprite_physic.gfx_animated_sprite.as.posY

#define get_x_gp(gfx_picture) gfx_picture.pic.posX
#define get_y_gp(gfx_picture) gfx_picture.pic.posY

#define get_x_gpp(gfx_picture_physic) gfx_picture_physic.gfx_picture.pic.posX
#define get_y_gpp(gfx_picture_physic) gfx_picture_physic.gfx_picture.pic.posY

#define get_x_gs(gfx_scroller) gfx_scroller.s.scrlPosX
#define get_y_gs(gfx_scroller) gfx_scroller.s.scrlPosY

/* GFX POSITION SETTER */

void set_pos_gpp(GFX_Picture_Physic *gfx_picture_physic, short x, short y);
void set_pos_gasp(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, short x, short y);

#define set_x_gasp(gfx_animated_sprite_physic_pointer, x) set_pos_gasp(gfx_animated_sprite_physic_pointer, x, gfx_animated_sprite_physic.gfx_animated_sprite.as.posY)
#define set_y_gasp(gfx_animated_sprite_physic_pointer, y) set_pos_gasp(gfx_animated_sprite_physic_pointer, gfx_animated_sprite_physic.gfx_animated_sprite.as.posX, y)

#define set_x_gs(gfx_scroller_pointer, x) scrollerSetPos(gfx_scroller_pointer.s, x, gfx_scroller_pointer.s.scrlPosY)
#define set_y_gs(gfx_scroller_pointer, x) scrollerSetPos(gfx_scroller_pointer.s, gfx_scroller_pointer.s.scrlPosX, y)

#define set_pos_gs(gfx_scroller_pointer, x, y) scrollerSetPos(gfx_scroller_pointer.s, x, y)
#define set_pos_gas(gfx_animated_sprite_pointer, x, y) aSpriteSetPos(gfx_animated_sprite_pointer.as, x, y)
#define set_pos_gp(gfx_picture_pointer, x, y) pictureSetPos(gfx_picture_pointer.pic, x, y)

  /*-------------------*/
 /*  GFX ANIMATION    */
/*-------------------*/

void move_gpp(GFX_Picture_Physic *gfx_picture_physic, short x_offset, short y_offset);
void move_gasp(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, short x_offset, short y_offset);

#define move_gas(gfx_animated_sprite, x_offset, y_offset) aSpriteMove(gfx_animated_sprite.as, x_offset, y_offset)
#define move_gp(gfx_picture_pointer, x, y) pictureMove(gfx_picture_pointer.pic, x, y)
#define move_gs(gfx_scroller, x, y) scrollerSetPos(&gfx_scroller.s, gfx_scroller.s.scrlPosX + x, gfx_scroller.s.scrlPosY + y)

#define set_anim_gas(gfx_animated_sprite, anim) aSpriteSetAnim(gfx_animated_sprite.as, anim)
#define set_anim_gasp(gfx_animated_sprite_physic, anim) aSpriteSetAnim(gfx_animated_sprite_physic.gfx_animated_sprite.as, anim)

#define update_anim_gas(gfx_animated_sprite_pointer) aSpriteAnimate(gfx_animated_sprite_pointer.as)
#define update_anim_gasp(gfx_animated_sprite_physic_pointer) aSpriteAnimate(gfx_animated_sprite_physic_pointer.gfx_animated_sprite.as)

  /*-------------------*/
 /*  GFX DESTROY      */
/*-------------------*/

void gfx_scroller_destroy(GFX_Scroller *s); // TODO
void destroy_gp(GFX_Picture *gfx_picture);
void destroy_gas(GFX_Animated_Sprite *gfx_animated_sprite);

#define destroy_gpp(gfx_picture_physic_pointer) destroy_gp(gfx_picture_physic_pointer.gfx_picture)
#define destroy_gasp(gfx_animated_sprite_physic_pointer) destroy_gas(gfx_animated_sprite_physic_pointer.gfx_animated_sprite)

  //--------------------------------------------------------------------------//
 //                                   GPU                                    //
//--------------------------------------------------------------------------//

void inline gpu_init(); // TODO : change to init_gpu
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
// todo (minor) - hardcode point\dot asset


// todo (minor)
void box_shrunk(Box *b, Box *bOrigin, WORD shrunkValue);
// todo (minor) - deprecated ?
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

void        joypad_update();
void        joypad_update_edge();
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

void logger_init(); // TODO : change to init_logger
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
