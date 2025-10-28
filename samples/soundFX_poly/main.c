/*
  David Vandensteen
  2024
*/

#include <neocore.h>
#include "externs.h"
#include "assets/sounds/fx/sfx.h"

static void play_adpcm(adpcm) { send_sound_command(adpcm); }

int main(void) {
  nc_joypad_set_edge_mode(true);

  while(1) {
    nc_gpu_update();
    nc_log_init();
    nc_log_info_line("INTERACT WITH JOYPAD DIRECTION ...");
    nc_log_info_line("");
    nc_log_info_line("LEFT:  SOUNDFX 1");
    nc_log_info_line("DOWN:  SOUNDFX 2");
    nc_log_info_line("RIGHT: SOUNDFX 3");
    nc_log_info("UP:    ALL SOUNDFX TOGETHER");

    nc_log_set_position(3, 2);
    nc_joypad_debug(0);

    if (nc_joypad_is_up(0)) {
      nc_sound_stop_adpcm();
      play_adpcm(ADPCM_ALARM01);
      nc_gpu_wait_vbl();
      play_adpcm(ADPCM_BELL);
      nc_gpu_wait_vbl();
      play_adpcm(ADPCM_FAIL);
    }

    if (nc_joypad_is_down(0)) {
      nc_sound_stop_adpcm();
      play_adpcm(ADPCM_BELL);
    }

    if (nc_joypad_is_left(0)) {
      nc_sound_stop_adpcm();
      play_adpcm(ADPCM_ALARM01);
    }

    if (nc_joypad_is_right(0)) {
      nc_sound_stop_adpcm();
      play_adpcm(ADPCM_FAIL);
    }
  };

  return 0;
}
