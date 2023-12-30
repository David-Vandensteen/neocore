/*
  David Vandensteen
  2020
*/
#include <neocore.h>
#include <math.h>
#include "externs.h"

int main(void) {
  static GFX_Picture logo;
  static paletteInfo logo_swap_palette;
  BYTE i = 0;
  nc_init_gfx_picture(&logo, &logo_sprite, &logo_sprite_Palettes);
  nc_display_gfx_picture(&logo, 50, 100);
  logo_swap_palette.palCount = logo.paletteInfoDAT->palCount;

  for (i = 0; i < (logo.paletteInfoDAT->palCount MULT16); i++) { logo_swap_palette.data[i] = RAND(0xFFFF); }
  logo_swap_palette.data[1] = 0x0000;

  while(1) {
    nc_wait_vbl();
    nc_init_log();
    if (nc_get_frame_counter() % 8 == 0) {
      for (i = 0; i < (logo.paletteInfoDAT->palCount MULT16); i++) { logo_swap_palette.data[i] = RAND(0xFFFF); }
      logo_swap_palette.data[1] = 0x0000;
      palJobPut(logo.pictureDAT.basePalette, logo_swap_palette.palCount, logo_swap_palette.data);
    }
    nc_close_vbl();
  };
  nc_close_vbl();
  return 0;
}
