#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

static void init();
static void display();
static void update();

static BOOL k7_direction = false;

static GFX_Image k7;
static GFX_Scroller spectrum02;
static BYTE track_num = 2;

static void init() {
  cdda_play(track_num);
  gpu_init();
  gfx_scroller_init(&spectrum02, &spectrum02_sprite, &spectrum02_sprite_Palettes);
  gfx_image_init(&k7, &k7_sprite, &k7_sprite_Palettes);
}

static void display() {
  gfx_scroller_display(&spectrum02, 0, 0);
  gfx_image_display(&k7, 30, 30);
}

static void update() {
  logger_init();
  joypad_update_edge();
  logger_byte("AUDIO TRACK : ", track_num - 1);
  if (DAT_frameCounter % 2 == 0) {
    gfx_scroller_move(&spectrum02, 1, 0);
    if (spectrum02.s.scrlPosX > 960) gfx_scroller_set_position(&spectrum02, 0, spectrum02.s.scrlPosY);
  }
  if (DAT_frameCounter % 5 == 0) {
    if (k7_direction) {
      gfx_image_move(&k7, 1, 0);
    } else {
      gfx_image_move(&k7, -1, 0);
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
