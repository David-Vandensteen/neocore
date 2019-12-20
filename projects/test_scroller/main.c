#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

static Scroller background;

int main(void) {
  gpu_init();
  scroller_init(&background, &background_sprite, &background_sprite_Palettes);
  scroller_display(&background, 0, 0);
  BYTE i = 0;
  while(1) {
    WAIT_VBL
    i++;
    // scroller_move(&background, 1, 0);
    scrollerSetPos(&background.s, &background.s.scrlPosX + i, &background.s.scrlPosY);
    // if (&background.s.scrlPosX > 512) scroller_set_position(&background, 0, 0);
    SCClose();
  };
  SCClose();
  return 0;
}
