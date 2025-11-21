#include <neocore.h>
#include "externs.h"

static GFX_Animated_Sprite player;
static GFX_Scroller background;
static GFX_Picture planet;

int main(void) {
  nc_gfx_init_and_display_scroller(
    &background,
    &background_sprite,
    &background_sprite_Palettes,
    0,
    0
  );

  nc_gfx_init_and_display_picture(
    &planet,
    &planet04_sprite,
    &planet04_sprite_Palettes,
    20,
    100
  );

  nc_gfx_init_and_display_animated_sprite(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    10,
    10,
    PLAYER_SPRITE_ANIM_IDLE
  );

  while(1) {
    Position position, backgroundPosition;
    nc_gpu_update();
    nc_gfx_get_animated_sprite_position(&player, &position);
    if (nc_joypad_is_left(0) && position.x > 0) { nc_gfx_move_animated_sprite(&player, -1, 0); }
    if (nc_joypad_is_right(0) && position.y < 280) { nc_gfx_move_animated_sprite(&player, 1, 0); }
    if (nc_joypad_is_up(0) && position.y > 0) {
      nc_gfx_move_animated_sprite(&player, 0, -1);
      nc_gfx_set_animated_sprite_animation(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (nc_joypad_is_down(0) && position.y < 200) {
      nc_gfx_move_animated_sprite(&player, 0, 1);
      nc_gfx_set_animated_sprite_animation(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!nc_joypad_is_down(0) && !nc_joypad_is_up(0)) { nc_gfx_set_animated_sprite_animation(&player, PLAYER_SPRITE_ANIM_IDLE); }

    nc_gfx_move_scroller(&background, 1, 0);
    nc_gfx_get_scroller_position(&background, &backgroundPosition);
    if (backgroundPosition.x > 512) {
      nc_gfx_set_scroller_position(
        &background,
        0,
        backgroundPosition.y
      );
    }
    nc_gfx_update_animated_sprite_animation(&player);
    if (nc_joypad_is_start(0) & nc_joypad_is_a(0)) {
      nc_destroy_gfx_animated_sprite(&player);
      nc_destroy_gfx_picture(&planet);
      nc_destroy_gfx_scroller(&background);
    }
  };
  return 0;
}
