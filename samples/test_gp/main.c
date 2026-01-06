#include <neocore.h>
#include "externs.h"

static GFX_Picture asteroid;
static Position position;

static void init();
static void display();
static void update();

static void init() {
  nc_gfx_init_picture(
    &asteroid,
    asteroid_asset_pict_rom.pictureInfo,
    asteroid_asset_pict_rom.paletteInfo
  );
}

static void display() {
  nc_gfx_display_picture(&asteroid, 100, 100);
}

static void update() {
  const DWORD accumulator = 200;
  DWORD frame_seq = accumulator;

  nc_log_init();

  if (nc_gpu_get_frame_number() < frame_seq) {
    nc_log_info_line("INIT GP");
    nc_log_info("DISPLAY GP AT 100 100");
  }

  frame_seq += accumulator;

  if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
    nc_log_info("SET POS GP 150 150");
    nc_gfx_set_picture_position(&asteroid, 150, 150);
  }

  frame_seq += accumulator;

  if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
    nc_gfx_get_picture_position(&asteroid, &position);
    if (position.x < 0) {
      nc_gfx_set_picture_position(&asteroid, 150, 150);
    } else {
      nc_log_info("MOVE GP -1 -1");
      nc_gfx_move_picture(&asteroid, -1, -1);
    }
  }

  frame_seq += accumulator;

  if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
    nc_log_info_line("GET X AND Y GP");
    nc_gfx_set_picture_position(&asteroid, 181, 57);
    nc_gfx_get_picture_position(&asteroid, &position);
    nc_log_info_line("X: %d", position.x);
    nc_log_info("Y: %d", position.y);
  }

  frame_seq += accumulator;

  if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
    nc_log_info("HIDE GP");
    nc_gfx_hide_picture(&asteroid);
  }

  frame_seq += accumulator;

  if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
    nc_log_info("SHOW GP");
    nc_gfx_show_picture(&asteroid);
  }

  frame_seq += accumulator;

  if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
    nc_log_info("DESTROY GP");
    nc_gfx_destroy_picture(&asteroid);
  }

  frame_seq += accumulator;

  if (nc_gpu_get_frame_number() >= (frame_seq - accumulator)) {
    nc_log_info("TEST GP END");
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
