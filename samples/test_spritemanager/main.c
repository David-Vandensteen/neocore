#include <neocore.h>
#include <math.h>
#include "externs.h"

static void init();
static void display();
static void update();

static GFX_Picture planet01, planet02, planet03, planet04;

static void init() {
  init_gpu();
  init_gp(&planet01, &planet04_sprite, &planet04_sprite_Palettes);
  init_gp(&planet02, &planet04_sprite, &planet04_sprite_Palettes);
  init_gp(&planet03, &planet04_sprite, &planet04_sprite_Palettes);
  init_gp(&planet04, &planet04_sprite, &planet04_sprite_Palettes);
}

static void display() {
  display_gp(&planet01, 10, 10);
  display_gp(&planet02, 100, 100);
  display_gp(&planet03, 200, 100);
}

static void update() {
  init_logger();
  logger_word("P1 INDEX : ", planet01.pic.baseSprite);
  logger_info("MUST BE : 1");
  logger_word("P2 INDEX : ", planet02.pic.baseSprite);
  logger_info("MUST BE : 9");
  logger_word("P3 INDEX : ", planet03.pic.baseSprite);
  logger_info("MUST BE : 17");
  if (get_frame_counter() == 500) {
    destroy_gp(&planet01);
    display_gp(&planet04, 100, 10);
  }
  if (get_frame_counter() > 500) {
    logger_word("P4 INDEX : ", planet04.pic.baseSprite);
    logger_info("MUST BE : 1");
  }
}

int main(void) {
  init();
  display();
  while(1) {
    wait_vbl();
    update();
    close_vbl();
  };
  close_vbl();
  return 0;
}
