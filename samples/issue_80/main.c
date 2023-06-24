#include <neocore.h>
#include "externs.h"

int main(void) {
  GFX_Picture background;
  init_gpu();
  init_gp(&background, &background_asset, &background_asset_Palettes);

  display_gp(&background, 0, 0);
  while(1) {
    wait_vbl();
    close_vbl();
  };
  close_vbl();
  return 0;
}
