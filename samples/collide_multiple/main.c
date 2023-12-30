#include <neocore.h>
#include "externs.h"

#define ASTEROID_MAX  10

static GFX_Animated_Sprite_Physic player;
static GFX_Picture_Physic asteroids[ASTEROID_MAX];
static Box *asteroids_box[ASTEROID_MAX];

int main(void) {
  BYTE i = 0;
  init_gpu();
  init_gfx_animated_sprite_physic(&player, &player_sprite, &player_sprite_Palettes, 48, 16, 0, 0);
  display_gfx_animated_sprite_physic(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  for (i = 0; i < ASTEROID_MAX; i++) {
    init_gfx_picture_physic(&asteroids[i], &asteroid_sprite, &asteroid_sprite_Palettes, 8, 8, 0, 0, AUTOBOX);
    display_gfx_picture_physic(&asteroids[i], RAND(300), RAND(200));
    asteroids_box[i] = &asteroids[i].box;
  }
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
    if (!joypad_is_down(0) && !joypad_is_up(0)) set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_IDLE);

     if (collide_boxes(&player.box, asteroids_box, ASTEROID_MAX)) {
      if (get_frame_counter() % 20) { hide_gfx_animated_sprite_physic(&player); } else { show_gfx_animated_sprite_physic(&player); }
     } else { show_gfx_animated_sprite_physic(&player); }
    update_animation_gfx_animated_sprite_physic(&player);
    close_vbl();
  };
  close_vbl();
  return 0;
}
