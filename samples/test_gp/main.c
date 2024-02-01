#include <neocore.h>
#include "externs.h"

static GFX_Picture asteroid;

static void init();
static void display();
static void update();

static void init() {
  nc_init_gfx_picture(&asteroid, &asteroid_asset, &asteroid_asset_Palettes);
}

static void display() {
  nc_display_gfx_picture(&asteroid, 100, 100);
}

static void update() {
  const DWORD accumulator = 200;
  DWORD frame_seq = accumulator;

  nc_init_log();

  if (nc_get_frame_counter() < frame_seq) {
    nc_log_info("INIT GP");
    nc_log_info("DISPLAY GP AT 100 100");
  }

  frame_seq += accumulator;

  if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
    nc_log_info("SET POS GP 150 150");
    nc_set_position_gfx_picture(&asteroid, 150, 150);
  }

  frame_seq += accumulator;

  if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
    if (nc_get_position_gfx_picture(asteroid).x < 0) {
      nc_set_position_gfx_picture(&asteroid, 150, 150);
    } else {
      nc_log_info("MOVE GP -1 -1");
      nc_move_gfx_picture(&asteroid, -1, -1);
    }
  }

  frame_seq += accumulator;

  if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
    nc_log_info("GET X AND Y GP");
    nc_set_position_gfx_picture(&asteroid, 181, 57);
    nc_log_short("X", nc_get_position_gfx_picture(asteroid).x);
    nc_log_short("Y", nc_get_position_gfx_picture(asteroid).y);
  }

  frame_seq += accumulator;

  if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
    nc_log_info("HIDE GP");
    nc_hide_gfx_picture(&asteroid);
  }

  frame_seq += accumulator;

  if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
    nc_log_info("SHOW GP");
    nc_show_gfx_picture(&asteroid);
  }

  frame_seq += accumulator;

  if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
    nc_log_info("DESTROY GP");
    nc_destroy_gfx_picture(&asteroid);
  }

  frame_seq += accumulator;

  if (nc_get_frame_counter() >= (frame_seq - accumulator)) {
    nc_log_info("TEST GP END");
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
