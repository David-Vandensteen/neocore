#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

Animated_Sprite player;

int main(void) {
  GPU_INIT
  animated_sprite_init(&player, &player_sprite, &player_sprite_Palettes);
  flash_init(&player.flash, 10, 10);
  animated_sprite_display(&player, 100, 100, PLAYER_SPRITE_ANIM_IDLE);
  shrunk(player.as.baseSprite, player.si->maxWidth, shrunk_forge(0x5, 0xFF));
  while(1) {
    WAIT_VBL
    logger_init();
    // animated_sprite_move(&player, 1, 0);
    // animated_sprite_set_position(&player, 10, 10);
    animated_sprite_animate(&player);
    animated_sprite_flash(&player);
    logger_animated_sprite("PLAYER", &player);
    SCClose();
  };
  SCClose();
  return 0;
}
