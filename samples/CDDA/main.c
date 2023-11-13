#include <neocore.h>
#include <math.h>
#include "externs.h"

static void init();
static void display();
static void update();

static BOOL k7_direction = false;

static GFX_Picture k7;
static GFX_Scroller spectrum02;
static BYTE track_num = 2;

static void init() {
  play_cdda(track_num);
  init_gpu();
  init_gfx_scroller(&spectrum02, &spectrum02_sprite, &spectrum02_sprite_Palettes);
  init_gfx_picture(&k7, &k7_sprite, &k7_sprite_Palettes);
}

static void display() {
  display_gfx_scroller(&spectrum02, 0, 0);
  display_gfx_picture(&k7, 30, 30);
}

static void update() {
  init_log();
  update_joypad_edge_p1();
  log_byte("AUDIO TRACK : ", track_num - 1);
  if (get_frame_counter() % 2 == 0) {
    move_gfx_scroller(&spectrum02, 1, 0);
    if (get_x_gfx_scroller(spectrum02) > 960) set_x_gfx_scroller(&spectrum02, 0);
  }
  if (get_frame_counter() % 5 == 0) {
    if (k7_direction) {
      move_gfx_picture(&k7, 1, 0);
    } else {
      move_gfx_picture(&k7, -1, 0);
    }
  }
  if (get_x_gfx_picture(k7) > 50) k7_direction = false;
  if (get_x_gfx_picture(k7) < 40) k7_direction = true;
  if (joypad_p1_is_left() && track_num > 2) play_cdda(--track_num);
  if (joypad_p1_is_right() && track_num < 5) play_cdda(++track_num);
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
