#include <neocore.h>
#include <math.h>
#include "externs.h"

GFX_Animated_Sprite player;

int main(void) {
  init_gpu();
  init_gas(&player, &player_sprite, &player_sprite_Palettes);
  display_gas(&player, 100, 100, PLAYER_SPRITE_ANIM_IDLE);
  while(1) {
    const DWORD accumulator = 200;
    DWORD frame_seq = accumulator;
    wait_vbl();
    init_log();
    update_anim_gas(&player);
    if (get_frame_counter() < frame_seq) {
      log_info("INIT GAS");
      log_info("DISPLAY GAS AT 100 100");
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      log_info("SET POS 150 150");
      set_pos_gas(&player, 150, 150);
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      if (get_x_gas(player) < 0) {
        set_pos_gas(&player, 150, 150);
      } else {
        set_anim_gas(&player, PLAYER_SPRITE_ANIM_UP);
        log_info("MOVE -1 -1");
        move_gas(&player, -1, -1);
      }
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      log_info("GET X AND Y");
      set_pos_gas(&player, 181, 57);
      set_anim_gas(&player, PLAYER_SPRITE_ANIM_IDLE);
      log_short("X", get_x_gas(player));
      log_short("Y", get_y_gas(player));
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      log_info("HIDE");
      hide_gas(&player);
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      log_info("SHOW");
      show_gas(&player);
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      log_info("DESTROY");
      destroy_gas(&player);
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
