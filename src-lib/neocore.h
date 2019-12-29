/*
	David Vandensteen
	2018
*/
  // short  ->  2 bytes
  // word   ->  2 bytes
  // dword  ->  4 bytes
  // char   ->  1 byte
  // int    ->  4 bytes
  // byte   ->  1 byte


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

#define GPU_INIT  gpu_init();

#define __ALIGN1__      __attribute__ ((aligned (1)))
#define __ALIGN2__      __attribute__ ((aligned (2)))
#define __ALIGN4__      __attribute__ ((aligned (4)))
#define __ALIGN64__ 		__attribute__ ((aligned (64)))
#define __ALIGN128__		__attribute__ ((aligned (128)))

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

#define JOYPAD  		    	BYTE p1, ps;
#define JOYPAD_READ		    p1 = volMEMBYTE(P1_CURRENT); ps = volMEMBYTE(PS_CURRENT);
#define JOYPAD_READ_EDGE  p1 = volMEMBYTE(P1_EDGE); ps = volMEMBYTE(PS_EDGE);
#define JOYPAD_IS_UP			p1&JOY_UP
#define JOYPAD_IS_DOWN		p1&JOY_DOWN
#define JOYPAD_IS_LEFT		p1&JOY_LEFT
#define JOYPAD_IS_RIGHT		p1&JOY_RIGHT
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

enum direction { NONE, UP, DOWN, LEFT, RIGHT };

typedef struct Vec2int Vec2int;
struct Vec2int {
  int x;
  int y;
};

typedef struct Vec2short Vec2short;
struct Vec2short {
  short x;
  short y;
};

typedef struct Vec2byte Vec2byte;
struct Vec2byte {
  BYTE x;
  BYTE y;
};

typedef struct Box Box;
struct Box {
  Vec2short p0;
  Vec2short p1;
  Vec2short p2;
  Vec2short p3;
  Vec2short p4;
  short width;
  short height;
  short widthOffset;
  short heightOffset;
};

/* todo (minor) - to remove
typedef struct picture5 picture5;
struct picture5 {
  picture pic0;
  picture pic1;
  picture pic2;
  picture pic3;
  picture pic4;
};
*/

typedef struct Flash Flash;
struct Flash {
  WORD frequency;
  WORD lengh;
  BOOL visible;
  BOOL enabled;
};

typedef struct Animated_Sprite Animated_Sprite;
struct Animated_Sprite {
  aSprite as;
  spriteInfo *si;
  paletteInfo *pali;
  Flash flash;
};

typedef struct Image Image;
struct Image {
  picture pic;
  pictureInfo *pi;
  paletteInfo *pali;
  Flash flash;
};

typedef struct Animated_Sprite_Physic Animated_Sprite_Physic;
struct Animated_Sprite_Physic {
  Animated_Sprite animated_sprite;
  Box box;
  BOOL physic_enabled;
};

typedef struct Image_Physic Image_Physic;
struct Image_Physic {
  Image image;
  Box box;
  BOOL physic_enabled;
};

typedef struct Scroller Scroller;
struct Scroller {
  scroller s;
  scrollerInfo *si;
  paletteInfo *pali;
};

/* todo (minor) - to remove
typedef struct picturePhysic picturePhysic;
struct picturePhysic {
  picture p;
  Box box;
  BOOL visible;
};
*/

/* todo (minor) - to remake
typedef struct picturePhysicShrunkCentroid picturePhysicShrunkCentroid;
struct picturePhysicShrunkCentroid {
  picturePhysic pp;
  pictureInfo *pi;
  paletteInfo *pali;
  Vec2short positionCenter;
  Box boxOrigin;
};
*/

  //--------------------------------------------------------------------------//
 //                                  -A                                      //
//--------------------------------------------------------------------------//
  /*------------------*/
 /* -animated_sprite */
/*------------------*/
void animated_sprite_physic_init(
  Animated_Sprite_Physic *animated_sprite_physic,
  spriteInfo *si,
  paletteInfo *pali,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset
);
void animated_sprite_init(Animated_Sprite *animated_sprite ,spriteInfo *si, paletteInfo *pali);
void animated_sprite_display(Animated_Sprite *animated_sprite, short x, short y, WORD anim);
#define animated_sprite_move(animated_sprite, x_offset, y_offset) aSpriteMove(animated_sprite.as, x_offset, y_offset)
#define animated_sprite_set_position(animated_sprite, x, y) aSpriteSetPos(animated_sprite.as, x, y)
void animated_sprite_hide(Animated_Sprite *animated_sprite);
void animated_sprite_show(Animated_Sprite *animated_sprite);
void animated_sprite_set_animation(Animated_Sprite *animated_sprite, WORD anim);
#define animated_sprite_animate(animated_sprite) aSpriteAnimate(animated_sprite.as)
BOOL animated_sprite_flash(Animated_Sprite *animated_sprite);

  /*--------------------------*/
 /* -animated_sprite_physic  */
/*--------------------------*/
void animated_sprite_physic_display(Animated_Sprite_Physic *animated_sprite_physic, short x, short y, WORD anim);
// void animated_sprite_physic_collide(aSpritePhysic *asp, Box *box); // todo - not implementd ??? needed ???
void animated_sprite_physic_set_position(Animated_Sprite_Physic *animated_sprite_physic, short x, short y);
void animated_sprite_physic_move(Animated_Sprite_Physic *animated_sprite_physic, short x_offset, short y_offset);
void animated_sprite_physic_shrunk(Animated_Sprite_Physic *animated_sprite_physic, WORD shrunk_value);
void animated_sprite_physic_hide(Animated_Sprite_Physic *animated_sprite_physic);
void animated_sprite_physic_show(Animated_Sprite_Physic *animated_sprite_physic);
void animated_sprite_physic_flash(Animated_Sprite_Physic *animated_sprite_physic);


  //--------------------------------------------------------------------------//
 //                                  -B                                      //
//--------------------------------------------------------------------------//
BYTE boxes_collide(Box *b, Box *boxes[], BYTE box_max);
BOOL box_collide(Box *b1, Box *b2);
void box_init(Box *b, short width, short height, short widthOffset, short heightOffset);
void box_update(Box *b, short x, short y);
// void box_debug_update(picture5 *pics, Box *box); // todo (minor)
// void box_display(picture5 *pics, Box *box, pictureInfo *pi, paletteInfo *pali); // todo (minor)
void box_shrunk(Box *b, Box *bOrigin, WORD shrunkValue);
// todo (minor) - deprecated ?
void box_resize(Box *Box, short edge);

  //--------------------------------------------------------------------------//
 //                                  -C                                      //
//--------------------------------------------------------------------------//
void inline clear_vram();

  //--------------------------------------------------------------------------//
 //                                  -F                                      //
//--------------------------------------------------------------------------//
void inline fix_print_neocore(int x, int y, char *label);
void flash_init(Flash *flash, short frequency, short lengh);

  //--------------------------------------------------------------------------//
 //                                  -G                                      //
//--------------------------------------------------------------------------//
void inline gpu_init();
WORD        get_sprite_index();
WORD        get_sprite_index_from_picture(pictureInfo *pi);
WORD        get_sprite_index_from_sprite(spriteInfo *si);
BYTE        get_palette_index();
WORD        get_shrunk_proportional_table(WORD index);

  //--------------------------------------------------------------------------//
 //                                  -I                                      //
//--------------------------------------------------------------------------//
BOOL is_visible(Flash *flash);

  /*------------------*/
 /*      -image      */
/*------------------*/
void image_init(Image *image, pictureInfo *pi, paletteInfo *pali);
void image_display(Image *image, short x, short y);
#define image_move(image, x_offset, y_offset) pictureMove(image.pic, x_offset, y_offset)
void image_set_position(Image *image, short x, short y);
void image_hide(Image *image);
void image_show(Image *image);
void image_is_visible(Image *image);
BOOL image_flash(Image *image);
void image_shrunk_centroid(Image *image, short center_x, short center_y, WORD shrunk_value);

  /*------------------*/
 /*  -image_physic   */
/*------------------*/
void image_physic_init(
  Image_Physic *image_physic,
  pictureInfo *pi,
  paletteInfo *pali,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset
);
void image_physic_display(Image_Physic *image_physic, short x, short y);
void image_physic_move(Image_Physic *image_physic, short x_offset, short y_offset);
void image_physic_set_position(Image_Physic *image_physic, short x, short y);
void image_physic_hide(Image_Physic *image_physic);
void image_physic_show(Image_Physic *image_physic);
void image_physic_flash(Image_Physic *image_physic);
void image_physic_shrunk(Image_Physic *image_physic, WORD shrunk_value);

/* todo (minor)
void image_physic_shrunk_centroid_init(picturePhysicShrunkCentroid *pps, pictureInfo *pi, paletteInfo *pali, short xCenter, short yCenter);
void image_physic_shrunk_centroid_set_position(picturePhysicShrunkCentroid *pps, short x, short y);
void image_physic_shrunk_centroid_move(picturePhysicShrunkCentroid *pps, short xShift, short yShift);
void image_physic_shrunk_centroid_update(picturePhysicShrunkCentroid *pps, WORD shrunk);
void image_physic_shrunk_centroid_display(picturePhysicShrunkCentroid *pps, WORD shrunk);
void image_physic_display(picturePhysic *pp, pictureInfo *pi, paletteInfo *pali, short posX, short posY);
void image_physic_set_position(picturePhysic *pp, short x, short y);
void image_physic_move(picturePhysic *pp, short x, short y);
void image_shrunk(picture *p, pictureInfo *pi, WORD shrunk_value);
void images_show(picture *p, WORD max, BOOL visible);
void image5_show(picture5 *pics, BOOL visible);
void image_display(picture *p, pictureInfo *pi, paletteInfo *pali, short posX, short posY);
void image_shrunk_centroid(picture *p, pictureInfo *pi, short centerPosX, short centerPosY, WORD shrunk_value);
void image_flash(picture *p, BYTE freq);
WORD image_get_sprite_index_autoinc(pictureInfo *pi);
*/


  //--------------------------------------------------------------------------//
 //                                  -J                                      //
//--------------------------------------------------------------------------//
  /*----------*/
 /* -joypad  */
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
 //                                  -L                                       //
//--------------------------------------------------------------------------//
  /*----------*/
 /* -logger  */
/*----------*/
void        logger_init();
void        logger_set_position(WORD _x, WORD _y);
WORD inline logger_info(char *txt);
void inline logger_word(char *label, WORD value);
void inline logger_int(char *label, int value);
void inline logger_dword(char *label, DWORD value);
void inline logger_short(char *label, short value);
void inline logger_byte(char *label, BYTE value);
void inline logger_bool(char *label, BOOL value);
void inline logger_animated_sprite(char *label, aSprite *as);
void inline logger_spriteInfo(char *label, spriteInfo *si);
void inline logger_box(char *label, Box *b);
void inline logger_pictureInfo(char *label, pictureInfo *pi);

  //--------------------------------------------------------------------------//
 //                                  -P                                      //
//--------------------------------------------------------------------------//
  /*-----------*/
 /* -palette  */
/*-----------*/
void palette_disable_auto_index();
void palette_enable_auto_index();

// m
//void mask_display(picture pic[], Vec2short vec[], BYTE vector_max); // todo (minor) - rename ? (vectorsDisplay)
void mask_update(short x, short y, Vec2short vec[], Vec2short offset[], BYTE vector_max); // todo (minor) - rename ? (vectorsDebug)
// todo (minor) - hardcode point\dot asset

  //--------------------------------------------------------------------------//
 //                                  -V                                      //
//--------------------------------------------------------------------------//
void vec2int_init(Vec2int *vec, int x, int y);
void vec2short_init(Vec2short *vec, short x, short y);
void vec2byte_init(Vec2byte *vec, BYTE x, BYTE y);
BOOL vectors_collide(Box *box, Vec2short vec[], BYTE vector_max);
BOOL vector_is_left(short x, short y, short v1x, short v1y, short v2x, short v2y);

  //--------------------------------------------------------------------------//
 //                                  -S                                      //
//--------------------------------------------------------------------------//
char        sin_table_get(WORD index);
void        set_sprite_index(WORD index);
BYTE        set_palette_index(BYTE index);
  /*-----------*/
 /* -scroller */
/*-----------*/
void        scroller_init(Scroller *s, scrollerInfo *si, paletteInfo *pali);
void        scroller_display(Scroller *s, short x, short y);
void        scroller_move(Scroller *s, short x, short y);
void        scroller_set_position(Scroller *s, short x, short y);

  /*-----------*/
 /* -shrunk   */
/*-----------*/
int         shrunk_centroid_get_translated_x(short centerPosX, WORD tileWidth, BYTE shrunkX);
int         shrunk_centroid_get_translated_y(short centerPosY, WORD tileHeight, BYTE shrunkY);
void        shrunk(WORD base_sprite, WORD max_width, WORD value);
WORD        shrunk_forge(BYTE xc, BYTE yc);
void inline shrunk_addr(WORD addr, WORD shrunk_value);
WORD        shrunk_range(WORD addr_start, WORD addr_end, WORD shrunk_value);

  //--------------------------------------------------------------------------//
 //                                  -W                                      //
//--------------------------------------------------------------------------//
DWORD inline wait_vbl_max(WORD nb);
#define WAIT_VBL waitVBlank();

#endif
