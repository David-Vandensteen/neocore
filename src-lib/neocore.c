/*
	David Vandensteen
	2018
*/

// TODO reorganiser les fonctions par odre alpha

#include <DATlib.h>
#include <input.h>
#include <stdio.h>
#include <neocore.h>
#include <math.h>

// STATIC

static WORD sprite_index = 1;
static BYTE palette_index = 16;

static BOOL palette_autoinc = true;
static BOOL sprite_autoinc = true;

static BOOL collide_point(short x, short y, vec2short vec[], BYTE vector_max);
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

static BOOL collide_point(short x, short y, vec2short vec[], BYTE vector_max) {
  BYTE i = 0, j = 0;
  for (i = 0; i < vector_max; i++) {
    j = i + 1;
    if (j == vector_max) { j = 0; }
    if (isVectorLeft( // foreach edge vector check if dot is  left
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
//void inline static setPos(WORD _x, WORD _y);
void inline static setPosDefault();
WORD inline static countChar(char *txt);
void inline static autoInc();

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

// STATIC END

JOYPAD

//
void animated_sprite_physic_display(aSpritePhysic *asp, spriteInfo *si, paletteInfo *pali, short posX, short posY, WORD anim) {
  animated_sprite_display(&asp->as, si, pali, posX, posY, anim);
  box_update(&asp->box, posX, posY);
}

void animated_sprite_physic_set_position(aSpritePhysic *asp, short x, short y) {
  aSpriteSetPos(&asp->as, x, y);
  box_update(&asp->box, x, y);
}

void animated_sprite_physic_move(aSpritePhysic *asp, short x, short y) {
  aSpriteMove(&asp->as, x, y);
  box_update(&asp->box, asp->as.posX, asp->as.posY);
}

void animated_sprite_physic_shrunk(aSprite *as, spriteInfo *si, WORD shrunk_value) {
	shrunkRange(0x8000 + as->baseSprite, 0x8000 + as->baseSprite + si->maxWidth, shrunk_value);
}

void animated_sprite_display(aSprite *as, spriteInfo *si, paletteInfo *pali, short posX, short posY, WORD anim) {
  aSpriteInit(
    as,
    si,
		animated_sprite_index_auto(si),
    paletteGetIndex(),
    posX,
    posY,
    anim,
    FLIP_NONE
  );

  palJobPut(
    paletteGetIndexAutoinc(pali),
    pali->palCount,
    pali->data
  );
  aSpriteSetAnim(as, anim);
}

WORD animated_sprite_index_auto(spriteInfo *si) {
  WORD rt = sprite_index;
  if (sprite_autoinc) sprite_index += si->maxWidth;
  return rt;
}

void animated_sprite_flash(aSprite *as, BYTE freq) {
  if (freq != 0) {
    if (DAT_frameCounter % freq == 0) {
      if (animated_sprite_is_visible(as)) {
        aSpriteHide(as);
      } else {
        aSpriteShow(as);
      }
    }
  }
}

BOOL animated_sprite_is_visible(aSprite *as) {
  return (as->flags | (0x0080 == 0)) ? false : true;
}

BYTE boxes_collide(box *b, box *boxes[], BYTE box_max) {
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

BOOL box_collide(box *b1, box *b2) { // TODO return a frixion vector
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

void box_init(box *b, short width, short height, short widthOffset, short heightOffset) {
  b->width = width;
  b->height = height;
  b->widthOffset = widthOffset;
  b->heightOffset = heightOffset;
}

box boxMake(short p0x, short p0y, short p1x, short p1y, short p2x, short p2y, short p3x, short p3y) {
  box rt;
  rt.p0.x = p0x;
  rt.p0.y = p0y;
  rt.p1.x = p1x;
  rt.p1.y = p1y;
  rt.p2.x = p2x;
  rt.p2.y = p2y;
  rt.p3.x = p3x;
  rt.p3.y = p3y;
  rt.p4.x = p0x + ((p1x - p0x) DIV2);
  rt.p4.y = p0y + ((p3y - p0y) DIV2);
  return rt;
}

void box_update(box *b, short x, short y) {
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

void boxDebugUpdate(picture5 *pics, box *box) {
  pictureSetPos(&pics->pic0, box->p0.x, box->p0.y);
  pictureSetPos(&pics->pic1, box->p1.x, box->p1.y);
  pictureSetPos(&pics->pic2, box->p2.x, box->p2.y);
  pictureSetPos(&pics->pic3, box->p3.x, box->p3.y);
  pictureSetPos(&pics->pic4, box->p4.x, box->p4.y);
}

void boxDisplay(picture5 *pics, box *box, pictureInfo *pi, paletteInfo *pali) {
  paletteDisableAutoinc();
  pictureDisplay(&pics->pic0, pi, pali, box->p0.x, box->p0.y);
  pictureDisplay(&pics->pic1, pi, pali, box->p1.x, box->p1.y);
  pictureDisplay(&pics->pic2, pi, pali, box->p2.x, box->p2.y);
  pictureDisplay(&pics->pic3, pi, pali, box->p3.x, box->p3.y);
  paletteEnableAutoinc();
  pictureDisplay(&pics->pic4, pi, pali, box->p4.x, box->p4.y);
}

void boxShrunk(box *b, box *bOrigin, WORD shrunkValue) {
  // TODO optim.
  // if i can read the shrunk VRAM value, i can compute the origin box...

  // TODO improve precision

  // TODO consider box offsets

  // TODO move the code to neocore

  BYTE shrunk_x = SHRUNK_EXTRACT_X(shrunkValue);
  BYTE pix_step_x = (bOrigin->width DIV16);
  BYTE trim_x = (((15 - shrunk_x) * pix_step_x) DIV2);

  int trim_y;
  FIXED shrunk_y = FIX(SHRUNK_EXTRACT_Y(shrunkValue));
  FIXED pix_step_y = FIX((float)bOrigin->height / (float)256); // TODO hmmm float
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

// TODO deprecated ?
void boxResize(box *box, short edge) {
  box->p0.x -= edge;
  box->p0.y -= edge;

  box->p1.x += edge;
  box->p1.y -= edge;

  box->p2.x += edge;
  box->p2.y += edge;

  box->p3.x -= edge;
  box->p3.y += edge;
}

void inline clearVram() { // TODO diable interrupt
  WORD addr = 0x0000;
  WORD addr_end = 0x8FFF;
  for (addr = addr; addr <= addr_end; addr++) {
    SC234Put(addr, 0);
  }
  SCClose();
  waitVbl(10);
  SCClose();
  waitVbl(10);
}

void inline fixPrintNeocore(int x, int y, char *label){
  fixPrint(x, y, 0, 0, label);
}

void inline gpu_init() {
  backgroundColor(0x7000); //BG color
  clearFixLayer();
  initGfx();
  volMEMWORD(0x400002) = 0xffff; //debug text white
  LSPCmode = 0x1c00;//autoanim speed
  sprite_index = 1;
  palette_index = 16;
}

BOOL isVectorLeft(short x, short y, short v1x, short v1y, short v2x, short v2y) {
  BOOL rt = false;
  short vectorD[2] = {v2x - v1x, v2y - v1y};
  short vectorT[2] = {x - v1x, y -v1y};
  short d = vectorD[X] * vectorT[Y] - vectorD[Y] * vectorT[X];
  (d > 0) ? (rt = false) : (rt = true);
  return rt;
}

void inline joypadDebug() {
  JOYPAD_READ
  if (joypadIsStart()) {  fixPrintNeocore(10, 11,  "JOYPAD START"); }
  if (joypadIsUp())	   {  fixPrintNeocore(10, 11,  "JOYPAD UP   "); }
  if (joypadIsDown())	 {  fixPrintNeocore(10, 11,  "JOYPAD DOWN "); }
  if (joypadIsLeft())	 {  fixPrintNeocore(10, 11,  "JOYPAD LEFT "); }
  if (joypadIsRight()) {  fixPrintNeocore(10, 11,  "JOYPAD RIGHT"); }
  if (joypadIsA())     {  fixPrintNeocore(10, 11,  "JOYPAD A    "); }
  if (joypadIsB())     {  fixPrintNeocore(10, 11,  "JOYPAD B    "); }
  if (joypadIsC())     {  fixPrintNeocore(10, 11,  "JOYPAD C    "); }
  if (joypadIsD())     {  fixPrintNeocore(10, 11,  "JOYPAD D    "); }
}

void joypadUpdate() {
  JOYPAD_READ
}

void joypadUpdateEdge() {
  JOYPAD_READ_EDGE
}

BOOL joypadIsUp()     { return (JOYPAD_IS_UP)     ? (true) : (false); }
BOOL joypadIsDown()   { return (JOYPAD_IS_DOWN)   ? (true) : (false); }
BOOL joypadIsLeft()   { return (JOYPAD_IS_LEFT)   ? (true) : (false); }
BOOL joypadIsRight()  { return (JOYPAD_IS_RIGHT)  ? (true) : (false); }
BOOL joypadIsStart()  { return (JOYPAD_IS_START)  ? (true) : (false); }
BOOL joypadIsA()      { return (JOYPAD_IS_A)      ? (true) : (false); }
BOOL joypadIsB()      { return (JOYPAD_IS_B)      ? (true) : (false); }
BOOL joypadIsC()      { return (JOYPAD_IS_C)      ? (true) : (false); }
BOOL joypadIsD()      { return (JOYPAD_IS_D)      ? (true) : (false); }

void loggerInit() {
  #ifdef LOGGER_ON
  x = LOGGER_X_INIT;
  y = LOGGER_Y_INIT;
  x_default = LOGGER_X_INIT;
  y_default = LOGGER_Y_INIT;
  clearFixLayer();
  #endif
}

void loggerPositionSet(WORD _x, WORD _y){
  x = _x;
  y = _y;
  x_default = x;
  y_default = y;
}

WORD inline loggerInfo(char *label){
  #ifdef LOGGER_ON
  fixPrintf(x, y , 0, 0 , label);
  autoInc();
  return countChar(label);
  #endif
}

void inline loggerWord(char *label, WORD value){
  #ifdef LOGGER_ON
  WORD yc = y;
  x = x_default + loggerInfo(label) + 2;
  fixPrintf(x , yc, 0, 0, "%04d", value);
  x = x_default;
  #endif
}

void inline loggerInt(char *label, int value){
  #ifdef LOGGER_ON
  WORD yc = y;
  x = x_default + loggerInfo(label) + 2;
  fixPrintf(x , yc, 0, 0, "%08d", value);
  x = x_default;
  #endif
}

void inline loggerDword(char *label, DWORD value){
  #ifdef LOGGER_ON
  WORD yc = y;
  x = x_default + loggerInfo(label) + 2;
  fixPrintf(x , yc, 0, 0, "%08d", value);
  x = x_default;
  #endif
}

void inline loggerShort(char *label, short value) {
  #ifdef LOGGER_ON
  WORD yc = y;
  x = x_default + loggerInfo(label) + 2;
  fixPrintf(x , yc, 0, 0, "%02d", value);
  x = x_default;
  #endif
}

void inline loggerByte(char *label, BYTE value) {
  #ifdef LOGGER_ON
  WORD yc = y;
  x = x_default + loggerInfo(label) + 2;
  fixPrintf(x , yc, 0, 0, "%02d", value);
  x = x_default;
  #endif
}

void inline loggerBool(char *label, BOOL value) {
  #ifdef LOGGER_ON
  WORD yc = y;
  x = x_default + loggerInfo(label) + 2;
  fixPrintf(x , yc, 0, 0, "%01d", value);
  x = x_default;
  #endif
}

void inline loggerAsprite(char *label, aSprite *as) {
  #ifdef LOGGER_ON
  loggerInfo(label);
  loggerWord("BASESPRITE : " , as->baseSprite);
  loggerWord("BASEPALETTE : ", as->basePalette);
  loggerShort("POSX : ", as->posX);
  loggerShort("POSY : ", as->posY);
  loggerShort("CURRENTSTEPNUM : ", as->currentStepNum);
  loggerShort("MAXSTEP : ", as->maxStep);
  loggerDword("COUNTER : ", as->counter);
  loggerWord("REPEATS : ", as->repeats);
  loggerWord("CURRENTFLIP : ", as->currentFlip);
  loggerWord("TILEWIDTH : ", as->tileWidth);
  loggerWord("ANIMID : ", as->animID);
  loggerWord("FLAGS", as->flags);
  #endif
}

void inline loggerSpriteInfo(char *label, spriteInfo *si) {
  #ifdef LOGGER_ON
  loggerInfo(label);
  loggerWord("PALCOUNT : ", si->palCount);
  loggerWord("FRAMECOUNT : ", si->frameCount);
  loggerWord("MAXWIDTH : ", si->maxWidth);
  #endif
}

void inline loggerBox(char *label, box *b) {
  #ifdef LOGGER_ON
  loggerInfo(label);
  loggerShort("P0X", (short)b->p0.x);
  loggerShort("P0Y", (short)b->p0.y);
  loggerInfo("");
  loggerShort("P1X", (short)b->p1.x);
  loggerShort("P1Y", (short)b->p1.y);
  loggerInfo("");
  loggerShort("P2X", (short)b->p2.x);
  loggerShort("P2Y", (short)b->p2.y);
  loggerInfo("");
  loggerShort("P3X", (short)b->p3.x);
  loggerShort("P3Y", (short)b->p3.y);
  loggerInfo("");
  loggerShort("P4X", (short)b->p4.x);
  loggerShort("P4Y", (short)b->p4.y);
  loggerInfo("");
  loggerShort("WIDTH ", b->width);
  loggerShort("HEIGHT ", b->height);
  loggerInfo("");
  loggerShort("WIDTH OFFSET ", b->widthOffset);
  loggerShort("HEIGHT OFFSET ", b->heightOffset);
  #endif
}

void inline loggerPictureInfo(char *label, pictureInfo *pi) {
  #ifdef LOGGER_ON
  loggerInfo(label);
  loggerWord("COLSIZE : ", (WORD)pi->colSize);
  loggerWord("UNUSED HEIGHT : ", (WORD)pi->unused__height);
  loggerWord("TILEWIDTH : ", (WORD)pi->tileWidth);
  loggerWord("TILEHEIGHT : ", (WORD)pi->tileHeight);
  #endif
}

void picturePhysicShrunkCentroidUpdate(picturePhysicShrunkCentroid *pps, WORD shrunk) {
  pictureShrunkCentroid(&pps->pp.p, pps->pi, pps->positionCenter.x, pps->positionCenter.y, shrunk);
  boxShrunk(&pps->pp.box, &pps->boxOrigin, shrunk);
}

void picturePhysicShrunkCentroidDisplay(picturePhysicShrunkCentroid *pps, WORD shrunk) {
  picturePhysicDisplay(&pps->pp, pps->pi, pps->pali, pps->positionCenter.x, pps->positionCenter.y);
  pictureShrunkCentroid(&pps->pp.p, pps->pi, pps->positionCenter.x, pps->positionCenter.y, shrunk);
  BOXCOPY(&pps->pp.box, &pps->boxOrigin);
}

void picturePhysicShrunkCentroidInit(picturePhysicShrunkCentroid *pps, pictureInfo *pi, paletteInfo *pali, short xCenter, short yCenter) {
  pps->pi = pi;
  pps->pali = pali;
  pps->positionCenter.x = xCenter;
  pps->positionCenter.y = yCenter;
}

void picturePhysicShrunkCentroidSetPos(picturePhysicShrunkCentroid *pps, short x, short y) {
  pps->positionCenter.x = x;
  pps->positionCenter.y = y;
  box_update(&pps->boxOrigin, x, y);
}

void picturePhysicShrunkCentroidMove(picturePhysicShrunkCentroid *pps, short xShift, short yShift) {
  picturePhysicShrunkCentroidSetPos(pps, pps->positionCenter.x + xShift, pps->positionCenter.y + yShift);
}

void picturePhysicDisplay(picturePhysic *pp, pictureInfo *pi, paletteInfo *pali, short posX, short posY) {
  pictureDisplay(&pp->p, pi, pali, posX, posY); // TODO refactoring this func
  box_update(&pp->box, posX, posY);
}

void picturePhysicSetPos(picturePhysic *pp, short x, short y) {
  pictureSetPos(&pp->p, x, y);
  box_update(&pp->box, x, y);
}

void picturesShow(picture *p, WORD max, BOOL visible) {
  WORD i = 0;
  for (i = 0; i < max; i++) {
    if (visible) {  // TODO ternaire
      pictureShow(&p[i]);
    } else {
      pictureHide(&p[i]);
    }
  }
}

void pictureDisplay(picture *p, pictureInfo *pi, paletteInfo *pali, short posX, short posY) {
  pictureInit(
    p,
    pi,
    pictureGetSpriteIndexAutoinc(pi),
    paletteGetIndex(),
    posX,
    posY,
    FLIP_NONE
  );

  palJobPut(
    paletteGetIndexAutoinc(pali),
    pali->palCount,
    pali->data
  );
}

void pictureFlash(picture *p, BYTE freq) {
  if (freq != 0) {
    if (DAT_frameCounter % freq == 0) {
      pictureShow(p);
    }
    if (DAT_frameCounter % ((freq MULT2) + (freq DIV2)) == 0) {
      pictureHide(p);
    }
  } else {
    pictureShow(p);
  }
}


void paletteDisableAutoinc() {
  palette_autoinc = false;
}

void paletteEnableAutoinc() {
  palette_autoinc = true;
}

BYTE paletteGetIndex() {
  return palette_index;
}

BYTE paletteSetIndex(BYTE index) {
	palette_index = index;
	return palette_index;
}

WORD pictureGetSpriteIndexAutoinc(pictureInfo *pi) {
  WORD rt = sprite_index;
  if (sprite_autoinc) sprite_index += pi->tileWidth;
  return rt;
}

BYTE paletteGetIndexAutoinc(paletteInfo *pali) {
	BYTE rt = palette_index;
  if (palette_autoinc) palette_index += pali->palCount;
	return rt;
}

void picture5Show(picture5 *pics, BOOL visible) {
  if (visible) {
    pictureShow(&pics->pic0);
    pictureShow(&pics->pic1);
    pictureShow(&pics->pic2);
    pictureShow(&pics->pic3);
    pictureShow(&pics->pic4);
  } else {
    pictureHide(&pics->pic0);
    pictureHide(&pics->pic1);
    pictureHide(&pics->pic2);
    pictureHide(&pics->pic3);
    pictureHide(&pics->pic4);
  }
}

void picturePhysicMove(picturePhysic *pp, short x, short y) {
  pictureMove(&pp->p, x, y);
  box_update(&pp->box, pp->p.posX, pp->p.posY);
}

void pictureShrunk(picture *p, pictureInfo *pi, WORD shrunk_value) {
  shrunkRange(0x8000 + p->baseSprite, 0x8000 + p->baseSprite + pi->tileWidth, shrunk_value);
}

void pictureShrunkCentroid(picture *p, pictureInfo *pi, short centerPosX, short centerPosY, WORD shrunk_value) {
  pictureShrunk(p, pi, shrunk_value);
  pictureSetPos(p,
    shrunkCentroidGetTranslatedX(centerPosX, pi->tileWidth, SHRUNK_EXTRACT_X(shrunk_value)),
    shrunkCentroidGetTranslatedY(centerPosY, pi->tileHeight, SHRUNK_EXTRACT_Y(shrunk_value))
  );
}


/* TODO
void maskDisplay(picture pic[], vec2short vec[], BYTE vector_max) {
  BYTE i = 0;
  for (i = 0; i < vector_max; i++) {
    pic[i] = pictureDisplay(&dot_img, &dot_img_Palettes, vec[i].x, vec[i].y);
  }
}
*/

void maskUpdate(short x, short y, vec2short vec[], vec2short offset[], BYTE vector_max) {
  BYTE i = 0;
  for (i = 0; i < vector_max; i++) {
    vec[i].x = x + offset[i].x;
    vec[i].y = y + offset[i].y;
  }
}

vec2int vec2intMake(int x, int y) {
  vec2int rt;
  rt.x = x; rt.y = y;
  return rt;
}

vec2short vec2shortMake(short x, short y) {
  vec2short rt;
  rt.x = x; rt.y = y;
  return rt;
}

vec2byte vec2byteMake(BYTE x, BYTE y) {
  vec2byte rt;
  rt.x = x; rt.y = y;
  return rt;
}

BOOL vectorsCollide(box *box, vec2short vec[], BYTE vector_max) {
  BOOL p0 = false, p1 = false, p2 = false, p3 = false, p4 = false;
  p0 = collide_point(box->p0.x, box->p0.y, vec, vector_max);
  p1 = collide_point(box->p1.x, box->p1.y, vec, vector_max);
  p2 = collide_point(box->p2.x, box->p2.y, vec, vector_max);
  p3 = collide_point(box->p3.x, box->p3.y, vec, vector_max);
  p4 = collide_point(box->p4.x, box->p4.y, vec, vector_max);
  return (p0 || p1 || p2 || p3 || p4);
}

void spriteDisableAutoinc() {
  sprite_autoinc = false;
}

void spriteEnableAutoinc() {
  sprite_autoinc = true;
}

void spriteSetIndex(WORD index) {
	sprite_index = index;
}

void scrollerDisplay(scroller *s, scrollerInfo *si, paletteInfo *pali, short posX, short posY) {
  scrollerInit(
    s,
    si,
    scrollerGetSpriteIndexAutoinc(si),
    paletteGetIndex(),
    posX,
    posY
  );
  palJobPut(
    paletteGetIndexAutoinc(pali),
    pali->palCount,
    pali->data
  );
}

void scrollerMove(scroller *sc, short x, short y) {
  scrollerSetPos(sc, sc->scrlPosX + x, sc->scrlPosY + y);
}

WORD spriteGetIndex() {
  return sprite_index;
}

WORD scrollerGetSpriteIndexAutoinc(scrollerInfo *si) {
  WORD rt = sprite_index;
  sprite_index += 21;
  return rt;
}

void inline shrunkAddr(WORD addr, WORD shrunk_value) {
  SC234Put(addr, shrunk_value);
}

WORD shrunkForge(BYTE xc, BYTE yc) { // TODO xcF, ycFF
  //F FF - x (hor) , y (vert)
  // vertical shrinking   8 bit
  // horizontal shrinking 4 bit
  WORD value = 0;
  value = xc << 8;
  value += yc;
  return value;
}

WORD shrunkRange(WORD addr_start, WORD addr_end, WORD shrunk_value) {
  WORD cur_addr = addr_start;
  while (cur_addr < addr_end) {
    SC234Put(cur_addr, shrunk_value);
    cur_addr++;
  }
  return addr_end;
}

WORD shrunkPropTableGet(WORD index) {
  return shrunk_table_prop[index];
}

int shrunkCentroidGetTranslatedX(short centerPosX, WORD tileWidth, BYTE shrunkX) {
  FIXED newX = FIX(centerPosX);
  newX -= (shrunkX + 1) * FIX((tileWidth MULT8) / 0x10);
  return fixtoi(newX);
}

int shrunkCentroidGetTranslatedY(short centerPosY, WORD tileHeight, BYTE shrunkY) {
  FIXED newY = FIX(centerPosY);
  newY -= shrunkY * FIX((tileHeight MULT8) / 0xFF);
  return fixtoi(newY);
}

char sinTableGet(WORD index) {
return sinTable[index];
}

DWORD inline waitVbl(WORD nb) {
  WORD i = 0;
  for (i = 0; i <= nb; i++) waitVBlank();
  return DAT_frameCounter;
}

//

