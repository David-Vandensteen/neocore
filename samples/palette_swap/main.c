#include <neocore.h>
#include <math.h>
#include "externs.h"

int main(void) {
  static GFX_Picture logo;
  static paletteInfo logo_swap_palette;
  BYTE i = 0;

  nc_gfx_init_and_display_picture(
    &logo,
    logo_sprite_pict_rom.pictureInfo,
    logo_sprite_pict_rom.paletteInfo,
    50, 100
  );
  logo_swap_palette.count = logo.paletteInfoDAT->count;

  for (i = 0; i < nc_math_bitwise_multiplication_16(logo.paletteInfoDAT->count); i++) { logo_swap_palette.data[i] = nc_math_random(0xFFFF); }
  logo_swap_palette.data[1] = 0x0000;

  while(1) {
    nc_gpu_update();
    nc_log_init();
    if (nc_gpu_get_frame_number() % 8 == 0) {
      for (i = 0; i < nc_math_bitwise_multiplication_16(logo.paletteInfoDAT->count); i++) { logo_swap_palette.data[i] = nc_math_random(0xFFFF); }
      logo_swap_palette.data[1] = 0x0000;
      palJobPut(logo.pictureDAT.basePalette, logo_swap_palette.count, logo_swap_palette.data);
    }
  };

  return 0;
}
