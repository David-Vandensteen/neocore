#include <neocore.h>
#include <math.h>
#include "player.h"
#include "externs.h"

NEOCORE_INIT

static void init();
static void display();
static void update();

static picture pic;

// TODO patch neocore
// #define aSpriteHide(as)		{(as)->flags|=0x0080;}
// #define aSpriteShow(as)		{(as)->flags&=0xff7f;(as)->flags|=0x0002;}

static void aSpriteIsVisible(aSprite *as) {
  loggerInit();
  loggerWord("FLAGS: ", as->flags);
  ((as->flags | 0x0080 == 0)) ? loggerInfo("VISIBLE FALSE") : loggerInfo("VISIBLE TRUE");

}
//

static void init() {
  player_init();
}

static void display() {
  pictureDisplay(&pic, &laser_sprite, &laser_sprite_Palettes, 100, 200);
  player_display();
}

static void update() {
  player_update();
  aSpriteFlash(&player_get()->as, 30);
  pictureFlash(&pic, 4);
  aSpriteIsVisible(&player_get()->as);
}

int main(void) {
  gpuInit();
  init();
  display();
  while(1) {
    waitVBlank();
    update();
    SCClose();
  };
  SCClose();
  return 0;
}
