#include <neocore.h>
#include "externs.h"

static GFX_Picture asteroid;

static void init();
static void display();
static void update();

static void init() {
  init_gpu();
  init_gp(&asteroid, &asteroid_asset, &asteroid_asset_Palettes);
}

static void display() {
  display_gp(&asteroid, 100, 100);
}

static void update() {
  const DWORD accumulator = 200;
  DWORD frame_seq = accumulator;
  init_log();
  if (get_frame_counter() < frame_seq) {
    log_info("INIT GP");
    log_info("DISPLAY GP AT 100 100");
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    log_info("SET POS GP 150 150");
    set_pos_gp(&asteroid, 150, 150);
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    if (get_x_gp(asteroid) < 0) {
      set_pos_gp(&asteroid, 150, 150);
    } else {
      log_info("MOVE GP -1 -1");
      move_gp(&asteroid, -1, -1);
    }
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    log_info("GET X AND Y GP");
    set_pos_gpp(&asteroid, 181, 57);
    log_short("X", get_x_gp(asteroid));
    log_short("Y", get_y_gp(asteroid));
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    log_info("HIDE GP");
    hide_gp(&asteroid);
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    log_info("SHOW GP");
    show_gp(&asteroid);
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
    log_info("DESTROY GP");
    destroy_gp(&asteroid);
  }
  frame_seq += accumulator;
  if (get_frame_counter() >= (frame_seq - accumulator)) {
    log_info("TEST GP END");
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
