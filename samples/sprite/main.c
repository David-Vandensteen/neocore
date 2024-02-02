#include <neocore.h>
#include "externs.h"

int main(void) {
  GFX_Animated_Sprite player;
  GFX_Scroller background;
  GFX_Picture planet;

  nc_init_gfx_picture(&planet, &planet04_sprite, &planet04_sprite_Palettes);
  nc_init_gfx_animated_sprite(&player, &player_sprite, &player_sprite_Palettes);
  nc_init_gfx_scroller(&background, &background_sprite, &background_sprite_Palettes);

  nc_display_gfx_scroller(&background, 0, 0);
  nc_display_gfx_picture(&planet, 20, 100);
  nc_display_gfx_animated_sprite(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);

  while(1) {
    Vec2short position;
    nc_update();
    position = nc_get_position_gfx_animated_sprite(player);
    if (nc_joypad_is_left(0) && position.x > 0) { nc_move_gfx_animated_sprite(&player, -1, 0); }
    if (nc_joypad_is_right(0) && position.y < 280) { nc_move_gfx_animated_sprite(&player, 1, 0); }
    if (nc_joypad_is_up(0) && position.y > 0) {
      nc_move_gfx_animated_sprite(&player, 0, -1);
      nc_set_animation_gfx_animated_sprite(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (nc_joypad_is_down(0) && position.y < 200) {
      nc_move_gfx_animated_sprite(&player, 0, 1);
      nc_set_animation_gfx_animated_sprite(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!nc_joypad_is_down(0) && !nc_joypad_is_up(0)) { nc_set_animation_gfx_animated_sprite(&player, PLAYER_SPRITE_ANIM_IDLE); }

    nc_move_gfx_scroller(&background, 1, 0);
    if (nc_get_position_gfx_scroller(background).x > 512) {
      nc_set_position_gfx_scroller(
        &background,
        0,
        nc_get_position_gfx_scroller(background).y
      );
    }
    nc_update_animation_gfx_animated_sprite(&player);
  };

  return 0;
}
