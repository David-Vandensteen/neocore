#include <neocore.h>
#include <math.h>
#include "externs.h"

static void init();
static void display();
static void update();

static GFX_Picture planet01, planet02, planet03;

static void init() {
  init_gpu();
  init_gp(&planet01, &planet04_sprite, &planet04_sprite_Palettes);
  init_gp(&planet02, &planet04_sprite, &planet04_sprite_Palettes);
  init_gp(&planet03, &planet04_sprite, &player_sprite_Palettes);
}

static void display() {
  display_gp(&planet01, 10, 10);
  display_gp(&planet02, 100, 100);
  display_gp(&planet03, 200, 100);
}

static void update() {
  init_logger();
  logger_word("P1 INDEX : ", planet01.pic.basePalette);
  logger_info("MUST BE : 17");
  logger_word("P2 INDEX : ", planet02.pic.basePalette);
  logger_info("MUST BE : 18");
  logger_word("P3 INDEX : ", planet03.pic.basePalette);
  logger_info("MUST BE : 17");
  if (get_frame_counter() == 500) {
    logger_info("P1 REALLOCATE");
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
