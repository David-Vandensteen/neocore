#include <neocore.h>
#include "externs.h"

NEOCORE_INIT

int main(void) {
  Image logo1, logo2, logo3;
  BYTE logo1_shrunk_x = 0;
  BYTE logo2_shrunk_y = 0;
  GPU_INIT
  image_init(&logo1, &logo_sprite, &logo_sprite_Palettes);
  image_init(&logo2, &logo_sprite, &logo_sprite_Palettes);
  image_init(&logo3, &logo_sprite, &logo_sprite_Palettes);
  logger_init();
  logger_info("HORIZONTAL SHRUNK");
  image_init(&logo1, &logo_sprite, &logo_sprite_Palettes);
  image_init(&logo2, &logo_sprite, &logo_sprite_Palettes);
  image_init(&logo3, &logo_sprite, &logo_sprite_Palettes);
  image_display(&logo1, 10, 20);
  logger_set_position(1, 10);
  logger_info("VERTICAL SHRUNK");
  image_display(&logo2, 10, 80);
  logger_set_position(1, 19);
  logger_info("PROPORTIONAL SHRUNK");
  image_display(&logo3, 10, 150);

  while(1) {
    WAIT_VBL
    if (DAT_frameCounter % 5 == 0) logo1_shrunk_x++;
    logo2_shrunk_y +=3;

    shrunk(logo1.pic.baseSprite, logo1.pic.info->tileWidth, shrunk_forge(logo1_shrunk_x, 0xFF));
    shrunk(logo2.pic.baseSprite, logo2.pic.info->tileWidth, shrunk_forge(0xF, logo2_shrunk_y));
    shrunk(logo3.pic.baseSprite, logo3.pic.info->tileWidth, get_shrunk_proportional_table(DAT_frameCounter & SHRUNK_TABLE_PROP_SIZE)); // todo (minor) - rename SHRUNK_PROPORTIONAL_TABLE_SIZE


    /* neocore provide a precalculated table for keep "aspect ratio" */
    SCClose();
  };
  SCClose();
  return 0;
}
