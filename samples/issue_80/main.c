#include <neocore.h>
#include "externs.h"

static GFX_Picture background;

int main(void) {
  nc_init_display_gfx_picture(
    &background,
    &background_asset,
    &background_asset_Palettes,
    0,
    0)
  ;

  while(1) {
    nc_update();
  };

  return 0;
}
