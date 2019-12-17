#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

Animated_Sprite_Physic player;

int main(void) {
  gpu_init();
  animated_sprite_physic_init(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    16,
    16,
    0,
    0
  );

  animated_sprite_physic_display(
    &player,
    100,
    100,
    PLAYER_SPRITE_ANIM_IDLE
  );

  flash_init(&player.animated_sprite.flash, 10, 10);

  while(1) {
    WAIT_VBL
    logger_init();
    animated_sprite_animate(&player.animated_sprite);
    logger_box("BOX : ", &player.box);
    animated_sprite_physic_flash(&player);
    // animated_sprite_physic_move(&player, 1, 0);
    // animated_sprite_physic_shrunk(&player, shrunk_forge(0x5, 0xFB));
    // animated_sprite_physic_set_position(&player, 10, 10);

    SCClose();
  };
  SCClose();
  return 0;
}
