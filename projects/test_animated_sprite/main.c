#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

#define animated_sprite_move(animated_sprite, x_offset, y_offset) aSpriteMove(animated_sprite.as, x_offset, y_offset)

Animated_Sprite player;

int main(void) {
  gpu_init();
  animated_sprite_init(&player, &player_sprite, &player_sprite_Palettes);
  animated_sprite_display(&player, 100, 100, PLAYER_SPRITE_ANIM_IDLE);
  while(1) {
    WAIT_VBL
    logger_init();
    animated_sprite_move(&player, 1, 0);
    animated_sprite_animate(&player);
    SCClose();
  };
  SCClose();
  return 0;
}
