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
  init_log();
  log_word("P1 INDEX : ", planet01.pictureDAT.basePalette);
  log_info("MUST BE : 17");
  log_word("P2 INDEX : ", planet02.pictureDAT.basePalette);
  log_info("MUST BE : 18");
  log_word("P3 INDEX : ", planet03.pictureDAT.basePalette);
  log_info("MUST BE : 17");
  if (get_frame_counter() == 500) {
    log_info("P1 REALLOCATE");
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
