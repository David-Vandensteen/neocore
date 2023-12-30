#include <neocore.h>
#include <math.h>
#include "externs.h"

GFX_Animated_Sprite_Physic player;

int main(void) {
  init_gpu();
  init_gfx_animated_sprite_physic(&player, &player_sprite, &player_sprite_Palettes, 0, 0, 0, 0);
  display_gfx_animated_sprite_physic(&player, 100, 100, PLAYER_SPRITE_ANIM_IDLE);
  while(1) {
    const DWORD accumulator = 200;
    DWORD frame_seq = accumulator;
    wait_vbl();
    init_log();
    update_animation_gfx_animated_sprite_physic(&player);
    if (get_frame_counter() < frame_seq) {
      log_info("INIT GASP");
      log_info("DISPLAY GASP AT 100 100");
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      log_info("SET POS 150 150");
      set_position_gfx_animated_sprite_physic(&player, 150, 150);
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      if (get_x_gfx_animated_sprite_physic(player) < 0) {
        set_position_gfx_animated_sprite_physic(&player, 150, 150);
      } else {
        set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_UP);
        log_info("MOVE -1 -1");
        move_gfx_animated_sprite_physic(&player, -1, -1);
      }
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      log_info("GET X AND Y");
      set_position_gfx_animated_sprite_physic(&player, 181, 57);
      set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_IDLE);
      log_short("X", get_x_gfx_animated_sprite_physic(player));
      log_short("Y", get_y_gfx_animated_sprite_physic(player));
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      log_info("HIDE");
      hide_gfx_animated_sprite_physic(&player);
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      log_info("SHOW");
      show_gfx_animated_sprite_physic(&player);
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      log_info("DESTROY");
      destroy_gfx_animated_sprite_physic(&player);
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator)) {
      log_info("TEST END");
    }
    close_vbl();
  };
  close_vbl();
  return 0;
}
