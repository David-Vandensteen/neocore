#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

static Scroller background;

int main(void) {
  GPU_INIT
  scroller_init(&background, &background_sprite, &background_sprite_Palettes);
  scroller_display(&background, 0, 0);
  while(1) {
    WAIT_VBL
    scroller_move(&background, 1, 0);
    if (background.s.scrlPosX > 512) scroller_set_position(&background, 0, 0);
    SCClose();
  };
  SCClose();
  return 0;
}
