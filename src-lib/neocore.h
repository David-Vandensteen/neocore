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

#define BOXCOPY(bFrom, bTo)   memcpy(bTo, bFrom, sizeof(box))

#define FIX(value) value * 65536
#define RAND(value) rand() % value

#define SHRUNK_EXTRACT_X(value) value >> 8
#define SHRUNK_EXTRACT_Y(value) (BYTE)value

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
  BOOL flashing;
  BOOL visible;
  WORD flashingFreq;
  WORD height;
};

typedef struct picturePhysic picturePhysic;
struct picturePhysic {
  picture p;
  box box;
  BOOL visible;
};

void          aSpritePhysicDisplay(aSpritePhysic *asp, spriteInfo *si, paletteInfo *pali, short posX, short posY, WORD anim);

// TODO to deprecated
aSpritePhysic aSpritePhysicDisplayAutobox(spriteInfo *si, paletteInfo *pali, short posX, short posY, WORD height, WORD anim);
//

void          aSpritePhysicShow(aSpritePhysic *asp, BOOL pvisible);
void          aSpritePhysicFlash(aSpritePhysic *asp, BOOL pflash, WORD freq);
void          aSpritePhysicFlashUpdate(aSpritePhysic *asp);
void          aSpritePhysicCollide(aSpritePhysic *asp, box *box); // TODO not implementd ??? needed ???
void          aSpritePhysicSetPos(aSpritePhysic *asp, short x, short y);
void          aSpritePhysicMove(aSpritePhysic *asp, short x, short y);
void          aSpriteShrunk(aSprite *as, spriteInfo *si, WORD shrunk_value);
void          aSpriteShowNeocore(aSprite *as, BOOL visible);
aSprite       aSpriteDisplay(spriteInfo *si, paletteInfo *pali, short posX, short posY, WORD anim);
WORD          aSpriteGetSpriteIndexAutoinc(spriteInfo *si);

BYTE      boxesCollide(box *b, box *boxes[], BYTE box_max);
BOOL      boxCollide(box *b1, box *b2);

// TODO to deprecated boxMake
box       boxMake(short p0x, short p0y, short p1x, short p1y, short p2x, short p2y, short p3x, short p3y);

void      boxInit(box *b, short width, short height, short widthOffset, short heightOffset);
void      boxUpdate(box *b, short x, short y);
void      boxDebugUpdate(picture5 *pics, box *box);
picture5  boxDisplay(box *box);
void      boxResize(box *box, short edge);

void inline clearVram();

void inline fixPrintNeocore(int x, int y, char *label);

void inline gpuInit();

BOOL isVectorLeft(short x, short y, short v1x, short v1y, short v2x, short v2y);

void                  joypadUpdate();
void                  joypadUpdateEdge();
BOOL                  joypadIsUp();
BOOL                  joypadIsDown();
BOOL                  joypadIsLeft();
BOOL                  joypadIsRight();
BOOL                  joypadIsStart();
BOOL                  joypadIsA();
BOOL                  joypadIsB();
BOOL                  joypadIsC();
BOOL                  joypadIsD();
void inline           joypadDebug();

void        loggerInit();
void        loggerPositionSet(WORD _x, WORD _y);
WORD inline loggerInfo(char *txt);
void inline loggerWord(char *label, WORD value);
void inline loggerInt(char *label, int value);
void inline loggerDword(char *label, DWORD value);
void inline loggerShort(char *label, short value);
void inline loggerByte(char *label, BYTE value);
void inline loggerBool(char *label, BOOL value);
void inline loggerAsprite(char *label, aSprite *as);
void inline loggerSpriteInfo(char *label, spriteInfo *si);
void inline loggerBox(char *label, box *b);
void inline loggerPictureInfo(char *label, pictureInfo *pi);

// TODO to deprecated
picturePhysic picturePhysicAutobox(pictureInfo *pi, paletteInfo *pali, short posX, short posY);
picturePhysic picturePhysicDisplayAutobox(pictureInfo *pi, paletteInfo *pali, short posX, short posY);
//

void          picturePhysicDisplay(picturePhysic *pp, pictureInfo *pi, paletteInfo *pali, short posX, short posY);
void          picturePhysicSetPos(picturePhysic *pp, short x, short y);
void          picturePhysicMove(picturePhysic *pp, short x, short y);
void          pictureShrunk(picture *p, pictureInfo *pi, WORD shrunk_value);
void          picturesShow(picture *p, WORD max, BOOL visible);
void          picture5Show(picture5 *pics, BOOL visible);
picture       pictureDisplay(pictureInfo *pi, paletteInfo *pali, short posX, short posY);
void          pictureShrunkCentroid(picture *p, pictureInfo *pi, short centerPosX, short centerPosY, WORD shrunk_value);
void          paletteDisableAutoinc();
void          paletteEnableAutoinc();
BYTE          paletteGetIndex();
BYTE          paletteSetIndex(BYTE index);
WORD          pictureGetSpriteIndexAutoinc(pictureInfo *pi);
BYTE          paletteGetIndexAutoinc(paletteInfo *pali);

void maskDisplay(picture pic[], vec2short vec[], BYTE vector_max); // TODO rename ? (vectorsDisplay)
void maskUpdate(short x, short y, vec2short vec[], vec2short offset[], BYTE vector_max); // TODO rename ? (vectorsDebug)
// TODO hardcode point\dot asset

vec2int   vec2intMake(int x, int y);
vec2short vec2shortMake(short x, short y);
vec2byte  vec2byteMake(BYTE x, BYTE y);
BOOL      vectorsCollide(box *box, vec2short vec[], BYTE vector_max);

WORD        shrunkForge(BYTE xc, BYTE yc);
void inline shrunk(WORD addr, WORD shrunk_value);
WORD        shrunkRange(WORD addr_start, WORD addr_end, WORD shrunk_value);
WORD        shrunkPropTableGet(WORD index); // TODO rename shrunkGetPropTable ?
char        sinTableGet(WORD index);
scroller    scrollerDisplay(scrollerInfo *si, paletteInfo *pali, short posX, short posY);
void        spriteDisableAutoinc();
void        spriteEnableAutoinc();
WORD        spriteGetIndex();
void        spriteSetIndex(WORD index);
WORD        scrollerGetSpriteIndexAutoinc(scrollerInfo *si);
void        scrollerMove(scroller *sc, short x, short y);
short       shrunkCentroidGetTranslatedX(short centerPosX, WORD tileWidth, BYTE shrunkX);
short       shrunkCentroidGetTranslatedY(short centerPosY, WORD tileHeight, BYTE shrunkY);

DWORD inline waitVbl(WORD nb);
#endif
