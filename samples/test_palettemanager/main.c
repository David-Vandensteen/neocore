#include <neocore.h>
#include <math.h>
#include "externs.h"


NEOCORE_INIT

static void init();
static void display();
static void update();

static GFX_Image planet01, planet02, planet03;

static void init() {
  gpu_init();
  gfx_image_init(&planet01, &planet04_sprite, &planet04_sprite_Palettes);
  gfx_image_init(&planet02, &planet04_sprite, &planet04_sprite_Palettes);
  gfx_image_init(&planet03, &planet04_sprite, &player_sprite_Palettes);
  //image_init(&planet03, &planet04_sprite, &planet04_sprite_Palettes);
}

static void display() {
  gfx_image_display(&planet01, 10, 10);
  gfx_image_display(&planet02, 100, 100);
  gfx_image_display(&planet03, 200, 100);
}

static void update() {
  logger_init();
  logger_word("P1 INDEX : ", planet01.pic.basePalette);
  logger_info("MUST BE : 17");
  logger_word("P2 INDEX : ", planet02.pic.basePalette);
  logger_info("MUST BE : 18");
  logger_word("P3 INDEX : ", planet03.pic.basePalette);
  logger_info("MUST BE : 17");
  if (DAT_frameCounter == 500) {
    logger_info("P1 REALLOCATE");
  }
}

int main(void) {
  init();
  display();
  while(1) {
    wait_vbl();
    update();
    SCClose();
  };
  SCClose();
  return 0;
}
