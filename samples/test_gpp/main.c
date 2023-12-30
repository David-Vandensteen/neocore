#include <neocore.h>
#include "externs.h"

static GFX_Picture_Physic asteroid;

static void init();
static void display();
static void update();

static void init() {
  init_gpu();
  init_gfx_picture_physic(&asteroid, &asteroid_asset, &asteroid_asset_Palettes, 0, 0, 0, 0, AUTOBOX);
}

static void display() {
  display_gfx_picture_physic(&asteroid, 100, 100);
}

static void update() {
  const DWORD accumulator = 200;
  DWORD frame_seq = accumulator;
  init_log();
  if (get_frame_counter() < frame_seq) {
    log_info("INIT GPP");
    log_info("DISPLAY GPP AT 100 100");
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    log_info("SET POS GPP 150 150");
    set_position_gfx_picture_physic(&asteroid, 150, 150);
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    if (get_x_gfx_picture_physic(asteroid) < 0) {
      set_position_gfx_picture_physic(&asteroid, 150, 150);
    } else {
      log_info("MOVE GPP -1 -1");
      move_gfx_picture_physic(&asteroid, -1, -1);
    }
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    log_info("GET X AND Y GPP");
    set_position_gfx_picture_physic(&asteroid, 181, 57);
    log_short("X", get_x_gfx_picture_physic(asteroid));
    log_short("Y", get_y_gfx_picture_physic(asteroid));
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    log_info("HIDE GPP");
    hide_gfx_picture_physic(&asteroid);
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    log_info("SHOW GPP");
    show_gfx_picture_physic(&asteroid);
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    log_info("DESTROY GPP");
    destroy_gfx_picture_physic(&asteroid);
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator)) {
    log_info("TEST GPP END");
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
