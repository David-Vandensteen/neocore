#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

static void init();
static void display();
static void update();

static BOOL k7_direction = false;

static Image k7, play, next, stop;
static Scroller spectrum02;
static BYTE track_num = 2;

static void init() {
  cdda_play(track_num);
  gpu_init();
  scroller_init(&spectrum02, &spectrum02_sprite, &spectrum02_sprite_Palettes);
  image_init(&k7, &k7_sprite, &k7_sprite_Palettes);
  image_init(&play, &play_sprite, &play_sprite_Palettes);
  image_init(&stop, &stop_sprite, &stop_sprite_Palettes);
  image_init(&next, &next_sprite, &next_sprite_Palettes);
}

static void display() {
  scroller_display(&spectrum02, 0, 0);
  image_display(&k7, 30, 30);
  image_display(&play, 60, 180);
  image_display(&stop, 90, 180);
  image_display(&next, 120, 180);
}

static void update() {
  logger_init();
  joypad_update_edge();
  logger_byte("TRACK NUMBER : ", track_num);
  if (DAT_frameCounter % 2 == 0) {
    scroller_move(&spectrum02, 1, 0);
    if (spectrum02.s.scrlPosX > 960) scroller_set_position(&spectrum02, 0, spectrum02.s.scrlPosY);
  }
  if (DAT_frameCounter % 5 == 0) {
    if (k7_direction) {
      image_move(&k7, 1, 0);
    } else {
      image_move(&k7, -1, 0);
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
    SCClose();
  };
  SCClose();
  return 0;
}
