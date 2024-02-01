#include <neocore.h>
#include "externs.h"

#define ASTEROID_MAX  10

static GFX_Animated_Sprite_Physic player;
static GFX_Picture_Physic asteroids[ASTEROID_MAX];
static Box *asteroids_box[ASTEROID_MAX];

int main(void) {
  BYTE i = 0;
  nc_init_gfx_animated_sprite_physic(&player, &player_sprite, &player_sprite_Palettes, 48, 16, 0, 0);
  nc_display_gfx_animated_sprite_physic(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);

  for (i = 0; i < ASTEROID_MAX; i++) {
    nc_init_gfx_picture_physic(&asteroids[i], &asteroid_sprite, &asteroid_sprite_Palettes, 8, 8, 0, 0, AUTOBOX);
    nc_display_gfx_picture_physic(&asteroids[i], nc_random(300), nc_random(200));
    asteroids_box[i] = &asteroids[i].box;
  }

  while(1) {
    Vec2short position;
    nc_update();
    position = nc_get_position_gfx_animated_sprite_physic(player);

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
    if (!nc_joypad_is_down(0) && !nc_joypad_is_up(0)) nc_set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_IDLE);

     if (nc_collide_boxes(&player.box, asteroids_box, ASTEROID_MAX)) {
      if (nc_get_frame_counter() % 20) { nc_hide_gfx_animated_sprite_physic(&player); } else { nc_show_gfx_animated_sprite_physic(&player); }
     } else { nc_show_gfx_animated_sprite_physic(&player); }
    nc_update_animation_gfx_animated_sprite_physic(&player);
  };

  return 0;
}
