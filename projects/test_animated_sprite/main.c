#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

Animated_Sprite player;

int main(void) {
  gpu_init();
  animated_sprite_init(&player, &player_sprite, &player_sprite_Palettes);
  animated_sprite_display(&player, 100, 100, PLAYER_SPRITE_ANIM_IDLE);
  while(1) {
    WAIT_VBL
    logger_init();
    animated_sprite_animate(&player);
    SCClose();
  };
  SCClose();
  return 0;
}
