#include <neocore.h>
#include <math.h>
#include "externs.h"

GFX_Animated_Sprite player;

int main(void) {
  init_gpu();
  init_gas(&player, &player_sprite, &player_sprite_Palettes);
  init_flash_gas(&player, true, 10, 10);
  display_gas(&player, 100, 100, PLAYER_SPRITE_ANIM_IDLE);
  shrunk(player.as.baseSprite, player.si->maxWidth, shrunk_forge(0x5, 0xFF));
  while(1) {
    wait_vbl();
    init_logger();
    animate_gas(&player);
    update_flash_gas(&player);
    logger_animated_sprite("PLAYER", &player);
    close_vbl();
  };
  close_vbl();
  return 0;
}
