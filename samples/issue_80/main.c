#include <neocore.h>
#include "externs.h"

int main(void) {
  GFX_Picture background;

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
