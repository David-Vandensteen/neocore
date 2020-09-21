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

static void init() {
  cdda_play(2);
  GPU_INIT
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
  // image_move(&k7, -1, 0);
  // image_set_position(&k7, (get_sin((sin_index DIV8) & 127)), k7.pic.posY);
}

int main(void) {
  init();
  display();
  while(1) {
    WAIT_VBL
    update();
    SCClose();
  };
  SCClose();
  return 0;
}
