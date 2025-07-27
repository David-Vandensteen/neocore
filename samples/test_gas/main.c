#include <neocore.h>
#include <math.h>
#include "externs.h"

static GFX_Animated_Sprite player;

int main(void) {
  Position current_pos;

  nc_init_display_gfx_animated_sprite(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    100,
    100,
    PLAYER_SPRITE_ANIM_IDLE
  );

  while(1) {
    const DWORD accumulator = 200;
    DWORD frame_seq = accumulator;
    nc_update();
    nc_init_log();
    nc_update_animation_gfx_animated_sprite(&player);

    if (nc_get_frame_counter() < frame_seq) {
      nc_log_info("INIT GAS\n");
      nc_log_info("DISPLAY GAS AT 100 100");
    }

    frame_seq += accumulator;

    if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
      nc_log_info("SET POS 150 150");
      nc_set_position_gfx_animated_sprite(&player, 150, 150);
    }

    frame_seq += accumulator;

    if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
      Position current_pos;
      nc_get_position_gfx_animated_sprite(&player, &current_pos);
      if (current_pos.x < 0) {
        nc_set_position_gfx_animated_sprite(&player, 150, 150);
      } else {
        nc_set_animation_gfx_animated_sprite(&player, PLAYER_SPRITE_ANIM_UP);
        nc_log_info("MOVE -1 -1");
        nc_move_gfx_animated_sprite(&player, -1, -1);
      }
    }

    frame_seq += accumulator;

    if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
      nc_log_info("GET X AND Y");
      nc_set_position_gfx_animated_sprite(&player, 181, 57);
      nc_set_animation_gfx_animated_sprite(&player, PLAYER_SPRITE_ANIM_IDLE);
      nc_get_position_gfx_animated_sprite(&player, &current_pos);
      nc_log_info("X: %d", current_pos.x);
      nc_log_info("Y: %d", current_pos.y);
    }

    frame_seq += accumulator;

    if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
      nc_log_info("HIDE");
      nc_hide_gfx_animated_sprite(&player);
    }

    frame_seq += accumulator;

    if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
      nc_log_info("SHOW");
      nc_show_gfx_animated_sprite(&player);
    }

    frame_seq += accumulator;

    if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
      nc_log_info("DESTROY");
      nc_destroy_gfx_animated_sprite(&player);
    }

    frame_seq += accumulator;

    if (nc_get_frame_counter() >= (frame_seq - accumulator)) {
      nc_log_info("TEST END");
    }
  };

  return 0;
}
