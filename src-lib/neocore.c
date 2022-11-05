/*
  David Vandensteen
  2018
*/

#include <DATlib.h>
#include <input.h>
#include <stdio.h>
#include <neocore.h>
#include <math.h>

  /*------------------*/
 /* -define          */
/*------------------*/

#define CDDA_PLAY_TRACK_02 \
  asm("loop_track_02:"); \
  asm(" move.w #0x0002,%d0"); \
  asm(" tst.b  0x10F6D9"); \
  asm(" beq.s  loop_track_02"); \
  asm(" jsr  0xC0056A"); \

#define CDDA_PLAY_TRACK_03 \
  asm("loop_track_03:"); \
  asm(" move.w #0x0003,%d0"); \
  asm(" tst.b  0x10F6D9"); \
  asm(" beq.s  loop_track_03"); \
  asm(" jsr  0xC0056A"); \

#define CDDA_PLAY_TRACK_04 \
  asm("loop_track_04:"); \
  asm(" move.w #0x0004,%d0"); \
  asm(" tst.b  0x10F6D9"); \
  asm(" beq.s  loop_track_04"); \
  asm(" jsr  0xC0056A"); \

#define CDDA_PLAY_TRACK_05 \
  asm("loop_track_05:"); \
  asm(" move.w #0x0005,%d0"); \
  asm(" tst.b  0x10F6D9"); \
  asm(" beq.s  loop_track_05"); \
  asm(" jsr  0xC0056A"); \

NEOCORE_INIT

  /*------------------*/
 /* -static          */
/*------------------*/
static BOOL sprite_index_manager_status[SPRITE_INDEX_MANAGER_MAX];
static paletteInfo *palette_index_manager_status[PALETTE_INDEX_MANAGER_MAX];

static BOOL collide_point(short x, short y, Vec2short vec[], BYTE vector_max);
static const WORD shrunk_table_prop[] = { 0x000 , 0x001 , 0x002 , 0x003 , 0x004 , 0x005 , 0x006 , 0x007 , 0x008 , 0x009 , 0x00a , 0x00b , 0x00c , 0x00d , 0x00e , 0x00f , 0x010 , 0x111 , 0x112 , 0x113 , 0x114 , 0x115 , 0x116 , 0x117 , 0x118 , 0x119 , 0x11a , 0x11b , 0x11c , 0x11d , 0x11e , 0x11f , 0x120 , 0x121 , 0x222 , 0x223 , 0x224 , 0x225 , 0x226 , 0x227 , 0x228 , 0x229 , 0x22a , 0x22b , 0x22c , 0x22d , 0x22e , 0x22f , 0x230 , 0x231 , 0x232 , 0x333 , 0x334 , 0x335 , 0x336 , 0x337 , 0x338 , 0x339 , 0x33a , 0x33b , 0x33c , 0x33d , 0x33e , 0x33f , 0x340 , 0x341 , 0x342 , 0x343 , 0x444 , 0x445 , 0x446 , 0x447 , 0x448 , 0x449 , 0x44a , 0x44b , 0x44c , 0x44d , 0x44e , 0x44f , 0x450 , 0x451 , 0x452 , 0x453 , 0x454 , 0x555 , 0x556 , 0x557 , 0x558 , 0x559 , 0x55a , 0x55b , 0x55c , 0x55d , 0x55e , 0x55f , 0x560 , 0x561 , 0x562 , 0x563 , 0x564 , 0x565 , 0x666 , 0x667 , 0x668 , 0x669 , 0x66a , 0x66b , 0x66c , 0x66d , 0x66e , 0x66f , 0x670 , 0x671 , 0x672 , 0x673 , 0x674 , 0x675 , 0x676 , 0x777 , 0x778 , 0x779 , 0x77a , 0x77b , 0x77c , 0x77d , 0x77e , 0x77f , 0x780 , 0x781 , 0x782 , 0x783 , 0x784 , 0x785 , 0x786 , 0x787 , 0x888 , 0x889 , 0x88a , 0x88b , 0x88c , 0x88d , 0x88e , 0x88f , 0x890 , 0x891 , 0x892 , 0x893 , 0x894 , 0x895 , 0x896 , 0x897 , 0x898 , 0x999 , 0x99a , 0x99b , 0x99c , 0x99d , 0x99e , 0x99f , 0x9a0 , 0x9a1 , 0x9a2 , 0x9a3 , 0x9a4 , 0x9a5 , 0x9a6 , 0x9a7 , 0x9a8 , 0x9a9 , 0xaaa , 0xaab , 0xaac , 0xaad , 0xaae , 0xaaf , 0xab0 , 0xab1 , 0xab2 , 0xab3 , 0xab4 , 0xab5 , 0xab6 , 0xab7 , 0xab8 , 0xab9 , 0xaba , 0xbbb , 0xbbc , 0xbbd , 0xbbe , 0xbbf , 0xbc0 , 0xbc1 , 0xbc2 , 0xbc3 , 0xbc4 , 0xbc5 , 0xbc6 , 0xbc7 , 0xbc8 , 0xbc9 , 0xbca , 0xbcb , 0xccc , 0xccd , 0xcce , 0xccf , 0xcd0 , 0xcd1 , 0xcd2 , 0xcd3 , 0xcd4 , 0xcd5 , 0xcd6 , 0xcd7 , 0xcd8 , 0xcd9 , 0xcda , 0xcdb , 0xcdc , 0xddd , 0xdde , 0xddf , 0xde0 , 0xde1 , 0xde2 , 0xde3 , 0xde4 , 0xde5 , 0xde6 , 0xde7 , 0xde8 , 0xde9 , 0xdea , 0xdeb , 0xdec , 0xded , 0xeee , 0xeef , 0xef0 , 0xef1 , 0xef2 , 0xef3 , 0xef4 , 0xef5 , 0xef6 , 0xef7 , 0xef8 , 0xef9 , 0xefa , 0xefb , 0xefc , 0xefd , 0xefe , 0xfff , 0xefe , 0xefd , 0xefc , 0xefb , 0xefa , 0xef9 , 0xef8 , 0xef7 , 0xef6 , 0xef5 , 0xef4 , 0xef3 , 0xef2 , 0xef1 , 0xef0 , 0xeef , 0xeee , 0xded , 0xdec , 0xdeb , 0xdea , 0xde9 , 0xde8 , 0xde7 , 0xde6 , 0xde5 , 0xde4 , 0xde3 , 0xde2 , 0xde1 , 0xde0 , 0xddf , 0xdde , 0xddd , 0xcdc , 0xcdb , 0xcda , 0xcd9 , 0xcd8 , 0xcd7 , 0xcd6 , 0xcd5 , 0xcd4 , 0xcd3 , 0xcd2 , 0xcd1 , 0xcd0 , 0xccf , 0xcce , 0xccd , 0xccc , 0xbcb , 0xbca , 0xbc9 , 0xbc8 , 0xbc7 , 0xbc6 , 0xbc5 , 0xbc4 , 0xbc3 , 0xbc2 , 0xbc1 , 0xbc0 , 0xbbf , 0xbbe , 0xbbd , 0xbbc , 0xbbb , 0xaba , 0xab9 , 0xab8 , 0xab7 , 0xab6 , 0xab5 , 0xab4 , 0xab3 , 0xab2 , 0xab1 , 0xab0 , 0xaaf , 0xaae , 0xaad , 0xaac , 0xaab , 0xaaa , 0x9a9 , 0x9a8 , 0x9a7 , 0x9a6 , 0x9a5 , 0x9a4 , 0x9a3 , 0x9a2 , 0x9a1 , 0x9a0 , 0x99f , 0x99e , 0x99d , 0x99c , 0x99b , 0x99a , 0x999 , 0x898 , 0x897 , 0x896 , 0x895 , 0x894 , 0x893 , 0x892 , 0x891 , 0x890 , 0x88f , 0x88e , 0x88d , 0x88c , 0x88b , 0x88a , 0x889 , 0x888 , 0x787 , 0x786 , 0x785 , 0x784 , 0x783 , 0x782 , 0x781 , 0x780 , 0x77f , 0x77e , 0x77d , 0x77c , 0x77b , 0x77a , 0x779 , 0x778 , 0x777 , 0x676 , 0x675 , 0x674 , 0x673 , 0x672 , 0x671 , 0x670 , 0x66f , 0x66e , 0x66d , 0x66c , 0x66b , 0x66a , 0x669 , 0x668 , 0x667 , 0x666 , 0x565 , 0x564 , 0x563 , 0x562 , 0x561 , 0x560 , 0x55f , 0x55e , 0x55d , 0x55c , 0x55b , 0x55a , 0x559 , 0x558 , 0x557 , 0x556 , 0x555 , 0x454 , 0x453 , 0x452 , 0x451 , 0x450 , 0x44f , 0x44e , 0x44d , 0x44c , 0x44b , 0x44a , 0x449 , 0x448 , 0x447 , 0x446 , 0x445 , 0x444 , 0x343 , 0x342 , 0x341 , 0x340 , 0x33f , 0x33e , 0x33d , 0x33c , 0x33b , 0x33a , 0x339 , 0x338 , 0x337 , 0x336 , 0x335 , 0x334 , 0x333 , 0x232 , 0x231 , 0x230 , 0x22f , 0x22e , 0x22d , 0x22c , 0x22b , 0x22a , 0x229 , 0x228 , 0x227 , 0x226 , 0x225 , 0x224 , 0x223 , 0x222 , 0x121 , 0x120 , 0x11f , 0x11e , 0x11d , 0x11c , 0x11b , 0x11a , 0x119 , 0x118 , 0x117 , 0x116 , 0x115 , 0x114 , 0x113 , 0x112 , 0x111 , 0x010 , 0x00f , 0x00e , 0x00d , 0x00c , 0x00b , 0x00a , 0x009 , 0x008 , 0x007 , 0x006 , 0x005 , 0x004 , 0x003 , 0x002 , 0x001 , 0x000 , 0x001 , 0x002 , 0x003 , 0x004 , 0x005 , 0x006 , 0x007 , 0x008 , 0x009 , 0x00a , 0x00b , 0x00c , 0x00d , 0x00e , 0x00f , 0x010 , 0x111 , 0x112 , 0x113 , 0x114 , 0x115 , 0x116 , 0x117 , 0x118 , 0x119 , 0x11a , 0x11b , 0x11c , 0x11d , 0x11e , 0x11f , 0x120 , 0x121 , 0x222 , 0x223 , 0x224 , 0x225 , 0x226 , 0x227 , 0x228 , 0x229 , 0x22a , 0x22b , 0x22c , 0x22d , 0x22e , 0x22f , 0x230 , 0x231 , 0x232 , 0x333 , 0x334 , 0x335 , 0x336 , 0x337 , 0x338 , 0x339 , 0x33a , 0x33b , 0x33c , 0x33d , 0x33e , 0x33f , 0x340 , 0x341 , 0x342 , 0x343 , 0x444 , 0x445 , 0x446 , 0x447 , 0x448 , 0x449 , 0x44a , 0x44b , 0x44c , 0x44d , 0x44e , 0x44f , 0x450 , 0x451 , 0x452 , 0x453 , 0x454 , 0x555 , 0x556 , 0x557 , 0x558 , 0x559 , 0x55a , 0x55b , 0x55c , 0x55d , 0x55e , 0x55f , 0x560 , 0x561 , 0x562 , 0x563 , 0x564 , 0x565 , 0x666 , 0x667 , 0x668 , 0x669 , 0x66a , 0x66b , 0x66c , 0x66d , 0x66e , 0x66f , 0x670 , 0x671 , 0x672 , 0x673 , 0x674 , 0x675 , 0x676 , 0x777 , 0x778 , 0x779 , 0x77a , 0x77b , 0x77c , 0x77d , 0x77e , 0x77f , 0x780 , 0x781 , 0x782 , 0x783 , 0x784 , 0x785 , 0x786 , 0x787 , 0x888 , 0x889 , 0x88a , 0x88b , 0x88c , 0x88d , 0x88e , 0x88f , 0x890 , 0x891 , 0x892 , 0x893 , 0x894 , 0x895 , 0x896 , 0x897 , 0x898 , 0x999 , 0x99a , 0x99b , 0x99c , 0x99d , 0x99e , 0x99f , 0x9a0 , 0x9a1 , 0x9a2 , 0x9a3 , 0x9a4 , 0x9a5 , 0x9a6 , 0x9a7 , 0x9a8 , 0x9a9 , 0xaaa , 0xaab , 0xaac , 0xaad , 0xaae , 0xaaf , 0xab0 , 0xab1 , 0xab2 , 0xab3 , 0xab4 , 0xab5 , 0xab6 , 0xab7 , 0xab8 , 0xab9 , 0xaba , 0xbbb , 0xbbc , 0xbbd , 0xbbe , 0xbbf , 0xbc0 , 0xbc1 , 0xbc2 , 0xbc3 , 0xbc4 , 0xbc5 , 0xbc6 , 0xbc7 , 0xbc8 , 0xbc9 , 0xbca , 0xbcb , 0xccc , 0xccd , 0xcce , 0xccf , 0xcd0 , 0xcd1 , 0xcd2 , 0xcd3 , 0xcd4 , 0xcd5 , 0xcd6 , 0xcd7 , 0xcd8 , 0xcd9 , 0xcda , 0xcdb , 0xcdc , 0xddd , 0xdde , 0xddf , 0xde0 , 0xde1 , 0xde2 , 0xde3 , 0xde4 , 0xde5 , 0xde6 , 0xde7 , 0xde8 , 0xde9 , 0xdea , 0xdeb , 0xdec , 0xded , 0xeee , 0xeef , 0xef0 , 0xef1 , 0xef2 , 0xef3 , 0xef4 , 0xef5 , 0xef6 , 0xef7 , 0xef8 , 0xef9 , 0xefa , 0xefb , 0xefc , 0xefd , 0xefe , 0xfff };
static const char sinTable[] = {
  32,34,35,37,38,40,41,43,44,46,47,48,50,51,52,53,
  55,56,57,58,59,59,60,61,62,62,63,63,63,64,64,64,
  64,64,64,64,63,63,63,62,62,61,60,59,59,58,57,56,
  55,53,52,51,50,48,47,46,44,43,41,40,38,37,35,34,
  32,30,29,27,26,24,23,21,20,18,17,16,14,13,12,11,
  9,8,7,6,5,5,4,3,2,2,1,1,1,0,0,0,
  0,0,0,0,1,1,1,2,2,3,4,5,5,6,7,8,
  9,11,12,13,14,16,17,18,20,21,23,24,26,27,29,30
};

static BOOL collide_point(short x, short y, Vec2short vec[], BYTE vector_max) {
  BYTE i = 0, j = 0;
  for (i = 0; i < vector_max; i++) {
    j = i + 1;
    if (j == vector_max) { j = 0; }
    if (vector_is_left( // foreach edge vector check if dot is  left
        x,
        y,
        vec[i].x, vec[i].y,
        vec[j].x, vec[j].y
      )
    ) { return false; } // if dot is left of the current vector, we return now (collide is impossible)
  }
  return true;
}

static int x = LOGGER_X_INIT;
static int y = LOGGER_Y_INIT;

static int x_default = LOGGER_X_INIT;
static int y_default = LOGGER_Y_INIT;

void inline static setX(WORD _x);
void inline static setY(WORD _y);
void inline static setPosDefault();
WORD inline static countChar(char *txt);
void inline static autoInc(); // todo (minor) - logger_auto ... ?

void inline static setX(WORD _x){
  x = _x;
}

void inline static setY(WORD _y){
  y = _y;
}

void inline static setPosDefault(){
  x = LOGGER_X_INIT;
  y = LOGGER_Y_INIT;
}

static void sprite_index_manager_init() {
  WORD i = 0;
  sprite_index_manager_status[0] = true;
  for (i = 1; i < SPRITE_INDEX_MANAGER_MAX; i++) sprite_index_manager_status[i] = false;
}

static void sprite_index_manager_set(WORD index, WORD max) {
  WORD i = index;
  for (i = index; i < index + max; i++) sprite_index_manager_status[i] = true;
}

static void sprite_index_manager_set_free(WORD index, WORD max) {
  WORD i = index;
  for (i = index; i < index + max; i++) sprite_index_manager_status[i] = false;
}

static WORD sprite_index_manager_use(WORD max) {
  WORD i, j = 0;
  WORD found = 0;
  for( i = 0; i < SPRITE_INDEX_MANAGER_MAX; i++) {
    if (!sprite_index_manager_status[i]) {
      for (j = i; j < i + max; j++) {
        if (!sprite_index_manager_status[j]) {
          found++;
          if (found >= max) {
            sprite_index_manager_set(i, max);
            return i;
          }
        } else {
          found = 0;
        }
      }
    }
  }
  return 0; // TODO : no zero return
}

static void palette_index_manager_init() {
  WORD i = 0;
  for (i = 0; i <= 16; i++) palette_index_manager_status[i] = (paletteInfo*) 1;
}

static void palette_index_manager_set(paletteInfo *pi, WORD index) {
  WORD i = index;
  for (i = index; i < index + pi->palCount; i++) palette_index_manager_status[i] = pi;
}

static void palette_index_manager_set_free(paletteInfo *pi) {
  WORD i = 0;
  for (i = 0; i <PALETTE_INDEX_MANAGER_MAX; i++) {
    if (palette_index_manager_status[i] == pi) {
      palette_index_manager_status[i] = (paletteInfo*) NULL;
    }
  }
}

static WORD palette_index_manager_use(paletteInfo *pi) {
  WORD i, j = 0;
  WORD found = 0;
  for (i = 0; i < PALETTE_INDEX_MANAGER_MAX; i++) {
    if (palette_index_manager_status[i] == pi) {
      return i;
    } else {
      if (!palette_index_manager_status[i]) {
        for (j = i; j < i + pi->palCount; j++) {
          if (!palette_index_manager_status[j]) {
            found++;
            if (found >= pi->palCount) {
              palette_index_manager_set(pi, i);
              return i;
            }
          }
        }
      } else {
        found = 0;
      }
    }
  }
  return 0; // TODO : no zero return
}

WORD inline static countChar(char *txt){
  WORD i = 0;
    while (txt[i] != '\0') {
    i++;
  }
  return i;
}

void inline static autoInc(){
  y++;
}

JOYPAD

  //--------------------------------------------------------------------------//
 //                                  -B                                      //
//--------------------------------------------------------------------------//
BYTE boxes_collide(Box *b, Box *boxes[], BYTE box_max) {
  BYTE rt = false;
  BYTE i = 0;
  for (i = 0; i < box_max; i++) {
  if(
      b->p1.x >= boxes[i]->p0.x
          &&
      b->p0.x <= boxes[i]->p1.x
          &&
      b->p3.y >= boxes[i]->p0.y
          &&
      b->p0.y <= boxes[i]->p3.y
    ) { rt = i + 1; }
  }
  return rt;
}

BOOL box_collide(Box *b1, Box *b2) { // todo - return a frixion vector
  if(
      b1->p1.x >= b2->p0.x
          &&
      b1->p0.x <= b2->p1.x
          &&
      b1->p3.y >= b2->p0.y
          &&
      b1->p0.y <= b2->p3.y
    ) {
      return true;
    } else { return false; }
}

void box_init(Box *b, short width, short height, short widthOffset, short heightOffset) {
  b->width = width;
  b->height = height;
  b->widthOffset = widthOffset;
  b->heightOffset = heightOffset;
}

void box_update(Box *b, short x, short y) {
  b->p0.x = x + b->widthOffset;
  b->p0.y = y + b->heightOffset;

  b->p1.x = b->p0.x + b->width;
  b->p1.y = b->p0.y;

  b->p2.x = b->p1.x;
  b->p2.y = b->p1.y + b->height;

  b->p3.x = b->p0.x;
  b->p3.y = b->p2.y;

  b->p4.x = b->p0.x + ((b->p1.x - b->p0.x) DIV2);
  b->p4.y = b->p0.y + ((b->p3.y - b->p0.y) DIV2);
}

void box_shrunk(Box *b, Box *bOrigin, WORD shrunkValue) {
  // todo (minor) - optim.
  // if i can read the shrunk VRAM value, i can compute the origin box...
  // todo (minor) - improve precision
  // todo (minor) - consider box offsets
  BYTE shrunk_x = SHRUNK_EXTRACT_X(shrunkValue);
  BYTE pix_step_x = (bOrigin->width DIV16);
  BYTE trim_x = (((15 - shrunk_x) * pix_step_x) DIV2);

  int trim_y;
  FIXED shrunk_y = FIX(SHRUNK_EXTRACT_Y(shrunkValue));
  FIXED pix_step_y = FIX((float)bOrigin->height / (float)256); // todo (minor) - hmmm !!! float
  FIXED shrunk_y_multiplicator = fsub(FIX(255), shrunk_y);
  shrunk_y_multiplicator = fmul(shrunk_y_multiplicator, pix_step_y);
  trim_y = fixtoi(shrunk_y_multiplicator);
  trim_y =  (trim_y DIV2);
  trim_y += 1;

  b->p0.x = bOrigin->p0.x + trim_x - (bOrigin->width DIV2);
  b->p0.y = bOrigin->p0.y + trim_y - (bOrigin->height DIV2);

  b->p1.x = bOrigin->p1.x - trim_x - (bOrigin->width DIV2);
  b->p1.y = bOrigin->p1.y + trim_y - (bOrigin->height DIV2);

  b->p2.x = bOrigin->p2.x - trim_x - (bOrigin->width DIV2);
  b->p2.y = bOrigin->p2.y - trim_y - (bOrigin->height DIV2);

  b->p3.x = bOrigin->p3.x + trim_x - (bOrigin->width DIV2);
  b->p3.y = bOrigin->p3.y - trim_y - (bOrigin->height DIV2);

  b->p4.x = b->p0.x + ((b->p1.x - b->p0.x) DIV2);
  b->p4.y = b->p0.y + ((b->p3.y - b->p0.y) DIV2);
}

// todo (minor) - deprecated ?
void box_resize(Box *box, short edge) {
  box->p0.x -= edge;
  box->p0.y -= edge;

  box->p1.x += edge;
  box->p1.y -= edge;

  box->p2.x += edge;
  box->p2.y += edge;

  box->p3.x -= edge;
  box->p3.y += edge;
}

  //--------------------------------------------------------------------------//
 //                                  -C                                      //
//--------------------------------------------------------------------------//
void cdda_play(BYTE track) {
  disableIRQ();
  switch (track) {
  case 2:
    CDDA_PLAY_TRACK_02
    enableIRQ();
    break;

  case 3:
    CDDA_PLAY_TRACK_03
    enableIRQ();
    break;

  case 4:
    CDDA_PLAY_TRACK_04
    enableIRQ();
    break;

  case 5:
    CDDA_PLAY_TRACK_05
    enableIRQ();
    break;

  default:
    enableIRQ();
    break;
  }
}

void inline clear_vram() {
  WORD addr = 0x0000;
  WORD addr_end = 0x8FFF;
  disableIRQ();
  for (addr = addr; addr <= addr_end; addr++) {
    SC234Put(addr, 0);
  }
  enableIRQ();
  SCClose();
  wait_vbl_max(10);
  SCClose();
  wait_vbl_max(10);
}

void clear_sprite_index_table() { sprite_index_manager_init(); }
void clear_palette_index_table() { palette_index_manager_init(); }

  //--------------------------------------------------------------------------//
 //                                  -F                                      //
//--------------------------------------------------------------------------//
void inline fix_print_neocore(int x, int y, char *label){
  fixPrint(x, y, 0, 0, label);
}

WORD free_ram_info() {
  // $000000  $0FFFFF    Vector Table, 68k program (.PRG files), 68k RAM
  // $100000  $00F2FF    WORKRAM_USER  User RAM/Work RAM
  int addr_end = 0x0FFFF, addr_used = 0x0FFFF;
  int used = null;
  for (addr_used = addr_used; addr_used > 0; addr_used--) {
    if (volMEMBYTE(addr_used)) used++;
  }
  return addr_end - used;
}

  //--------------------------------------------------------------------------//
 //                                  -G                                      //
//--------------------------------------------------------------------------//

  /*----------------------*/
 /*  -gfx_picture_physic   */
/*----------------------*/
void gfx_picture_physic_init(
  GFX_Picture_Physic *gfx_picture_physic,
  pictureInfo *pi,
  paletteInfo *pali,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset,
  BOOL autobox_enabled
) {
  gfx_picture_init(&gfx_picture_physic->gfx_picture, pi, pali);
  gfx_picture_physic->autobox_enabled = autobox_enabled;
  if (gfx_picture_physic->autobox_enabled) {
    box_init(&gfx_picture_physic->box, box_witdh, box_height, box_width_offset, box_height_offset);
  }
}

void gfx_picture_physic_display(GFX_Picture_Physic *gfx_picture_physic, short x, short y) {
  gfx_picture_display(&gfx_picture_physic->gfx_picture, x, y);
  if (gfx_picture_physic->autobox_enabled) {
    box_update(&gfx_picture_physic->box, x, y);
  }
}

void gfx_picture_physic_move(GFX_Picture_Physic *gfx_picture_physic, short x_offset, short y_offset) {
  // move_gp(&gfx_picture_physic->gfx_picture, x_offset, y_offset); // TODO : call DAT function
  pictureMove(&gfx_picture_physic->gfx_picture.pic, x_offset, y_offset);
  if (gfx_picture_physic->autobox_enabled) {
    box_update(&gfx_picture_physic->box, gfx_picture_physic->gfx_picture.pic.posX, gfx_picture_physic->gfx_picture.pic.posY);
  }
}

void gfx_picture_physic_set_position(GFX_Picture_Physic *gfx_picture_physic, short x, short y) {
  pictureSetPos(&gfx_picture_physic->gfx_picture.pic, x, y);
  if (gfx_picture_physic->autobox_enabled) {
    box_update(&gfx_picture_physic->box, x, y);
  }
}

void gfx_picture_physic_shrunk(GFX_Picture_Physic *gfx_picture_physic, WORD shrunk_value) {
  shrunk(gfx_picture_physic->gfx_picture.pic.baseSprite, gfx_picture_physic->gfx_picture.pic.info->tileWidth, shrunk_value);
  // todo (minor) - shrunk box
}

void gfx_picture_shrunk_centroid(GFX_Picture *gfx_picture, short center_x, short center_y, WORD shrunk_value) {
  shrunk(gfx_picture->pic.baseSprite, gfx_picture->pic.info->tileWidth, shrunk_value);
  pictureSetPos(
    &gfx_picture->pic,
    shrunk_centroid_get_translated_x(center_x, gfx_picture->pi->tileWidth, SHRUNK_EXTRACT_X(shrunk_value)),
    shrunk_centroid_get_translated_y(center_y, gfx_picture->pi->tileHeight, SHRUNK_EXTRACT_Y(shrunk_value))
  );
}

  /*----------------------*/
 /*      -gfx_picture    */
/*----------------------*/
void gfx_picture_init(GFX_Picture *gfx_picture, pictureInfo *pi, paletteInfo *pali) {
  gfx_picture->pali = pali;
  gfx_picture->pi = pi;
}

void gfx_picture_display(GFX_Picture *gfx_picture, short x, short y) {
  WORD palette_index = palette_index_manager_use(gfx_picture->pali);
  pictureInit(
    &gfx_picture->pic,
    gfx_picture->pi,
    sprite_index_manager_use(gfx_picture->pi->tileWidth),
    palette_index,
    x,
    y,
    FLIP_NONE
  );
  palJobPut(
    palette_index,
    gfx_picture->pali->palCount,
    gfx_picture->pali->data
  );
}

void gfx_picture_show(GFX_Picture *gfx_picture) {
  pictureShow(&gfx_picture->pic); // TODO : macro
}

void gfx_picture_destroy(GFX_Picture *gfx_picture) {
  pictureHide(&gfx_picture->pic);
  sprite_index_manager_set_free(gfx_picture->pic.baseSprite, gfx_picture->pi->tileWidth);
  clearSprites(gfx_picture->pic.baseSprite, gfx_picture->pi->tileWidth);
}

  /*----------------------*/
 /* -gfx_animated_sprite */
/*----------------------*/
void gfx_animated_sprite_init(GFX_Animated_Sprite *animated_sprite ,spriteInfo *si, paletteInfo *pali) {
  animated_sprite->si = si;
  animated_sprite->pali = pali;
};

void gfx_animated_sprite_display(GFX_Animated_Sprite *animated_sprite, short x, short y, WORD anim) {
  WORD palette_index = palette_index_manager_use(animated_sprite->pali);
  aSpriteInit(
    &animated_sprite->as,
    animated_sprite->si,
    sprite_index_manager_use(animated_sprite->si->maxWidth),
    palette_index,
    x,
    y,
    anim,
    FLIP_NONE
  );
  palJobPut(
    palette_index,
    animated_sprite->pali->palCount,
    animated_sprite->pali->data
  );
  aSpriteSetAnim(&animated_sprite->as, anim);
}

void gfx_animated_sprite_hide(GFX_Animated_Sprite *animated_sprite) {
  aSpriteHide(&animated_sprite->as);
  clearSprites(animated_sprite->as.baseSprite, animated_sprite->as.tileWidth);
}

void gfx_animated_sprite_show(GFX_Animated_Sprite *animated_sprite) {
  aSpriteShow(&animated_sprite->as); // TODO : macro
}

void gfx_animated_sprite_destroy(GFX_Animated_Sprite *animated_sprite) {
  gfx_animated_sprite_hide(animated_sprite);
  sprite_index_manager_set_free(animated_sprite->as.baseSprite, animated_sprite->si->maxWidth);
  clearSprites(animated_sprite->as.baseSprite, animated_sprite->as.tileWidth);
}

  /*------------------------------*/
 /* -gfx_animated_sprite_physic  */
/*------------------------------*/
void gfx_animated_sprite_physic_init(
    GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
    spriteInfo *si,
    paletteInfo *pali,
    short box_witdh,
    short box_height,
    short box_width_offset,
    short box_height_offset
  ) {
  box_init(
    &gfx_animated_sprite_physic->box,
    box_witdh,
    box_height,
    box_width_offset,
    box_height_offset
  );
  gfx_animated_sprite_physic->physic_enabled = true;
  gfx_animated_sprite_init(
    &gfx_animated_sprite_physic->gfx_animated_sprite,
    si,
    pali
  );
}

void gfx_animated_sprite_physic_display(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, short x, short y, WORD anim) {
  gfx_animated_sprite_display(
    &gfx_animated_sprite_physic->gfx_animated_sprite,
    x,
    y,
    anim
  );
  box_update(&gfx_animated_sprite_physic->box, x, y);
}

void gfx_animated_sprite_physic_set_position(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, short x, short y) {
  gfx_animated_sprite_set_position(&gfx_animated_sprite_physic->gfx_animated_sprite, x, y);
  box_update(&gfx_animated_sprite_physic->box, x, y);
}

void gfx_animated_sprite_physic_move(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, short x_offset, short y_offset) {
  gfx_animated_sprite_move(&gfx_animated_sprite_physic->gfx_animated_sprite, x_offset, y_offset);
  box_update(&gfx_animated_sprite_physic->box, gfx_animated_sprite_physic->gfx_animated_sprite.as.posX, gfx_animated_sprite_physic->gfx_animated_sprite.as.posY);
}

void gfx_animated_sprite_physic_shrunk(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, WORD shrunk_value) {
  shrunk(gfx_animated_sprite_physic->gfx_animated_sprite.as.baseSprite, gfx_animated_sprite_physic->gfx_animated_sprite.si->maxWidth, shrunk_value);
  // todo (minor) - box resize
}

void gfx_animated_sprite_physic_hide(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic) {
  gfx_animated_sprite_hide(&gfx_animated_sprite_physic->gfx_animated_sprite);
  gfx_animated_sprite_physic->physic_enabled = false;
}

void gfx_animated_sprite_physic_show(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic) {
  gfx_animated_sprite_show(&gfx_animated_sprite_physic->gfx_animated_sprite);
  gfx_animated_sprite_physic->physic_enabled = true;
}

void gfx_animated_sprite_physic_destroy(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic) {
  gfx_animated_sprite_physic_hide(gfx_animated_sprite_physic);
  gfx_animated_sprite_destroy(&gfx_animated_sprite_physic->gfx_animated_sprite);
}

void inline gpu_init() {
  backgroundColor(0x7000); // todo (minor) - macro with some colors ...
  clearFixLayer();
  initGfx();
  volMEMWORD(0x400002) = 0xffff;  // debug text white
  LSPCmode = 0x1c00;              // autoanim speed
  sprite_index_manager_init();
  palette_index_manager_init();
}

WORD get_shrunk_proportional_table(WORD index) {
  return shrunk_table_prop[index]; // todo (minor) - rename shrunk_proportional_table
}

char get_sin(WORD index) {
  return sinTable[index];
}

WORD get_max_free_sprite_index() {
  WORD i, max = 0;
  for (i = 0; i < SPRITE_INDEX_MANAGER_MAX; i++) {
    if (sprite_index_manager_status[i] != true) max++;
  }
  return max;
}

WORD get_max_sprite_index_used() {
  WORD i, max = 0;
  for (i = 0; i < SPRITE_INDEX_MANAGER_MAX; i++) {
    if (sprite_index_manager_status[i] != false) max++;
  }
  return max;
}

WORD get_max_free_palette_index() {
  WORD i, max = 0;
  for (i = 0; i < PALETTE_INDEX_MANAGER_MAX; i++) {
    if (palette_index_manager_status[i] == (paletteInfo*) NULL) max++;
  }
  return max;
}

WORD get_max_palette_index_used() {
  WORD i, max = 0;
  for (i = 0; i < PALETTE_INDEX_MANAGER_MAX; i++) {
    if (palette_index_manager_status[i] != (paletteInfo*) NULL) max++;
  }
  return max;
}


  //--------------------------------------------------------------------------//
 //                                  -I                                      //
//--------------------------------------------------------------------------//

  //--------------------------------------------------------------------------//
 //                                  -J                                      //
//--------------------------------------------------------------------------//
  /*----------*/
 /* -joypad  */
/*----------*/
void inline joypad_debug() {
  JOYPAD_READ
  if (joypad_is_start()) {  fix_print_neocore(10, 11,  "JOYPAD START"); }
  if (joypad_is_up())     {  fix_print_neocore(10, 11,  "JOYPAD UP   "); }
  if (joypad_is_down())   {  fix_print_neocore(10, 11,  "JOYPAD DOWN "); }
  if (joypad_is_left())   {  fix_print_neocore(10, 11,  "JOYPAD LEFT "); }
  if (joypad_is_right()) {  fix_print_neocore(10, 11,  "JOYPAD RIGHT"); }
  if (joypad_is_a())     {  fix_print_neocore(10, 11,  "JOYPAD A    "); }
  if (joypad_is_b())     {  fix_print_neocore(10, 11,  "JOYPAD B    "); }
  if (joypad_is_c())     {  fix_print_neocore(10, 11,  "JOYPAD C    "); }
  if (joypad_is_d())     {  fix_print_neocore(10, 11,  "JOYPAD D    "); }
}

void joypad_update() {
  JOYPAD_READ
}

void joypad_update_edge() {
  JOYPAD_READ_EDGE
}

BOOL joypad_is_up()     { return (JOYPAD_IS_UP)     ? (true) : (false); }
BOOL joypad_is_down()   { return (JOYPAD_IS_DOWN)   ? (true) : (false); }
BOOL joypad_is_left()   { return (JOYPAD_IS_LEFT)   ? (true) : (false); }
BOOL joypad_is_right()  { return (JOYPAD_IS_RIGHT)  ? (true) : (false); }
BOOL joypad_is_start()  { return (JOYPAD_IS_START)  ? (true) : (false); }
BOOL joypad_is_a()      { return (JOYPAD_IS_A)      ? (true) : (false); }
BOOL joypad_is_b()      { return (JOYPAD_IS_B)      ? (true) : (false); }
BOOL joypad_is_c()      { return (JOYPAD_IS_C)      ? (true) : (false); }
BOOL joypad_is_d()      { return (JOYPAD_IS_D)      ? (true) : (false); }

  //--------------------------------------------------------------------------//
 //                                  -L                                       //
//--------------------------------------------------------------------------//
  /*----------*/
 /* -logger  */
/*----------*/
void logger_init() {
  #ifdef LOGGER_ON
  x = LOGGER_X_INIT;
  y = LOGGER_Y_INIT;
  x_default = LOGGER_X_INIT;
  y_default = LOGGER_Y_INIT;
  clearFixLayer();
  #endif
}

void logger_set_position(WORD _x, WORD _y){
  x = _x;
  y = _y;
  x_default = x;
  y_default = y;
}

WORD inline logger_info(char *label){
  #ifdef LOGGER_ON
  fixPrintf(x, y , 0, 0 , label);
  autoInc();
  return countChar(label);
  #endif
}

void inline logger_word(char *label, WORD value){
  #ifdef LOGGER_ON
  WORD yc = y;
  x = x_default + logger_info(label) + 2;
  fixPrintf(x , yc, 0, 0, "%04d", value);
  x = x_default;
  #endif
}

void inline logger_int(char *label, int value){
  #ifdef LOGGER_ON
  WORD yc = y;
  x = x_default + logger_info(label) + 2;
  fixPrintf(x , yc, 0, 0, "%08d", value);
  x = x_default;
  #endif
}

void inline logger_dword(char *label, DWORD value){
  #ifdef LOGGER_ON
  WORD yc = y;
  x = x_default + logger_info(label) + 2;
  fixPrintf(x , yc, 0, 0, "%08d", value);
  x = x_default;
  #endif
}

void inline logger_short(char *label, short value) {
  #ifdef LOGGER_ON
  WORD yc = y;
  x = x_default + logger_info(label) + 2;
  fixPrintf(x , yc, 0, 0, "%02d", value);
  x = x_default;
  #endif
}

void inline logger_byte(char *label, BYTE value) {
  #ifdef LOGGER_ON
  WORD yc = y;
  x = x_default + logger_info(label) + 2;
  fixPrintf(x , yc, 0, 0, "%02d", value);
  x = x_default;
  #endif
}

void inline logger_bool(char *label, BOOL value) {
  #ifdef LOGGER_ON
  WORD yc = y;
  x = x_default + logger_info(label) + 2;
  fixPrintf(x , yc, 0, 0, "%01d", value);
  x = x_default;
  #endif
}

void inline logger_animated_sprite(char *label, GFX_Animated_Sprite *gfx_animated_sprite) {
  #ifdef LOGGER_ON
  logger_info(label);
  logger_word("BASESPRITE : " , gfx_animated_sprite->as.baseSprite);
  logger_word("BASEPALETTE : ", gfx_animated_sprite->as.basePalette);
  logger_short("POSX : ", gfx_animated_sprite->as.posX);
  logger_short("POSY : ", gfx_animated_sprite->as.posY);
  logger_short("CURRENTSTEPNUM : ", gfx_animated_sprite->as.currentStepNum);
  logger_short("MAXSTEP : ", gfx_animated_sprite->as.maxStep);
  logger_dword("COUNTER : ", gfx_animated_sprite->as.counter);
  logger_word("REPEATS : ", gfx_animated_sprite->as.repeats);
  logger_word("CURRENTFLIP : ", gfx_animated_sprite->as.currentFlip);
  logger_word("TILEWIDTH : ", gfx_animated_sprite->as.tileWidth);
  logger_word("ANIMID : ", gfx_animated_sprite->as.animID);
  logger_word("FLAGS", gfx_animated_sprite->as.flags);
  #endif
}

void inline logger_spriteInfo(char *label, spriteInfo *si) {
  #ifdef LOGGER_ON
  logger_info(label);
  logger_word("PALCOUNT : ", si->palCount);
  logger_word("FRAMECOUNT : ", si->frameCount);
  logger_word("MAXWIDTH : ", si->maxWidth);
  #endif
}

void inline logger_box(char *label, Box *b) {
  #ifdef LOGGER_ON
  logger_info(label);
  logger_short("P0X", (short)b->p0.x);
  logger_short("P0Y", (short)b->p0.y);
  logger_info("");
  logger_short("P1X", (short)b->p1.x);
  logger_short("P1Y", (short)b->p1.y);
  logger_info("");
  logger_short("P2X", (short)b->p2.x);
  logger_short("P2Y", (short)b->p2.y);
  logger_info("");
  logger_short("P3X", (short)b->p3.x);
  logger_short("P3Y", (short)b->p3.y);
  logger_info("");
  logger_short("P4X", (short)b->p4.x);
  logger_short("P4Y", (short)b->p4.y);
  logger_info("");
  logger_short("WIDTH ", b->width);
  logger_short("HEIGHT ", b->height);
  logger_info("");
  logger_short("WIDTH OFFSET ", b->widthOffset);
  logger_short("HEIGHT OFFSET ", b->heightOffset);
  #endif
}

void inline logger_pictureInfo(char *label, pictureInfo *pi) {
  #ifdef LOGGER_ON
  logger_info(label);
  logger_word("COLSIZE : ", (WORD)pi->colSize);
  logger_word("UNUSED HEIGHT : ", (WORD)pi->unused__height);
  logger_word("TILEWIDTH : ", (WORD)pi->tileWidth);
  logger_word("TILEHEIGHT : ", (WORD)pi->tileHeight);
  #endif
}

  //--------------------------------------------------------------------------//
 //                                  -P                                      //
//--------------------------------------------------------------------------//
void palette_destroy(paletteInfo* pi) {
  palette_index_manager_set_free(pi);
  // TODO : put black palette
}

  //--------------------------------------------------------------------------//
 //                                  -V                                      //
//--------------------------------------------------------------------------//
BOOL vector_is_left(short x, short y, short v1x, short v1y, short v2x, short v2y) {
  BOOL rt = false;
  short vectorD[2] = {v2x - v1x, v2y - v1y};
  short vectorT[2] = {x - v1x, y -v1y};
  short d = vectorD[X] * vectorT[Y] - vectorD[Y] * vectorT[X];
  (d > 0) ? (rt = false) : (rt = true);
  return rt;
}

void vec2int_init(Vec2int *vec, int x, int y)         { vec->x = x; vec->y = y; }
void vec2short_init(Vec2short *vec, short x, short y) { vec->x = x; vec->y = y; }
void vec2byte_init(Vec2byte *vec, BYTE x, BYTE y)     { vec->x = x; vec->y = y; }

BOOL vectors_collide(Box *box, Vec2short vec[], BYTE vector_max) {
  BOOL p0 = false, p1 = false, p2 = false, p3 = false, p4 = false;
  p0 = collide_point(box->p0.x, box->p0.y, vec, vector_max);
  p1 = collide_point(box->p1.x, box->p1.y, vec, vector_max);
  p2 = collide_point(box->p2.x, box->p2.y, vec, vector_max);
  p3 = collide_point(box->p3.x, box->p3.y, vec, vector_max);
  p4 = collide_point(box->p4.x, box->p4.y, vec, vector_max);
  return (p0 || p1 || p2 || p3 || p4);
}

  //--------------------------------------------------------------------------//
 //                                  -S                                      //
//--------------------------------------------------------------------------//
  /*-----------*/
 /* -scroller */
/*-----------*/
void display_gs(GFX_Scroller *s, short x, short y) {
  WORD palette_index = palette_index_manager_use(s->pali);
  scrollerInit(
    &s->s,
    s->si,
    sprite_index_manager_use(21),
    palette_index,
    x,
    y
  );
  palJobPut(
    palette_index,
    s->pali->palCount,
    s->pali->data
  );
}

void init_gs(GFX_Scroller *s, scrollerInfo *si, paletteInfo *pali) {
  s->si = si;
  s->pali = pali;
}

void gfx_scroller_destroy(GFX_Scroller *s) {
  sprite_index_manager_set_free(s->s.baseSprite, 21);
  clearSprites(s->s.baseSprite, 21);
}


  /*-----------*/
 /* -shrunk   */
/*-----------*/
void inline shrunk_addr(WORD addr, WORD shrunk_value) {
  SC234Put(addr, shrunk_value);
}

WORD shrunk_forge(BYTE xc, BYTE yc) { // todo (minor) - xcF, ycFF
  //F FF - x (hor) , y (vert)
  // vertical shrinking   8 bits
  // horizontal shrinking 4 bits
  WORD value = 0;
  value = xc << 8;
  value += yc;
  return value;
}

WORD shrunk_range(WORD addr_start, WORD addr_end, WORD shrunk_value) {
  WORD cur_addr = addr_start;
  while (cur_addr < addr_end) {
    SC234Put(cur_addr, shrunk_value);
    cur_addr++;
  }
  return addr_end;
}

void shrunk(WORD base_sprite, WORD max_width, WORD value) {
  shrunk_range(0x8000 + base_sprite, 0x8000 + base_sprite + max_width, value);
}

int shrunk_centroid_get_translated_x(short centerPosX, WORD tileWidth, BYTE shrunkX) {
  FIXED newX = FIX(centerPosX);
  newX -= (shrunkX + 1) * FIX((tileWidth MULT8) / 0x10);
  return fixtoi(newX);
}

int shrunk_centroid_get_translated_y(short centerPosY, WORD tileHeight, BYTE shrunkY) {
  FIXED newY = FIX(centerPosY);
  newY -= shrunkY * FIX((tileHeight MULT8) / 0xFF);
  return fixtoi(newY);
}

  //--------------------------------------------------------------------------//
 //                                  -W                                      //
//--------------------------------------------------------------------------//
DWORD inline wait_vbl_max(WORD nb) {
  WORD i = 0;
  for (i = 0; i <= nb; i++) waitVBlank();
  return DAT_frameCounter;
}

void mask_update(short x, short y, Vec2short vec[], Vec2short offset[], BYTE vector_max) {
  BYTE i = 0;
  for (i = 0; i < vector_max; i++) {
    vec[i].x = x + offset[i].x;
    vec[i].y = y + offset[i].y;
  }
}
