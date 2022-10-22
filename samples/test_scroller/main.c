#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

static Scroller background;

int main(void) {
  gpu_init();
  scroller_init(&background, &background_sprite, &background_sprite_Palettes);
  scroller_display(&background, 0, 0);
  while(1) {
    wait_vbl();
    scroller_move(&background, 1, 0);
    if (background.s.scrlPosX > 512) scroller_set_position(&background, 0, 0);
    SCClose();
  };
  SCClose();
  return 0;
}
