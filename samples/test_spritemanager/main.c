#include <neocore.h>
#include <math.h>
#include "externs.h"

static void init();
static void display();
static void update();

static GFX_Picture planet01, planet02, planet03, planet04;

static void init() {
  nc_gfx_init_picture(&planet01, planet04_sprite_pict_rom.pictureInfo, planet04_sprite_pict_rom.paletteInfo);
  nc_gfx_init_picture(&planet02, planet04_sprite_pict_rom.pictureInfo, planet04_sprite_pict_rom.paletteInfo);
  nc_gfx_init_picture(&planet03, planet04_sprite_pict_rom.pictureInfo, planet04_sprite_pict_rom.paletteInfo);
  nc_gfx_init_picture(&planet04, planet04_sprite_pict_rom.pictureInfo, planet04_sprite_pict_rom.paletteInfo);
}

static void display() {
  nc_gfx_display_picture(&planet01, 10, 10);
  nc_gfx_display_picture(&planet02, 100, 100);
  nc_gfx_display_picture(&planet03, 200, 100);
}

static void update() {
  nc_log_init();
  nc_log_info_line("P1 INDEX : %04d", planet01.pictureDAT.baseSprite);
  nc_log_info_line("MUST BE : 1");
  nc_log_info_line("P2 INDEX : %04d", planet02.pictureDAT.baseSprite);
  nc_log_info_line("MUST BE : 9");
  nc_log_info_line("P3 INDEX : %04d", planet03.pictureDAT.baseSprite);
  nc_log_info("MUST BE : 17");

  if (nc_gpu_get_frame_number() == 500) {
    nc_gfx_destroy_picture(&planet01);
    nc_gfx_display_picture(&planet04, 100, 10);
  }

  if (nc_gpu_get_frame_number() > 500) {
    nc_log_info("P4 INDEX : %04d", planet04.pictureDAT.baseSprite);
    nc_log_info("MUST BE : 1");
  }
}

int main(void) {
  init();
  display();

  while(1) {
    nc_gpu_update();
    update();
  };

  return 0;
}
