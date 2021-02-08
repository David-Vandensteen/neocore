#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

Image planet04;

int main(void) {
  gpu_init();
  image_init(&planet04, &planet04_sprite, &planet04_sprite_Palettes);
  flash_init(&planet04.flash, true, 10, 10);
  image_display(&planet04, 100, 100);
  // shrunk(planet04.pic.baseSprite, planet04.pi->tileWidth, shrunk_forge(0x5, 0xF));
  while(1) {
    wait_vbl();
    logger_init();
    image_flash(&planet04);
    // image_move(&planet04, 1, 0);
    // image_set_position(&planet04, 10, 10);
    SCClose();
  };
  SCClose();
  return 0;
}
