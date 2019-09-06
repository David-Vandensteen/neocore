#include <neocore.h>
#include <math.h>
#include "player.h"
#include "externs.h"

NEOCORE_INIT

static void init();
static void display();
static void update();

static picture pic;

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
  loggerInit();
  player_update();
  // aSpriteFlash(&player_get()->as, 30);
  // pictureFlash(&pic, 4);
  pictureHide(&pic);
  loggerWord("VISIBLE : ", pictureIsVisible(&pic));
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
