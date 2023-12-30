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
  Vec2short position_spectrum02;
  Vec2short position_k7;

  position_spectrum02 = get_position_gfx_scroller(spectrum02);
  position_k7 = get_position_gfx_picture(k7);

  init_log();
  update_joypad_edge(0);
  log_byte("AUDIO TRACK : ", track_num - 1);
  if (get_frame_counter() % 2 == 0) {
    move_gfx_scroller(&spectrum02, 1, 0);
    if (position_spectrum02.x > 960) set_position_gfx_scroller(&spectrum02, 0, position_spectrum02.y);
  }
  if (get_frame_counter() % 5 == 0) {
    if (k7_direction) {
      move_gfx_picture(&k7, 1, 0);
    } else {
      move_gfx_picture(&k7, -1, 0);
    }
  }
  if (position_k7.x > 50) k7_direction = false;
  if (position_k7.x < 40) k7_direction = true;
  if (joypad_is_left(0) && track_num > 2) play_cdda(--track_num);
  if (joypad_is_right(0) && track_num < 5) play_cdda(++track_num);
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
