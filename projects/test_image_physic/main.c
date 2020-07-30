#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

Image_Physic planet04;

int main(void) {
  GPU_INIT
  image_physic_init(&planet04, &planet04_sprite, &planet04_sprite_Palettes, 10, 10, 10, 10);
  flash_init(&planet04.image.flash, true, 10, 10);
  image_physic_display(&planet04, 100, 100);
  // image_physic_shrunk(&planet04, shrunk_forge(0x9, 0xF));
  while(1) {
    WAIT_VBL
    logger_init();
    image_physic_flash(&planet04);
    // image_physic_move(&planet04, 1, 0);
    // image_physic_set_position(&planet04, 10, 10);
    SCClose();
  };
  SCClose();
  return 0;
}
