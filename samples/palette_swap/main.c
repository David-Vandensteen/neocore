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
  init_gpu();
  init_gp(&logo, &logo_sprite, &logo_sprite_Palettes);
  display_gp(&logo, 50, 100);
  logo_swap_palette.palCount = logo.pali->palCount;

  for (i = 0; i < (logo.pali->palCount MULT16); i++) { logo_swap_palette.data[i] = RAND(0xFFFF); }
  logo_swap_palette.data[1] = 0x0000;

  while(1) {
    wait_vbl();
    init_log();
    if (get_frame_counter() % 8 == 0) {
      for (i = 0; i < (logo.pali->palCount MULT16); i++) { logo_swap_palette.data[i] = RAND(0xFFFF); }
      logo_swap_palette.data[1] = 0x0000;
      palJobPut(logo.pic.basePalette, logo_swap_palette.palCount, logo_swap_palette.data);
    }
    close_vbl();
  };
  close_vbl();
  return 0;
}
