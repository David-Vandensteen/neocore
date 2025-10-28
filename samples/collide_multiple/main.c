#include <neocore.h>
#include "externs.h"

#define ASTEROID_MAX  10

static GFX_Animated_Physic_Sprite player;
static GFX_Physic_Picture asteroids[ASTEROID_MAX];
static Box *asteroids_box[ASTEROID_MAX];

int main(void);

int main(void) {
  BYTE i = 0;

  nc_gfx_init_and_display_animated_physic_sprite(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    48,
    16,
    0,
    0,
    0,
    0,
    PLAYER_SPRITE_ANIM_IDLE
  );

  for (i = 0; i < ASTEROID_MAX; i++) {
    nc_gfx_init_and_display_physic_picture(
      &asteroids[i],
      &asteroid_sprite,
      &asteroid_sprite_Palettes,
      nc_math_random(300),
      nc_math_random(200),
      8,
      8,
      0,
      0,
      AUTOBOX
    );
    asteroids_box[i] = &asteroids[i].box;
  }

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
    if (!nc_joypad_is_down(0) && !nc_joypad_is_up(0)) nc_gfx_set_animated_sprite_animation_physic(&player, PLAYER_SPRITE_ANIM_IDLE);

     if (nc_physic_collide_boxes(&player.box, asteroids_box, ASTEROID_MAX)) {
      if ((nc_gpu_get_frame_number() % 20) < 10) { nc_gfx_hide_animated_physic_sprite(&player); } else { nc_gfx_show_animated_physic_sprite(&player); }
     } else { nc_gfx_show_animated_physic_sprite(&player); }
    nc_gfx_update_animated_physic_sprite_animation(&player);
  };

  return 0;
}
