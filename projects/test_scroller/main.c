#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

static Scroller background;

int main(void) {
  gpu_init();
  palette_disable_auto_index(); // todo (major) - hummm, why ?
  scroller_init(&background, &background_sprite, &background_sprite_Palettes);
  scroller_display(&background, 0, 0);
  while(1) {
    WAIT_VBL
    scroller_move(&background, 1, 0);
    SCClose();
  };
  SCClose();
  return 0;
}
