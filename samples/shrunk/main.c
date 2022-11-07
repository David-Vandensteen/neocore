#include <neocore.h>
#include "externs.h"

int main(void) {
  GFX_Picture logo1, logo2, logo3;
  BYTE logo1_shrunk_x = 0;
  BYTE logo2_shrunk_y = 0;
  init_gpu();
  init_gp(&logo1, &logo_sprite, &logo_sprite_Palettes);
  init_gp(&logo2, &logo_sprite, &logo_sprite_Palettes);
  init_gp(&logo3, &logo_sprite, &logo_sprite_Palettes);
  init_log();
  log_info("HORIZONTAL SHRUNK");
  init_gp(&logo1, &logo_sprite, &logo_sprite_Palettes);
  init_gp(&logo2, &logo_sprite, &logo_sprite_Palettes);
  init_gp(&logo3, &logo_sprite, &logo_sprite_Palettes);
  display_gp(&logo1, 10, 20);
  set_pos_log(1, 10);
  log_info("VERTICAL SHRUNK");
  display_gp(&logo2, 10, 80);
  set_pos_log(1, 19);
  log_info("PROPORTIONAL SHRUNK");
  display_gp(&logo3, 10, 150);

  while(1) {
    wait_vbl();
    if (DAT_frameCounter % 5 == 0) logo1_shrunk_x++;
    logo2_shrunk_y +=3;

    shrunk(logo1.pic.baseSprite, logo1.pic.info->tileWidth, shrunk_forge(logo1_shrunk_x, 0xFF));
    shrunk(logo2.pic.baseSprite, logo2.pic.info->tileWidth, shrunk_forge(0xF, logo2_shrunk_y));
    shrunk(logo3.pic.baseSprite, logo3.pic.info->tileWidth, get_shrunk_proportional_table(DAT_frameCounter & SHRUNK_TABLE_PROP_SIZE)); // todo (minor) - rename SHRUNK_PROPORTIONAL_TABLE_SIZE


    /* neocore provide a precalculated table for keep "aspect ratio" */
    close_vbl();
  };
  close_vbl();
  return 0;
}
