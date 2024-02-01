#include <neocore.h>
#include <math.h>
#include "externs.h"

GFX_Animated_Sprite_Physic player;

int main(void) {
  nc_init_gfx_animated_sprite_physic(&player, &player_sprite, &player_sprite_Palettes, 0, 0, 0, 0);
  nc_display_gfx_animated_sprite_physic(&player, 100, 100, PLAYER_SPRITE_ANIM_IDLE);

  while(1) {
    const DWORD accumulator = 200;
    DWORD frame_seq = accumulator;

    nc_update();
    nc_init_log();
    nc_update_animation_gfx_animated_sprite_physic(&player);

    if (nc_get_frame_counter() < frame_seq) {
      nc_log_info("INIT GASP");
      nc_log_info("DISPLAY GASP AT 100 100");
    }

    frame_seq += accumulator;

    if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
      nc_log_info("SET POS 150 150");
      nc_set_position_gfx_animated_sprite_physic(&player, 150, 150);
    }

    frame_seq += accumulator;

    if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
      if (nc_get_position_gfx_animated_sprite_physic(player).x < 0) {
        nc_set_position_gfx_animated_sprite_physic(&player, 150, 150);
      } else {
        nc_set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_UP);
        nc_log_info("MOVE -1 -1");
        nc_move_gfx_animated_sprite_physic(&player, -1, -1);
      }
    }

    frame_seq += accumulator;

    if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
      nc_log_info("GET X AND Y");
      nc_set_position_gfx_animated_sprite_physic(&player, 181, 57);
      nc_set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_IDLE);
      nc_log_short("X", nc_get_position_gfx_animated_sprite_physic(player).x);
      nc_log_short("Y", nc_get_position_gfx_animated_sprite_physic(player).y);
    }

    frame_seq += accumulator;

    if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
      nc_log_info("HIDE");
      nc_hide_gfx_animated_sprite_physic(&player);
    }

    frame_seq += accumulator;

    if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
      nc_log_info("SHOW");
      nc_show_gfx_animated_sprite_physic(&player);
    }

    frame_seq += accumulator;
    if (nc_get_frame_counter() >= (frame_seq - accumulator) && nc_get_frame_counter() < frame_seq) {
      nc_log_info("DESTROY");
      nc_destroy_gfx_animated_sprite_physic(&player);
    }

    frame_seq += accumulator;

    if (nc_get_frame_counter() >= (frame_seq - accumulator)) {
      nc_log_info("TEST END");
    }
  };

  return 0;
}
