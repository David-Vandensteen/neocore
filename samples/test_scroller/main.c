#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

static GFX_Scroller background;

int main(void) {
  gpu_init();
  gfx_scroller_init(&background, &background_sprite, &background_sprite_Palettes);
  gfx_scroller_display(&background, 0, 0);
  while(1) {
    wait_vbl();
    gfx_scroller_move(&background, 1, 0);
    if (background.s.scrlPosX > 512) gfx_scroller_set_position(&background, 0, 0);
    SCClose();
  };
  SCClose();
  return 0;
}
