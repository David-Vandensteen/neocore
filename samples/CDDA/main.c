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
  cdda_play(track_num);
  init_gpu();
  init_gs(&spectrum02, &spectrum02_sprite, &spectrum02_sprite_Palettes);
  init_gp(&k7, &k7_sprite, &k7_sprite_Palettes);
}

static void display() {
  display_gs(&spectrum02, 0, 0);
  display_gp(&k7, 30, 30);
}

static void update() {
  init_logger();
  update_joypad_edge();
  logger_byte("AUDIO TRACK : ", track_num - 1);
  if (DAT_frameCounter % 2 == 0) {
    move_gs(spectrum02, 1, 0);
    if (get_x_gs(spectrum02) > 960) set_x_gs(&spectrum02, 0);
  }
  if (DAT_frameCounter % 5 == 0) {
    if (k7_direction) {
      move_gp(&k7, 1, 0);
    } else {
      move_gp(&k7, -1, 0);
    }
  }
  if (k7.pic.posX > 50) k7_direction = false;
  if (k7.pic.posX < 40) k7_direction = true;
  if (joypad_is_left() && track_num > 2) cdda_play(--track_num);
  if (joypad_is_right() && track_num < 4) cdda_play(++track_num);
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
