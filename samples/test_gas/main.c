#include <neocore.h>
#include <math.h>
#include "externs.h"

static GFX_Animated_Sprite player;
static Position position;

int main(void) {
  nc_gfx_init_and_display_animated_sprite(
    &player,
    player_sprite_sprt_rom.spriteInfo,
    player_sprite_sprt_rom.paletteInfo,
    100,
    100,
    PLAYER_SPRITE_ANIM_IDLE
  );

  while(1) {
    const DWORD accumulator = 200;
    DWORD frame_seq = accumulator;
    nc_gpu_update();
    nc_log_init();
    nc_gfx_update_animated_sprite_animation(&player);

    if (nc_gpu_get_frame_number() < frame_seq) {
      nc_log_info_line("INIT GAS");
      nc_log_info("DISPLAY GAS AT 100 100");
    }

    frame_seq += accumulator;

    if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
      nc_log_info("SET POS 150 150");
      nc_gfx_set_animated_sprite_position(&player, 150, 150);
    }

    frame_seq += accumulator;

    if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
      nc_gfx_get_animated_sprite_position(&player, &position);
      if (position.x < 0) {
        nc_gfx_set_animated_sprite_position(&player, 150, 150);
      } else {
        nc_gfx_set_animated_sprite_animation(&player, PLAYER_SPRITE_ANIM_UP);
        nc_log_info("MOVE -1 -1");
        nc_gfx_move_animated_sprite(&player, -1, -1);
      }
    }

    frame_seq += accumulator;

    if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
      nc_log_info_line("GET X AND Y");
      nc_gfx_set_animated_sprite_position(&player, 181, 57);
      nc_gfx_set_animated_sprite_animation(&player, PLAYER_SPRITE_ANIM_IDLE);
      nc_gfx_get_animated_sprite_position(&player, &position);
      nc_log_info("X : ");
      nc_log_short(position.x);
      nc_log_info(" Y : ");
      nc_log_short(position.y);
    }

    frame_seq += accumulator;

    if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
      nc_log_info("HIDE");
      nc_gfx_hide_animated_sprite(&player);
    }

    frame_seq += accumulator;

    if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
      nc_log_info("SHOW");
      nc_gfx_show_animated_sprite(&player);
    }

    frame_seq += accumulator;

    if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
      nc_log_info("DESTROY");
      nc_gfx_destroy_animated_sprite(&player);
    }

    frame_seq += accumulator;

    if (nc_gpu_get_frame_number() >= (frame_seq - accumulator)) {
      nc_log_info("TEST END");
    }
  };

  return 0;
}