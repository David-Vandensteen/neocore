#include <neocore.h>
#include "externs.h"

static GFX_Picture_Physic asteroid;

static void init();
static void display();
static void update();

static void init() {
  init_gpu();
  init_gpp(&asteroid, &asteroid_asset, &asteroid_asset_Palettes, 0, 0, 0, 0, AUTOBOX);
}

static void display() {
  display_gpp(&asteroid, 100, 100);
}

static void update() {
  const DWORD accumulator = 200;
  DWORD frame_seq = accumulator;
  init_logger();
  if (get_frame_counter() < frame_seq) {
    logger_info("INIT GPP");
    logger_info("DISPLAY GPP AT 100 100");
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    logger_info("SET POS GPP 150 150");
    set_pos_gpp(&asteroid, 150, 150);
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    if (get_x_gpp(asteroid) < 0) {
      set_pos_gpp(&asteroid, 150, 150);
    } else {
      logger_info("MOVE GPP -1 -1");
      move_gpp(&asteroid, -1, -1);
    }
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    logger_info("GET X AND Y GPP");
    set_pos_gpp(&asteroid, 181, 57);
    logger_short("X", get_x_gpp(asteroid));
    logger_short("Y", get_y_gpp(asteroid));
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    logger_info("HIDE GPP");
    hide_gpp(&asteroid);
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    logger_info("SHOW GPP");
    show_gpp(&asteroid);
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    logger_info("DESTROY GPP");
    destroy_gpp(&asteroid);
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator)) {
    logger_info("TEST GPP END");
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
