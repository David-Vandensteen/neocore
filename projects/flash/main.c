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
  image_display(&pic, &laser_sprite, &laser_sprite_Palettes, 100, 200);
  player_display();
  animated_sprite_flash(&player_get()->as, 10);
}

static void update() {
  BYTE i = 0;
  WORD val = 0;
  player_update();
  animated_sprite_flash_update(&player_get()->as);
}

int main(void) {
  gpu_init();
  init();
  display();
  while(1) {
    WAIT_VBL
    update();
    SCClose();
  };
  SCClose();
  return 0;
}
