#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

GFX_Animated_Sprite player;

int main(void) {
  gpu_init();
  gfx_animated_sprite_init(&player, &player_sprite, &player_sprite_Palettes);
  flash_init(&player.flash, true, 10, 10);
  gfx_animated_sprite_display(&player, 100, 100, PLAYER_SPRITE_ANIM_IDLE);
  shrunk(player.as.baseSprite, player.si->maxWidth, shrunk_forge(0x5, 0xFF));
  while(1) {
    wait_vbl();
    logger_init();
    gfx_animated_sprite_animate(&player);
    gfx_animated_sprite_flash(&player);
    logger_animated_sprite("PLAYER", &player);
    SCClose();
  };
  SCClose();
  return 0;
}
