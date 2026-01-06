#include <neocore.h>
#include "externs.h"

int main(void) {
  static GFX_Picture logo1, logo2, logo3;
  static BYTE logo1_shrunk_x = 0;
  static BYTE logo2_shrunk_y = 0;

  nc_gfx_init_picture(&logo1, logo_sprite_pict_rom.pictureInfo, logo_sprite_pict_rom.paletteInfo);
  nc_gfx_init_picture(&logo2, logo_sprite_pict_rom.pictureInfo, logo_sprite_pict_rom.paletteInfo);
  nc_gfx_init_picture(&logo3, logo_sprite_pict_rom.pictureInfo, logo_sprite_pict_rom.paletteInfo);
  nc_log_init();
  nc_log_info_line("HORIZONTAL SHRUNK");
  nc_gfx_init_picture(&logo1, logo_sprite_pict_rom.pictureInfo, logo_sprite_pict_rom.paletteInfo);
  nc_gfx_init_picture(&logo2, logo_sprite_pict_rom.pictureInfo, logo_sprite_pict_rom.paletteInfo);
  nc_gfx_init_picture(&logo3, logo_sprite_pict_rom.pictureInfo, logo_sprite_pict_rom.paletteInfo);
  nc_gfx_display_picture(&logo1, 10, 20);
  nc_log_set_position(1, 10);
  nc_log_info("VERTICAL SHRUNK");
  nc_gfx_display_picture(&logo2, 10, 80);
  nc_log_set_position(1, 19);
  nc_log_info("PROPORTIONAL SHRUNK");
  nc_gfx_display_picture(&logo3, 10, 150);

  while(1) {
    nc_gpu_update();
    if (nc_gpu_get_frame_number() % 5 == 0) logo1_shrunk_x++;
    logo2_shrunk_y +=3;

    nc_shrunk(logo1.pictureDAT.baseSprite, logo1.pictureDAT.info->tileWidth, nc_shrunk_forge(logo1_shrunk_x, 0xFF));
    nc_shrunk(logo2.pictureDAT.baseSprite, logo2.pictureDAT.info->tileWidth, nc_shrunk_forge(0xF, logo2_shrunk_y));
    nc_shrunk(logo3.pictureDAT.baseSprite, logo3.pictureDAT.info->tileWidth, nc_gpu_get_shrunk_proportional_table(nc_gpu_get_frame_number() & SHRUNK_TABLE_PROP_SIZE)); // todo (minor) - rename SHRUNK_PROPORTIONAL_TABLE_SIZE

    /* neocore provide a precalculated table to keep "aspect ratio" */
  };

  return 0;
}
