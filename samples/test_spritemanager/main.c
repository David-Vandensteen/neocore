#include <neocore.h>
#include <math.h>
#include "externs.h"

static void init();
static void display();
static void update();

static GFX_Picture planet01, planet02, planet03, planet04;

static void init() {
  nc_init_gfx_picture(&planet01, &planet04_sprite, &planet04_sprite_Palettes);
  nc_init_gfx_picture(&planet02, &planet04_sprite, &planet04_sprite_Palettes);
  nc_init_gfx_picture(&planet03, &planet04_sprite, &planet04_sprite_Palettes);
  nc_init_gfx_picture(&planet04, &planet04_sprite, &planet04_sprite_Palettes);
}

static void display() {
  nc_display_gfx_picture(&planet01, 10, 10);
  nc_display_gfx_picture(&planet02, 100, 100);
  nc_display_gfx_picture(&planet03, 200, 100);
}

static void update() {
  nc_init_log();
  nc_log_word("P1 INDEX : ", planet01.pictureDAT.baseSprite);
  nc_log_info("MUST BE : 1");
  nc_log_word("P2 INDEX : ", planet02.pictureDAT.baseSprite);
  nc_log_info("MUST BE : 9");
  nc_log_word("P3 INDEX : ", planet03.pictureDAT.baseSprite);
  nc_log_info("MUST BE : 17");

  if (nc_get_frame_counter() == 500) {
    nc_destroy_gfx_picture(&planet01);
    nc_display_gfx_picture(&planet04, 100, 10);
  }

  if (nc_get_frame_counter() > 500) {
    nc_log_word("P4 INDEX : ", planet04.pictureDAT.baseSprite);
    nc_log_info("MUST BE : 1");
  }
}

int main(void) {
  init();
  display();

  while(1) {
    nc_update();
    update();
  };

  return 0;
}
