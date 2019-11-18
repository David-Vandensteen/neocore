#include <neocore.h>
#include <math.h>
#include "player.h"
#include "externs.h"

// #define pictureHide(p) { short x = (p)->posX; short y = (p)->posY; pictureSetPos(p, -128, -128); (p)->posX = x; (p)->posY = y; } // overwrite DATlib func

NEOCORE_INIT


static void init();
static void display();
static void update();

static picture pic;
static BOOL toogle_visibility = false;

//TODO patch neocore
static BOOL pictureIsVisible(picture *p) {
  return (p->posY < 0) ? false : true;
}

static void init() {
  player_init();
}

static void display() {
  pictureDisplay(&pic, &laser_sprite, &laser_sprite_Palettes, 100, 200);
  player_display();
}

static void update() {
  BYTE i = 0;
  WORD val = 0;
  player_update();
  // aSpriteFlash(&player_get()->as, 30);
  // pictureFlash(&pic, 4);
  loggerInit();
  pictureShrunk(&pic, &laser_sprite, shrunkForge(0, 0));
  loggerShort("POS Y : ", pic.posY);

// pictureHide(&pic);
  // loggerWord("VISIBLE : ", pictureIsVisible(&pic));
}

int main(void) {
  gpu_init();
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
