#include <neocore.h>
#include "externs.h"

static GFX_Animated_Sprite_Physic player;
static GFX_Picture_Physic asteroid;

int main(void) {
  init_gpu();
  init_gfx_animated_sprite_physic(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    10,
    10,
    0,
    0
  );
  init_gfx_picture_physic(
    &asteroid,
    &asteroid_sprite,
    &asteroid_sprite_Palettes,
    (asteroid_sprite.tileWidth MULT8),
    32,
    0,
    0,
    AUTOBOX
  );
  display_gfx_animated_sprite_physic(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  display_gfx_picture_physic(&asteroid, 100, 100);

  while(1) {
    wait_vbl();
    update_joypad(0);
    if (joypad_is_left(0) && get_x_gfx_animated_sprite_physic(player) > 0) { move_gfx_animated_sprite_physic(&player, -1, 0); }
    if (joypad_is_right(0) && get_x_gfx_animated_sprite_physic(player) < 280) { move_gfx_animated_sprite_physic(&player, 1, 0); }

    if (joypad_is_up(0) && get_y_gfx_animated_sprite_physic(player) > 0) {
      move_gfx_animated_sprite_physic(&player, 0, -1);
      set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (joypad_is_down(0) && get_y_gfx_animated_sprite_physic(player) < 200) {
      move_gfx_animated_sprite_physic(&player, 0, 1);
      set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!joypad_is_down(0) && !joypad_is_up(0)) { set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_IDLE); }

    if (collide_box(&player.box, &asteroid.box)) {
      if (get_frame_counter() % 20) { hide_gfx_animated_sprite_physic(&player); } else { show_gfx_animated_sprite_physic(&player); }
    } else { show_gfx_animated_sprite_physic(&player);}

    update_animation_gfx_animated_sprite_physic(&player);

    close_vbl();
  };
  close_vbl();
  return 0;
}
