#include <neocore.h>
#include "externs.h"

static GFX_Animated_Sprite_Physic player;
static GFX_Picture_Physic asteroid;

int main(void) {
  nc_init_gfx_animated_sprite_physic(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    10,
    10,
    0,
    0
  );
  nc_init_gfx_picture_physic(
    &asteroid,
    &asteroid_sprite,
    &asteroid_sprite_Palettes,
    (asteroid_sprite.tileWidth MULT8),
    32,
    0,
    0,
    AUTOBOX
  );
  nc_display_gfx_animated_sprite_physic(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  nc_display_gfx_picture_physic(&asteroid, 100, 100);

  while(1) {
    Vec2short position;
    nc_wait_vbl();
    position = nc_get_position_gfx_animated_sprite_physic(player);
    nc_update_joypad(0);
    if (nc_joypad_is_left(0) && position.x > 0) { nc_move_gfx_animated_sprite_physic(&player, -1, 0); }
    if (nc_joypad_is_right(0) && position.x < 280) { nc_move_gfx_animated_sprite_physic(&player, 1, 0); }

    if (nc_joypad_is_up(0) && position.y > 0) {
      nc_move_gfx_animated_sprite_physic(&player, 0, -1);
      nc_set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (nc_joypad_is_down(0) && position.y < 200) {
      nc_move_gfx_animated_sprite_physic(&player, 0, 1);
      nc_set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!nc_joypad_is_down(0) && !nc_joypad_is_up(0)) { nc_set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_IDLE); }

    if (nc_collide_box(&player.box, &asteroid.box)) {
      if (nc_get_frame_counter() % 20) { nc_hide_gfx_animated_sprite_physic(&player); } else { nc_show_gfx_animated_sprite_physic(&player); }
    } else { nc_show_gfx_animated_sprite_physic(&player);}

    nc_update_animation_gfx_animated_sprite_physic(&player);

    nc_close_vbl();
  };
  nc_close_vbl();
  return 0;
}
