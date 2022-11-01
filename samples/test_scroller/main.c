#include <neocore.h>
#include <math.h>
#include "externs.h"

static GFX_Scroller background;

int main(void) {
  init_gpu();
  init_gs(&background, &background_sprite, &background_sprite_Palettes);
  display_gs(&background, 0, 0);
  while(1) {
    wait_vbl();
    move_gs(&background, 1, 0);
    if (get_x_gs(background) > 512) set_pos_gs(&background, 0, 0);
    close_vbl();
  };
  close_vbl();
  return 0;
}
