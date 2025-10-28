#include <neocore.h>
#include "externs.h"

static GFX_Animated_Physic_Sprite player;
static GFX_Physic_Picture asteroid;

int main(void) {
  nc_gfx_init_and_display_animated_physic_sprite(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    10,
    10,
    10,
    10,
    0,
    0,
    PLAYER_SPRITE_ANIM_IDLE
  );

  nc_gfx_init_and_display_physic_picture(
    &asteroid,
    &asteroid_sprite,
    &asteroid_sprite_Palettes,
    100,
    100,
    32,
    32,
    0,
    0,
    AUTOBOX
  );

  while(1) {
    Position position;
    nc_gpu_update();
    nc_gfx_get_animated_physic_sprite_position(&player, &position);
    if (nc_joypad_is_left(0) && position.x > 0) { nc_gfx_move_animated_physic_sprite(&player, -1, 0); }
    if (nc_joypad_is_right(0) && position.x < 280) { nc_gfx_move_animated_physic_sprite(&player, 1, 0); }

    if (nc_joypad_is_up(0) && position.y > 0) {
      nc_gfx_move_animated_physic_sprite(&player, 0, -1);
      nc_gfx_set_animated_sprite_animation_physic(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (nc_joypad_is_down(0) && position.y < 200) {
      nc_gfx_move_animated_physic_sprite(&player, 0, 1);
      nc_gfx_set_animated_sprite_animation_physic(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!nc_joypad_is_down(0) && !nc_joypad_is_up(0)) { nc_gfx_set_animated_sprite_animation_physic(&player, PLAYER_SPRITE_ANIM_IDLE); }

    if (nc_physic_collide_box(&player.box, &asteroid.box)) {
      if ((nc_gpu_get_frame_number() % 20) < 10) { nc_gfx_hide_animated_physic_sprite(&player); } else { nc_gfx_show_animated_physic_sprite(&player); }
    } else { nc_gfx_show_animated_physic_sprite(&player);}

    nc_gfx_update_animated_physic_sprite_animation(&player);
  };

  return 0;
}
