#include <neocore.h>
#include <math.h>
#include "externs.h"

static GFX_Scroller background;

int main(void) {
  nc_init_gfx_scroller(&background, &background_sprite, &background_sprite_Palettes);
  nc_display_gfx_scroller(&background, 0, 0);

  while(1) {
    nc_update();
    nc_move_gfx_scroller(&background, 1, 0);

    if (nc_get_position_gfx_scroller(background).x > 512) {
      nc_set_position_gfx_scroller(&background, 0, 0);
    }
  };

  return 0;
}
