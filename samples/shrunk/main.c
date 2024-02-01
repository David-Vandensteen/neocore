#include <neocore.h>
#include "externs.h"

int main(void) {
  GFX_Picture logo1, logo2, logo3;
  BYTE logo1_shrunk_x = 0;
  BYTE logo2_shrunk_y = 0;

  nc_init_gfx_picture(&logo1, &logo_sprite, &logo_sprite_Palettes);
  nc_init_gfx_picture(&logo2, &logo_sprite, &logo_sprite_Palettes);
  nc_init_gfx_picture(&logo3, &logo_sprite, &logo_sprite_Palettes);
  nc_init_log();
  nc_log_info("HORIZONTAL SHRUNK");
  nc_init_gfx_picture(&logo1, &logo_sprite, &logo_sprite_Palettes);
  nc_init_gfx_picture(&logo2, &logo_sprite, &logo_sprite_Palettes);
  nc_init_gfx_picture(&logo3, &logo_sprite, &logo_sprite_Palettes);
  nc_display_gfx_picture(&logo1, 10, 20);
  nc_set_position_log(1, 10);
  nc_log_info("VERTICAL SHRUNK");
  nc_display_gfx_picture(&logo2, 10, 80);
  nc_set_position_log(1, 19);
  nc_log_info("PROPORTIONAL SHRUNK");
  nc_display_gfx_picture(&logo3, 10, 150);

  while(1) {
    nc_update();
    if (nc_get_frame_counter() % 5 == 0) logo1_shrunk_x++;
    logo2_shrunk_y +=3;

    nc_shrunk(logo1.pictureDAT.baseSprite, logo1.pictureDAT.info->tileWidth, nc_shrunk_forge(logo1_shrunk_x, 0xFF));
    nc_shrunk(logo2.pictureDAT.baseSprite, logo2.pictureDAT.info->tileWidth, nc_shrunk_forge(0xF, logo2_shrunk_y));
    nc_shrunk(logo3.pictureDAT.baseSprite, logo3.pictureDAT.info->tileWidth, nc_get_shrunk_proportional_table(nc_get_frame_counter() & SHRUNK_TABLE_PROP_SIZE)); // todo (minor) - rename SHRUNK_PROPORTIONAL_TABLE_SIZE

    /* neocore provide a precalculated table for keep "aspect ratio" */
  };

  return 0;
}
