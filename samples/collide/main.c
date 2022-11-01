#include <neocore.h>
#include "externs.h"

static GFX_Animated_Sprite_Physic player;
static GFX_Image_Physic asteroid;

int main(void) {
  init_gpu();
  init_gasp(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    10,
    10,
    0,
    0
  );
  init_gip(
    &asteroid,
    &asteroid_sprite,
    &asteroid_sprite_Palettes,
    (asteroid_sprite.tileWidth MULT8),
    32,
    0,
    0,
    AUTOBOX
  );
  display_gasp(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  display_gip(&asteroid, 100, 100);

  while(1) {
    wait_vbl();
    update_joypad();
    if (joypad_is_left() && get_x_gasp(player) > 0) { move_gasp(&player, -1, 0); }
    if (joypad_is_right() && get_x_gasp(player) < 280) { move_gasp(&player, 1, 0); }

    if (joypad_is_up() && get_y_gasp(player) > 0) {
      move_gasp(&player, 0, -1);
      set_animation_gasp(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (joypad_is_down() && get_y_gasp(player) < 200) {
      move_gasp(&player, 0, 1);
      set_animation_gasp(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!joypad_is_down() && !joypad_is_up()) { set_animation_gasp(&player, PLAYER_SPRITE_ANIM_IDLE); }

    if (box_collide(&player.box, &asteroid.box)) init_flash_gasp(&player, true, 10, 10);

    update_flash_gasp(&player);
    animate_gasp(&player);

    close_vbl();
  };
  close_vbl();
  return 0;
}
