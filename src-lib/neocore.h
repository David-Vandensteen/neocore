/*
	David Vandensteen
	2018
*/
  // NeoDev type memo:
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

// #define HIDE_X  50
// #define HIDE_Y  50

#define BOXCOPY(bFrom, bTo)   memcpy(bTo, bFrom, sizeof(box))

#define FIX(value) value * 65536
#define RAND(value) rand() % value

#define SHRUNK_EXTRACT_X(value) value >> 8
#define SHRUNK_EXTRACT_Y(value) (BYTE)value

// overwrite aSpriteHide DAT macro
#undef aSpriteHide(as)
#define aSpriteHide(as)            { (as)->flags|=0x0080; clearSprites(as->baseSprite, as->tileWidth); }
#define aSpriteHideDAT(as)         { (as)->flags|=0x0080; }

// overwrite pictureHide, pictureShow DAT func
// #define pictureHide(p) { short x = (p)->posX; short y = (p)->posY; pictureSetPos(p, HIDE_X, HIDE_Y); (p)->posX = x; (p)->posY = y; loggerInfo("OVER PHIDE"); }
// #define pictureShow(p) { pictureSetPos(p, (p)->posX, (p)->posY); loggerInfo("OVER PSHOW"); }

enum direction { NONE, UP, DOWN, LEFT, RIGHT };

typedef struct vec2int vec2int;
struct vec2int {
  int x;
  int y;
};

typedef struct vec2short vec2short;
struct vec2short {
  short x;
  short y;
};

typedef struct vec2byte vec2byte;
struct vec2byte {
  BYTE x;
  BYTE y;
};

typedef struct box box;
struct box {
  vec2short p0;
  vec2short p1;
  vec2short p2;
  vec2short p3;
  vec2short p4;
  short width;
  short height;
  short widthOffset;
  short heightOffset;
};

typedef struct picture5 picture5;
struct picture5 {
  picture pic0;
  picture pic1;
  picture pic2;
  picture pic3;
  picture pic4;
};

typedef struct aSpritePhysic aSpritePhysic;
struct aSpritePhysic {
  aSprite as; //50 bytes
  box box;
  WORD height;
};

typedef struct picturePhysic picturePhysic;
struct picturePhysic {
  picture p;
  box box;
  BOOL visible;
};

typedef struct picturePhysicShrunkCentroid picturePhysicShrunkCentroid;
struct picturePhysicShrunkCentroid {
  picturePhysic pp;
  pictureInfo *pi;
  paletteInfo *pali;
  vec2short positionCenter;
  box boxOrigin;
};
//  a
void animated_sprite_physic_display(aSpritePhysic *asp, spriteInfo *si, paletteInfo *pali, short posX, short posY, WORD anim);
void animated_sprite_physic_collide(aSpritePhysic *asp, box *box); // TODO not implementd ??? needed ???
void animated_sprite_physic_set_position(aSpritePhysic *asp, short x, short y);
void animated_sprite_physic_move(aSpritePhysic *asp, short x, short y);
void animated_sprite_physic_shrunk(aSprite *as, spriteInfo *si, WORD shrunk_value);

void animated_sprite_display(aSprite *as, spriteInfo *si, paletteInfo *pali, short posX, short posY, WORD anim);
WORD animated_sprite_index_auto(spriteInfo *si);
void animated_sprite_flash(aSprite *as, BYTE freq);
BOOL animated_sprite_is_visible(aSprite *as);

// b
BYTE boxes_collide(box *b, box *boxes[], BYTE box_max);
BOOL box_collide(box *b1, box *b2);
void box_init(box *b, short width, short height, short widthOffset, short heightOffset);
void box_update(box *b, short x, short y);
void box_debug_update(picture5 *pics, box *box);
void box_display(picture5 *pics, box *box, pictureInfo *pi, paletteInfo *pali);
void box_shrunk(box *b, box *bOrigin, WORD shrunkValue);
// todo - deprecated ?
void boxResize(box *box, short edge);

// c
void inline clear_vram();

// f
void inline fix_print_neocore(int x, int y, char *label);

// g
void inline gpu_init();

// todo - change signature
BOOL isVectorLeft(short x, short y, short v1x, short v1y, short v2x, short v2y);
BOOL vector_is_left(short x, short y, short v1x, short v1y, short v2x, short v2y);

// j
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

// l
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
void inline logger_box(char *label, box *b);
void inline logger_pictureInfo(char *label, pictureInfo *pi);

// p
// old proto
void          picturePhysicShrunkCentroidInit(picturePhysicShrunkCentroid *pps, pictureInfo *pi, paletteInfo *pali, short xCenter, short yCenter);
void          picturePhysicShrunkCentroidSetPos(picturePhysicShrunkCentroid *pps, short x, short y);
void          picturePhysicShrunkCentroidMove(picturePhysicShrunkCentroid *pps, short xShift, short yShift);
void          picturePhysicShrunkCentroidUpdate(picturePhysicShrunkCentroid *pps, WORD shrunk);
void          picturePhysicShrunkCentroidDisplay(picturePhysicShrunkCentroid *pps, WORD shrunk);
void          picturePhysicDisplay(picturePhysic *pp, pictureInfo *pi, paletteInfo *pali, short posX, short posY);
void          picturePhysicSetPos(picturePhysic *pp, short x, short y);
void          picturePhysicMove(picturePhysic *pp, short x, short y);
void          pictureShrunk(picture *p, pictureInfo *pi, WORD shrunk_value);
void          picturesShow(picture *p, WORD max, BOOL visible); // TODO deprecated, implement picturesHide, picturesShow, pictureHide, pictureShow
void          picture5Show(picture5 *pics, BOOL visible); // TODO deprecated
void          pictureDisplay(picture *p, pictureInfo *pi, paletteInfo *pali, short posX, short posY);
void          pictureShrunkCentroid(picture *p, pictureInfo *pi, short centerPosX, short centerPosY, WORD shrunk_value);
void          pictureFlash(picture *p, BYTE freq);
void          paletteDisableAutoinc();
void          paletteEnableAutoinc();
BYTE          paletteGetIndex();
BYTE          paletteSetIndex(BYTE index);
WORD          pictureGetSpriteIndexAutoinc(pictureInfo *pi);
BYTE          paletteGetIndexAutoinc(paletteInfo *pali);

// new proto
void image_physic_shrunk_centroid_init(picturePhysicShrunkCentroid *pps, pictureInfo *pi, paletteInfo *pali, short xCenter, short yCenter);
void image_physic_shrunk_centroid_set_position(picturePhysicShrunkCentroid *pps, short x, short y);
void image_physic_shrunk_centroid_move(picturePhysicShrunkCentroid *pps, short xShift, short yShift);
void image_physic_shrunk_centroid_update(picturePhysicShrunkCentroid *pps, WORD shrunk);
void image_physic_shrunk_centroid_display(picturePhysicShrunkCentroid *pps, WORD shrunk);
void image_physic_display(picturePhysic *pp, pictureInfo *pi, paletteInfo *pali, short posX, short posY);
void image_physic_set_position(picturePhysic *pp, short x, short y);
void image_physic_move(picturePhysic *pp, short x, short y);
void image_shrunk(picture *p, pictureInfo *pi, WORD shrunk_value);
void images_show(picture *p, WORD max, BOOL visible); // TODO deprecated, implement picturesHide, picturesShow, pictureHide, pictureShow
void image5_show(picture5 *pics, BOOL visible); // TODO deprecated
void image_display(picture *p, pictureInfo *pi, paletteInfo *pali, short posX, short posY);
void image_shrunk_centroid(picture *p, pictureInfo *pi, short centerPosX, short centerPosY, WORD shrunk_value);
void image_flash(picture *p, BYTE freq);
void palette_disable_autoinc();
void palette_enable_autoinc();
BYTE palette_get_index();
BYTE palette_set_index(BYTE index);
WORD image_get_sprite_index_autoinc(pictureInfo *pi);
BYTE palette_get_index_autoinc(paletteInfo *pali);


void maskDisplay(picture pic[], vec2short vec[], BYTE vector_max); // TODO rename ? (vectorsDisplay)
void maskUpdate(short x, short y, vec2short vec[], vec2short offset[], BYTE vector_max); // TODO rename ? (vectorsDebug)
// TODO hardcode point\dot asset

vec2int   vec2intMake(int x, int y);
vec2short vec2shortMake(short x, short y);
vec2byte  vec2byteMake(BYTE x, BYTE y);
BOOL      vectorsCollide(box *box, vec2short vec[], BYTE vector_max);

WORD        shrunkForge(BYTE xc, BYTE yc);
void inline shrunkAddr(WORD addr, WORD shrunk_value);
WORD        shrunkRange(WORD addr_start, WORD addr_end, WORD shrunk_value);
WORD        shrunkPropTableGet(WORD index); // TODO rename shrunkGetPropTable ?
char        sinTableGet(WORD index);
void        scrollerDisplay(scroller *s, scrollerInfo *si, paletteInfo *pali, short posX, short posY);
void        spriteDisableAutoinc();
void        spriteEnableAutoinc();
WORD        spriteGetIndex();
void        spriteSetIndex(WORD index);
WORD        scrollerGetSpriteIndexAutoinc(scrollerInfo *si);
void        scrollerMove(scroller *sc, short x, short y);
int         shrunkCentroidGetTranslatedX(short centerPosX, WORD tileWidth, BYTE shrunkX);
int         shrunkCentroidGetTranslatedY(short centerPosY, WORD tileHeight, BYTE shrunkY);

DWORD inline waitVbl(WORD nb);
#endif
