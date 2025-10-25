#include <neocore.h>
#include <math.h>
#include "externs.h"

static GFX_Scroller background;
static Position position;

int main(void) {
  nc_gfx_init_and_display_scroller(
    &background,
    &background_sprite,
    &background_sprite_Palettes,
    0,
    0
  );

  while(1) {
    nc_gpu_update();
    nc_gfx_move_scroller(&background, 1, 0);

    nc_gfx_get_scroller_position(&background, &position);
    if (position.x > 512) {
      nc_gfx_set_scroller_position(&background, 0, 0);
    }
  };

  return 0;
}
