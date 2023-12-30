#include <neocore.h>
#include <math.h>
#include "externs.h"

static void init();
static void display();
static void update();

static GFX_Picture planet01, planet02, planet03, planet04;

static void init() {
  init_gpu();
  init_gfx_picture(&planet01, &planet04_sprite, &planet04_sprite_Palettes);
  init_gfx_picture(&planet02, &planet04_sprite, &planet04_sprite_Palettes);
  init_gfx_picture(&planet03, &planet04_sprite, &planet04_sprite_Palettes);
  init_gfx_picture(&planet04, &planet04_sprite, &planet04_sprite_Palettes);
}

static void display() {
  display_gfx_picture(&planet01, 10, 10);
  display_gfx_picture(&planet02, 100, 100);
  display_gfx_picture(&planet03, 200, 100);
}

static void update() {
  init_log();
  log_word("P1 INDEX : ", planet01.pictureDAT.baseSprite);
  log_info("MUST BE : 1");
  log_word("P2 INDEX : ", planet02.pictureDAT.baseSprite);
  log_info("MUST BE : 9");
  log_word("P3 INDEX : ", planet03.pictureDAT.baseSprite);
  log_info("MUST BE : 17");
  if (get_frame_counter() == 500) {
    destroy_gfx_picture(&planet01);
    display_gfx_picture(&planet04, 100, 10);
  }
  if (get_frame_counter() > 500) {
    log_word("P4 INDEX : ", planet04.pictureDAT.baseSprite);
    log_info("MUST BE : 1");
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
