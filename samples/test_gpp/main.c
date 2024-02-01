#include <neocore.h>
#include "externs.h"

static GFX_Picture_Physic asteroid;

static void init();
static void display();
static void update();

static void init() {
  nc_init_gfx_picture_physic(&asteroid, &asteroid_asset, &asteroid_asset_Palettes, 0, 0, 0, 0, AUTOBOX);
}

static void display() {
  nc_display_gfx_picture_physic(&asteroid, 100, 100);
}

static void update() {
  const DWORD accumulator = 200;
  DWORD frame_seq = accumulator;

  nc_init_log();

  if (nc_get_frame_counter() < frame_seq) {
    nc_log_info("INIT GPP");
    nc_log_info("DISPLAY GPP AT 100 100");
  }

  frame_seq += accumulator;

  if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
    nc_log_info("SET POS GPP 150 150");
    nc_set_position_gfx_picture_physic(&asteroid, 150, 150);
  }

  frame_seq += accumulator;

  if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
    if (nc_get_position_gfx_picture_physic(asteroid).x < 0) {
      nc_set_position_gfx_picture_physic(&asteroid, 150, 150);
    } else {
      nc_log_info("MOVE GPP -1 -1");
      nc_move_gfx_picture_physic(&asteroid, -1, -1);
    }
  }

  frame_seq += accumulator;

  if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
    nc_log_info("GET X AND Y GPP");
    nc_set_position_gfx_picture_physic(&asteroid, 181, 57);
    nc_log_short("X", nc_get_position_gfx_picture_physic(asteroid).x);
    nc_log_short("Y", nc_get_position_gfx_picture_physic(asteroid).y);
  }

  frame_seq += accumulator;

  if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
    nc_log_info("HIDE GPP");
    nc_hide_gfx_picture_physic(&asteroid);
  }

  frame_seq += accumulator;

  if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
    nc_log_info("SHOW GPP");
    nc_show_gfx_picture_physic(&asteroid);
  }

  frame_seq += accumulator;

  if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
    nc_log_info("DESTROY GPP");
    nc_destroy_gfx_picture_physic(&asteroid);
  }

  frame_seq += accumulator;

  if (nc_get_frame_counter() >= (frame_seq - accumulator)) {
    nc_log_info("TEST GPP END");
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
