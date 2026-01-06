#include <neocore.h>
#include <math.h>
#include "externs.h"

static GFX_Scroller background;
static Position position;

int main(void) {
  nc_gfx_init_and_display_scroller(
    &background,
    background_sprite_scrl_rom.scrollerInfo,
    background_sprite_scrl_rom.paletteInfo,
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
    if (nc_joypad_is_start(0) & nc_joypad_is_a(0)) {
      nc_gfx_destroy_scroller(&background);
    }
  };

  return 0;
}
