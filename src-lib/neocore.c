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
 /* -static          */
/*------------------*/

static WORD sprite_index = 1;
static BYTE palette_index = 16;

static BOOL palette_auto_index = true;
static BOOL sprite_auto_index = true;

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
 //                                  -A                                      //
//--------------------------------------------------------------------------//
  /*------------------*/
 /* -animated_sprite */
/*------------------*/
void animated_sprite_init(Animated_Sprite *animated_sprite ,spriteInfo *si, paletteInfo *pali) {
  flash_init(&animated_sprite->flash, false, 0, 0);
  animated_sprite->si = si;
  animated_sprite->pali = pali;
};

void animated_sprite_display(Animated_Sprite *animated_sprite, short x, short y, WORD anim) {
  BOOL palette_auto_index_state = palette_auto_index;
  palette_disable_auto_index();
  aSpriteInit(
    &animated_sprite->as,
    animated_sprite->si,
		get_sprite_index_from_sprite(animated_sprite->si),
    get_palette_index(animated_sprite->pali),
    x,
    y,
    anim,
    FLIP_NONE
  );
  if (palette_auto_index_state) palette_enable_auto_index();
  palJobPut(
    get_palette_index(animated_sprite->pali),
    animated_sprite->pali->palCount,
    animated_sprite->pali->data
  );
  aSpriteSetAnim(&animated_sprite->as, anim);
}

BOOL animated_sprite_flash(Animated_Sprite *animated_sprite) {
  if (animated_sprite->flash.enabled) {
    if (DAT_frameCounter % animated_sprite->flash.frequency == 0) {
      (is_visible(&animated_sprite->flash)) ? animated_sprite_hide(animated_sprite) : animated_sprite_show(animated_sprite);
      animated_sprite->flash.lengh--;
      if (animated_sprite->flash.lengh <= 0) {
        animated_sprite_show(animated_sprite);
        animated_sprite->flash.enabled = false;
      }
    }
  }
  return animated_sprite->flash.enabled;
}

void animated_sprite_set_animation(Animated_Sprite *animated_sprite, WORD anim) {
  aSpriteSetAnim(&animated_sprite->as, anim);
}

void animated_sprite_hide(Animated_Sprite *animated_sprite) {
  animated_sprite->flash.visible = false;
  aSpriteHide(&animated_sprite->as);
  clearSprites(animated_sprite->as.baseSprite, animated_sprite->as.tileWidth);
}

void animated_sprite_show(Animated_Sprite *animated_sprite) {
  animated_sprite->flash.visible = true;
  aSpriteShow(&animated_sprite->as);
}

  /*--------------------------*/
 /* -animated_sprite_physic  */
/*--------------------------*/
void animated_sprite_physic_init(
    Animated_Sprite_Physic *animated_sprite_physic,
    spriteInfo *si,
    paletteInfo *pali,
    short box_witdh,
    short box_height,
    short box_width_offset,
    short box_height_offset
  ) {
  box_init(
    &animated_sprite_physic->box,
    box_witdh,
    box_height,
    box_width_offset,
    box_height_offset
  );
  animated_sprite_physic->physic_enabled = true;
  animated_sprite_init(
    &animated_sprite_physic->animated_sprite,
    si,
    pali
  );
}

void animated_sprite_physic_display(Animated_Sprite_Physic *animated_sprite_physic, short x, short y, WORD anim) {
  animated_sprite_display(
    &animated_sprite_physic->animated_sprite,
    x,
    y,
    anim
  );
  box_update(&animated_sprite_physic->box, x, y);
}

void animated_sprite_physic_set_position(Animated_Sprite_Physic *animated_sprite_physic, short x, short y) {
  animated_sprite_set_position(&animated_sprite_physic->animated_sprite, x, y);
  box_update(&animated_sprite_physic->box, x, y);
}

void animated_sprite_physic_move(Animated_Sprite_Physic *animated_sprite_physic, short x_offset, short y_offset) {
  animated_sprite_move(&animated_sprite_physic->animated_sprite, x_offset, y_offset);
  box_update(&animated_sprite_physic->box, animated_sprite_physic->animated_sprite.as.posX, animated_sprite_physic->animated_sprite.as.posY);
}

void animated_sprite_physic_shrunk(Animated_Sprite_Physic *animated_sprite_physic, WORD shrunk_value) {
  shrunk(animated_sprite_physic->animated_sprite.as.baseSprite, animated_sprite_physic->animated_sprite.si->maxWidth, shrunk_value);
  // todo (minor) - box resize
}

void animated_sprite_physic_hide(Animated_Sprite_Physic *animated_sprite_physic) {
  animated_sprite_hide(&animated_sprite_physic->animated_sprite);
  animated_sprite_physic->physic_enabled = false;
}

void animated_sprite_physic_show(Animated_Sprite_Physic *animated_sprite_physic) {
  animated_sprite_show(&animated_sprite_physic->animated_sprite);
  animated_sprite_physic->physic_enabled = true;
}

void animated_sprite_physic_flash(Animated_Sprite_Physic *animated_sprite_physic) {
  animated_sprite_physic->physic_enabled = animated_sprite_flash(&animated_sprite_physic->animated_sprite);
}

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
void inline clear_vram() { // todo (minor) - disable interrupt
  WORD addr = 0x0000;
  WORD addr_end = 0x8FFF;
  for (addr = addr; addr <= addr_end; addr++) {
    SC234Put(addr, 0);
  }
  SCClose();
  wait_vbl_max(10);
  SCClose();
  wait_vbl_max(10);
}

  //--------------------------------------------------------------------------//
 //                                  -F                                      //
//--------------------------------------------------------------------------//
void inline fix_print_neocore(int x, int y, char *label){
  fixPrint(x, y, 0, 0, label);
}

void flash_init(Flash *flash, BOOL enabled, short frequency, short lengh) {
  flash->enabled = enabled;
  flash->frequency = frequency;
  flash->lengh = lengh;
}

  //--------------------------------------------------------------------------//
 //                                  -G                                      //
//--------------------------------------------------------------------------//
void inline gpu_init() {
  backgroundColor(0x7000); // todo (minor) - macro with some colors ...
  clearFixLayer();
  initGfx();
  volMEMWORD(0x400002) = 0xffff;  // debug text white
  LSPCmode = 0x1c00;              // autoanim speed
  sprite_index = 1;
  palette_index = 16;
}

WORD get_sprite_index() { return sprite_index; }

WORD get_sprite_index_from_picture(pictureInfo *pi) {
  WORD rt = sprite_index;
  if (sprite_auto_index) sprite_index += pi->tileWidth;
  return rt;
}

WORD get_sprite_index_from_sprite(spriteInfo *si) {
  WORD rt = sprite_index;
  if (sprite_auto_index) sprite_index += si->maxWidth;
  return rt;
}

BYTE get_palette_index(paletteInfo *pali) {
	BYTE rt = palette_index;
  if (palette_auto_index) palette_index += pali->palCount;
	return rt;
}

WORD get_shrunk_proportional_table(WORD index) {
  return shrunk_table_prop[index]; // todo (minor) - rename shrunk_proportional_table
}

char get_sin(WORD index) {
  return sinTable[index];
}

  //--------------------------------------------------------------------------//
 //                                  -I                                      //
//--------------------------------------------------------------------------//
BOOL is_visible(Flash *flash) {
  return flash->visible;
}

  /*------------------*/
 /*      -image      */
/*------------------*/
void image_init(Image *image, pictureInfo *pi, paletteInfo *pali) {
  flash_init(&image->flash, false, 0, 0);
  image->pali = pali;
  image->pi = pi;
}

void image_display(Image *image, short x, short y) {
  BOOL palette_auto_index_state = palette_auto_index;
  palette_disable_auto_index();
  pictureInit(
    &image->pic,
    image->pi,
    get_sprite_index_from_picture(image->pi),
    get_palette_index(image->pali),
    x,
    y,
    FLIP_NONE
  );
  if (palette_auto_index_state) palette_enable_auto_index();
  palJobPut(
    get_palette_index(image->pali),
    image->pali->palCount,
    image->pali->data
  );
}

void image_set_position(Image *image, short x, short y) {
  pictureSetPos(&image->pic, x, y);
}


void image_hide(Image *image) {
  pictureHide(&image->pic);
  image->flash.visible = false;
}

void image_show(Image *image) {
  pictureShow(&image->pic);
  image->flash.visible = true;
}

BOOL image_flash(Image *image) {
  BOOL rt = true;
  if (image->flash.frequency != 0 && image->flash.lengh != 0) {
    if (DAT_frameCounter % image->flash.frequency == 0) {
      if (is_visible(&image->flash)) {
        image_hide(image);
        rt = false;
      } else {
        image_show(image);
        rt = true;
      }
      image->flash.lengh--;
      if (image->flash.lengh == 0) image_show(image);
    }
  }
  return rt;
}

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
) {
  image_init(&image_physic->image, pi, pali);
  box_init(&image_physic->box, box_witdh, box_height, box_width_offset, box_height_offset);
}

void image_physic_display(Image_Physic *image_physic, short x, short y) {
  image_display(&image_physic->image, x, y);
  box_update(&image_physic->box, x, y);
}

void image_physic_move(Image_Physic *image_physic, short x_offset, short y_offset) {
  image_move(&image_physic->image, x_offset, y_offset);
  box_update(&image_physic->box, image_physic->image.pic.posX, image_physic->image.pic.posY);
}

void image_physic_set_position(Image_Physic *image_physic, short x, short y) {
  image_set_position(&image_physic->image, x, y);
  box_update(&image_physic->box, x, y);
}

void image_physic_hide(Image_Physic *image_physic) {
  image_hide(&image_physic->image);
  image_physic->physic_enabled = false;
}

void image_physic_show(Image_Physic *image_physic) {
  image_show(&image_physic->image);
  image_physic->physic_enabled = true;
}

void image_physic_flash(Image_Physic *image_physic) {
  image_physic->physic_enabled = image_flash(&image_physic->image);
}

void image_physic_shrunk(Image_Physic *image_physic, WORD shrunk_value) {
  shrunk(image_physic->image.pic.baseSprite, image_physic->image.pic.info->tileWidth, shrunk_value);
  // todo (minor) - shrunk box
}

void image_shrunk_centroid(Image *image, short center_x, short center_y, WORD shrunk_value) {
  shrunk(image->pic.baseSprite, image->pic.info->tileWidth, shrunk_value);
  image_set_position(
    image,
    shrunk_centroid_get_translated_x(center_x, image->pi->tileWidth, SHRUNK_EXTRACT_X(shrunk_value)),
    shrunk_centroid_get_translated_y(center_y, image->pi->tileHeight, SHRUNK_EXTRACT_Y(shrunk_value))
  );
}

  //--------------------------------------------------------------------------//
 //                                  -J                                      //
//--------------------------------------------------------------------------//
  /*----------*/
 /* -joypad  */
/*----------*/
void inline joypad_debug() {
  JOYPAD_READ
  if (joypad_is_start()) {  fix_print_neocore(10, 11,  "JOYPAD START"); }
  if (joypad_is_up())	   {  fix_print_neocore(10, 11,  "JOYPAD UP   "); }
  if (joypad_is_down())	 {  fix_print_neocore(10, 11,  "JOYPAD DOWN "); }
  if (joypad_is_left())	 {  fix_print_neocore(10, 11,  "JOYPAD LEFT "); }
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

void inline logger_animated_sprite(char *label, Animated_Sprite *animated_sprite) {
  #ifdef LOGGER_ON
  logger_info(label);
  logger_word("BASESPRITE : " , animated_sprite->as.baseSprite);
  logger_word("BASEPALETTE : ", animated_sprite->as.basePalette);
  logger_short("POSX : ", animated_sprite->as.posX);
  logger_short("POSY : ", animated_sprite->as.posY);
  logger_short("CURRENTSTEPNUM : ", animated_sprite->as.currentStepNum);
  logger_short("MAXSTEP : ", animated_sprite->as.maxStep);
  logger_dword("COUNTER : ", animated_sprite->as.counter);
  logger_word("REPEATS : ", animated_sprite->as.repeats);
  logger_word("CURRENTFLIP : ", animated_sprite->as.currentFlip);
  logger_word("TILEWIDTH : ", animated_sprite->as.tileWidth);
  logger_word("ANIMID : ", animated_sprite->as.animID);
  logger_word("FLAGS", animated_sprite->as.flags);
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
  /*-----------*/
 /* -palette  */
/*-----------*/

void palette_disable_auto_index() { palette_auto_index = false; }
void palette_enable_auto_index() { palette_auto_index = true; }
void palette_swap(WORD palette_index, paletteInfo *pali, BOOL vblForce) {
  volatile WORD *palettes = 0x402000 + (32 * palette_index); // todo MULT // todo force mirror ?
  BYTE i = 0;
  if (vblForce) {
    SCClose();
    WAIT_VBL;
  }
  for (i = 0; i < pali->palCount * 16; i += 1) {
    *(palettes + i) = pali->data[i];
  }
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
BYTE set_palette_index(BYTE index) {
	palette_index = index;
	return palette_index;
}

void sprite_disable_autoinc() { sprite_auto_index = false; }
void sprite_enable_autoinc() { sprite_auto_index = true; }

void sprite_set_index(WORD index) {
	sprite_index = index;
}

  /*-----------*/
 /* -scroller */
/*-----------*/
void scroller_set_position(Scroller *s, short x, short y) {
  scrollerSetPos(&s->s, x, y);
}

void scroller_display(Scroller *s, short x, short y) {
  BOOL palette_auto_index_state = palette_auto_index;
  palette_disable_auto_index();
  scrollerInit(
    &s->s,
    s->si,
    get_sprite_index(),
    get_palette_index(s->pali),
    x,
    y
  );
  sprite_index += 21;
  if (palette_auto_index_state) palette_enable_auto_index();
  palJobPut(
    get_palette_index(s->pali),
    s->pali->palCount,
    s->pali->data
  );
}

void scroller_move(Scroller *s, short x, short y) {
  scrollerSetPos(&s->s, s->s.scrlPosX + x, s->s.scrlPosY + y);
}

void scroller_init(Scroller *s, scrollerInfo *si, paletteInfo *pali) {
  s->si = si;
  s->pali = pali;
}

  /*-----------*/
 /* -shrunk   */
/*-----------*/
void inline shrunk_addr(WORD addr, WORD shrunk_value) {
  SC234Put(addr, shrunk_value);
}

WORD shrunk_forge(BYTE xc, BYTE yc) { // todo (minor) - xcF, ycFF
  //F FF - x (hor) , y (vert)
  // vertical shrinking   8 bit
  // horizontal shrinking 4 bit
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


///////////////////////////////////////////////////////////////////////

/* todo (minor)
void box_debug_update(picture5 *pics, Box *box) {
  pictureSetPos(&pics->pic0, box->p0.x, box->p0.y);
  pictureSetPos(&pics->pic1, box->p1.x, box->p1.y);
  pictureSetPos(&pics->pic2, box->p2.x, box->p2.y);
  pictureSetPos(&pics->pic3, box->p3.x, box->p3.y);
  pictureSetPos(&pics->pic4, box->p4.x, box->p4.y);
}
*/

/*
void box_display(picture5 *pics, Box *box, pictureInfo *pi, paletteInfo *pali) {
  palette_disable_autoinc();
  image_display(&pics->pic0, pi, pali, box->p0.x, box->p0.y);
  image_display(&pics->pic1, pi, pali, box->p1.x, box->p1.y);
  image_display(&pics->pic2, pi, pali, box->p2.x, box->p2.y);
  image_display(&pics->pic3, pi, pali, box->p3.x, box->p3.y);
  palette_enable_autoinc();
  image_display(&pics->pic4, pi, pali, box->p4.x, box->p4.y);
}
*/

/*
void image_physic_shrunk_centroid_update(picturePhysicShrunkCentroid *pps, WORD shrunk) {
  image_shrunk_centroid(&pps->pp.p, pps->pi, pps->positionCenter.x, pps->positionCenter.y, shrunk);
  box_shrunk(&pps->pp.box, &pps->boxOrigin, shrunk);
}

void image_physic_shrunk_centroid_display(picturePhysicShrunkCentroid *pps, WORD shrunk) {
  image_physic_display(&pps->pp, pps->pi, pps->pali, pps->positionCenter.x, pps->positionCenter.y);
  image_shrunk_centroid(&pps->pp.p, pps->pi, pps->positionCenter.x, pps->positionCenter.y, shrunk);
  BOXCOPY(&pps->pp.box, &pps->boxOrigin);
}

void image_physic_shrunk_centroid_init(picturePhysicShrunkCentroid *pps, pictureInfo *pi, paletteInfo *pali, short xCenter, short yCenter) {
  pps->pi = pi;
  pps->pali = pali;
  pps->positionCenter.x = xCenter;
  pps->positionCenter.y = yCenter;
}

void image_physic_shrunk_centroid_set_position(picturePhysicShrunkCentroid *pps, short x, short y) {
  pps->positionCenter.x = x;
  pps->positionCenter.y = y;
  box_update(&pps->boxOrigin, x, y);
}

void image_physic_shrunk_centroid_move(picturePhysicShrunkCentroid *pps, short xShift, short yShift) {
  image_physic_shrunk_centroid_set_position(pps, pps->positionCenter.x + xShift, pps->positionCenter.y + yShift);
}

void image_physic_display(picturePhysic *pp, pictureInfo *pi, paletteInfo *pali, short posX, short posY) {
  image_display(&pp->p, pi, pali, posX, posY);
  box_update(&pp->box, posX, posY);
}

void image_physic_set_position(picturePhysic *pp, short x, short y) {
  pictureSetPos(&pp->p, x, y);
  box_update(&pp->box, x, y);
}
*/

/* todo (minor) - deprecated
WORD image_get_sprite_index_autoinc(pictureInfo *pi) {
  WORD rt = sprite_index;
  if (sprite_auto_index) sprite_index += pi->tileWidth;
  return rt;
}
*/

/* todo (minor)
void image5_show(picture5 *pics, BOOL visible) {
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
*/

/* todo (minor)
void maskDisplay(picture pic[], vec2short vec[], BYTE vector_max) {
  BYTE i = 0;
  for (i = 0; i < vector_max; i++) {
    pic[i] = pictureDisplay(&dot_img, &dot_img_Palettes, vec[i].x, vec[i].y);
  }
}
*/

void mask_update(short x, short y, Vec2short vec[], Vec2short offset[], BYTE vector_max) {
  BYTE i = 0;
  for (i = 0; i < vector_max; i++) {
    vec[i].x = x + offset[i].x;
    vec[i].y = y + offset[i].y;
  }
}
