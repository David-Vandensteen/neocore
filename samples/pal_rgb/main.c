#include <neocore.h>
#include "externs.h"

#define palette_number 17
static BYTE palette_index = 0;

static GFX_Picture playfield;
static RGB16 color;

static void init();
static void display();
static void update();

static void init() {
  nc_joypad_set_edge_mode(TRUE);
}

static void display() {
  nc_gfx_init_and_display_picture(
    &playfield,
    playfield_asset_pict_rom.pictureInfo,
    playfield_asset_pict_rom.paletteInfo,
    0,
    0
  );
}

static void update() {
  for (palette_index = 0; palette_index < 16; palette_index++) {
    nc_read_palette_rgb16(17, palette_index, &color);
    color.dark = nc_math_random(0xF);
    color.r = nc_math_random(0xF);
    color.g = nc_math_random(0xF);
    color.b = nc_math_random(0xF);
    nc_palette_manager_set_rgb16(palette_number, palette_index, color);
    nc_gpu_wait_vbl_max(10);
    nc_log_init();
    nc_log_rgb16(&color);
    nc_log_info_line("");
    nc_log_packed_color16(nc_palette_rgb16_to_packed_color16(color));
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
