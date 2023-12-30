#include <neocore.h>
#include "externs.h"

int main(void) {
  GFX_Animated_Sprite player;
  GFX_Scroller background;
  GFX_Picture planet;
  init_gpu();
  init_gfx_picture(&planet, &planet04_sprite, &planet04_sprite_Palettes);
  init_gfx_animated_sprite(&player, &player_sprite, &player_sprite_Palettes);
  init_gfx_scroller(&background, &background_sprite, &background_sprite_Palettes);

  display_gfx_scroller(&background, 0, 0);
  display_gfx_picture(&planet, 20, 100);
  display_gfx_animated_sprite(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);

  while(1) {
    Vec2short position;
    wait_vbl();
    update_joypad(0);
    position = get_position_gfx_animated_sprite(player);
    if (joypad_is_left(0) && position.x > 0) { move_gfx_animated_sprite(&player, -1, 0); }
    if (joypad_is_right(0) && position.y < 280) { move_gfx_animated_sprite(&player, 1, 0); }
    if (joypad_is_up(0) && position.y > 0) {
      move_gfx_animated_sprite(&player, 0, -1);
      set_animation_gfx_animated_sprite(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (joypad_is_down(0) && position.y < 200) {
      move_gfx_animated_sprite(&player, 0, 1);
      set_animation_gfx_animated_sprite(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!joypad_is_down(0) && !joypad_is_up(0)) { set_animation_gfx_animated_sprite(&player, PLAYER_SPRITE_ANIM_IDLE); }

    move_gfx_scroller(&background, 1, 0);
    if (get_position_gfx_scroller(background).x > 512) {
      set_position_gfx_scroller(
        &background,
        0,
        get_position_gfx_scroller(background).y
      );
    }
    update_animation_gfx_animated_sprite(&player);
    close_vbl();
  };
  close_vbl();
  return 0;
}
