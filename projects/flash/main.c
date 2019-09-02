#include <neocore.h>
#include <math.h>
#include "player.h"
#include "externs.h"

NEOCORE_INIT

static void init();
static void display();
static void update();

static picture pic;

static void init() {
  player_init();
}

static void display() {
  pictureDisplay(&pic, &laser_sprite, &laser_sprite_Palettes, 100, 200);
  player_display();
}

static void update() {
  player_update();
  aSpriteFlash(&player_get()->as, 0);
  pictureFlash(&pic, 0);
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
