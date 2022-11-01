#include <neocore.h>
#include <math.h>
#include "externs.h"

GFX_Animated_Sprite_Physic player;

int main(void) {
  init_gpu();
  init_gasp(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    16,
    16,
    0,
    0
  );

  display_gasp(
    &player,
    100,
    100,
    PLAYER_SPRITE_ANIM_IDLE
  );

  init_flash_gasp(&player, true, 10, 10);

  while(1) {
    wait_vbl();
    init_logger();
    animate_gasp(&player);
    logger_box("BOX : ", &player.box);
    update_flash_gasp(&player);
    if (DAT_frameCounter == 500) {
      // animated_sprite_physic_destroy(&player);
      // animated_sprite_physic_hide(&player);
    }
    // animated_sprite_physic_move(&player, 1, 0);
    // animated_sprite_physic_shrunk(&player, shrunk_forge(0x5, 0xFB));
    // animated_sprite_physic_set_position(&player, 10, 10);

    close_vbl();
  };
  close_vbl();
  return 0;
}
