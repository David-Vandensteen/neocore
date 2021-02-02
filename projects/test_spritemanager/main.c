#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

static void init();
static void display();
static void update();

static Image planet01, planet02, planet03, planet04;

static void init() {
  gpu_init();
  image_init(&planet01, &planet04_sprite, &planet04_sprite_Palettes);
  image_init(&planet02, &planet04_sprite, &planet04_sprite_Palettes);
  image_init(&planet03, &planet04_sprite, &planet04_sprite_Palettes);
  image_init(&planet04, &planet04_sprite, &planet04_sprite_Palettes);
}

static void display() {
  image_display(&planet01, 10, 10);
  image_display(&planet02, 100, 100);
  image_display(&planet03, 200, 100);
}

static void update() {
  logger_init();
  logger_word("P1 INDEX : ", planet01.pic.baseSprite);
  logger_info("MUST BE : 1");
  logger_word("P2 INDEX : ", planet02.pic.baseSprite);
  logger_info("MUST BE : 9");
  logger_word("P3 INDEX : ", planet03.pic.baseSprite);
  logger_info("MUST BE : 17");
  if (DAT_frameCounter == 500) {
    image_destroy(&planet01);
    image_display(&planet04, 100, 10);
  }
  if (DAT_frameCounter > 500) {
    logger_word("P4 INDEX : ", planet04.pic.baseSprite);
    logger_info("MUST BE : 1");
  }
}

int main(void) {
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
