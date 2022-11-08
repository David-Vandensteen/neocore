#include <neocore.h>
#include "externs.h"

#define ASTEROID_MAX  10

static GFX_Animated_Sprite_Physic player;
static GFX_Picture_Physic asteroids[ASTEROID_MAX];
static Box *asteroids_box[ASTEROID_MAX];

int main(void) {
  BYTE i = 0;
  init_gpu();
  init_gasp(&player, &player_sprite, &player_sprite_Palettes, 48, 16, 0, 0);
  display_gasp(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  for (i = 0; i < ASTEROID_MAX; i++) {
    init_gpp(&asteroids[i], &asteroid_sprite, &asteroid_sprite_Palettes, 8, 8, 0, 0, AUTOBOX);
    display_gpp(&asteroids[i], RAND(300), RAND(200));
    asteroids_box[i] = &asteroids[i].box;
  }
  while(1) {
    wait_vbl();
    update_joypad();

    if (joypad_is_left() && get_x_gasp(player) > 0) { move_gasp(&player, -1, 0); }
    if (joypad_is_right() && get_x_gasp(player) < 280) { move_gasp(&player, 1, 0); }
    if (joypad_is_up() && get_y_gasp(player) > 0) {
      move_gasp(&player, 0, -1);
      set_anim_gasp(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (joypad_is_down() && get_y_gasp(player) < 200) {
      move_gasp(&player, 0, 1);
      set_anim_gasp(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!joypad_is_down() && !joypad_is_up()) set_anim_gasp(&player, PLAYER_SPRITE_ANIM_IDLE);

     if (collide_boxes(&player.box, asteroids_box, ASTEROID_MAX)) {
      if (get_frame_counter() % 20) { hide_gasp(&player); } else { show_gasp(&player); }
     } else { show_gasp(&player); }
    update_anim_gasp(&player);
    close_vbl();
  };
  close_vbl();
  return 0;
}
