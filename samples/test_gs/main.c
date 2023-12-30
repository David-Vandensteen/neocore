#include <neocore.h>
#include <math.h>
#include "externs.h"

static GFX_Scroller background;

int main(void) {
  init_gpu();
  init_gfx_scroller(&background, &background_sprite, &background_sprite_Palettes);
  display_gfx_scroller(&background, 0, 0);
  while(1) {
    wait_vbl();
    move_gfx_scroller(&background, 1, 0);
    if (get_position_gfx_scroller(background).x > 512) {
      set_position_gfx_scroller(&background, 0, 0);
    }
    close_vbl();
  };
  close_vbl();
  return 0;
}
