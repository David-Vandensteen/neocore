#include <neocore.h>
#include <math.h>
#include "externs.h"

GFX_Animated_Sprite_Physic player;

int main(void) {
  init_gpu();
  init_gasp(&player, &player_sprite, &player_sprite_Palettes, 0, 0, 0, 0);
  display_gasp(&player, 100, 100, PLAYER_SPRITE_ANIM_IDLE);
  while(1) {
    const DWORD accumulator = 200;
    DWORD frame_seq = accumulator;
    wait_vbl();
    init_logger();
    update_anim_gasp(&player);
    if (get_frame_counter() < frame_seq) {
      logger_info("INIT GASP");
      logger_info("DISPLAY GASP AT 100 100");
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      logger_info("SET POS 150 150");
      set_pos_gasp(&player, 150, 150);
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      if (get_x_gasp(player) < 0) {
        set_pos_gasp(&player, 150, 150);
      } else {
        set_anim_gasp(&player, PLAYER_SPRITE_ANIM_UP);
        logger_info("MOVE -1 -1");
        move_gasp(&player, -1, -1);
      }
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      logger_info("GET X AND Y");
      set_pos_gasp(&player, 181, 57);
      set_anim_gasp(&player, PLAYER_SPRITE_ANIM_IDLE);
      logger_short("X", get_x_gasp(player));
      logger_short("Y", get_y_gasp(player));
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      logger_info("HIDE");
      hide_gas(&player);
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      logger_info("SHOW");
      show_gasp(&player);
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator) && get_frame_counter() < frame_seq) {
      logger_info("DESTROY");
      destroy_gas(&player);
    }
    frame_seq += accumulator;
    if (get_frame_counter() >= (frame_seq - accumulator)) {
      logger_info("TEST END");
    }
    close_vbl();
  };
  close_vbl();
  return 0;
}
