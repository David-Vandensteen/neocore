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
  nc_play_cdda(track_num);
  nc_init_gfx_scroller(&spectrum02, &spectrum02_sprite, &spectrum02_sprite_Palettes);
  nc_init_gfx_picture(&k7, &k7_sprite, &k7_sprite_Palettes);
  nc_set_joypad_edge_mode(true);
}

static void display() {
  nc_display_gfx_scroller(&spectrum02, 0, 0);
  nc_display_gfx_picture(&k7, 30, 30);
}

static void update() {
  Vec2short position_spectrum02;
  Vec2short position_k7;

  position_spectrum02 = nc_get_position_gfx_scroller(spectrum02);
  position_k7 = nc_get_position_gfx_picture(k7);

  nc_init_log();
  nc_log_byte("AUDIO TRACK : ", track_num - 1);
  if (nc_get_frame_counter() % 2 == 0) {
    nc_move_gfx_scroller(&spectrum02, 1, 0);
    if (position_spectrum02.x > 960) nc_set_position_gfx_scroller(&spectrum02, 0, position_spectrum02.y);
  }
  if (nc_get_frame_counter() % 5 == 0) {
    if (k7_direction) {
      nc_move_gfx_picture(&k7, 1, 0);
    } else {
      nc_move_gfx_picture(&k7, -1, 0);
    }
  }
  if (position_k7.x > 50) k7_direction = false;
  if (position_k7.x < 40) k7_direction = true;
  if (nc_joypad_is_left(0) && track_num > 2) nc_play_cdda(--track_num);
  if (nc_joypad_is_right(0) && track_num < 5) nc_play_cdda(++track_num);
}

int main(void) {
  init();
  display();

  while(1) {
    nc_update();;
    update();
  };

  return 0;
}
