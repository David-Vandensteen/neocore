/*
  David Vandensteen
  2024
*/

#include <neocore.h>
#include "externs.h"
#include "assets/sounds/fx/sfx.h"

static void play_adpcm(adpcm) { send_sound_command(adpcm); }

int main(void) {
  nc_set_joypad_edge_mode(true);

  while(1) {
    nc_update();
    nc_init_log();
    nc_set_position_log(0, 0);
    nc_log("INTERACT WITH JOYPAD DIRECTION ...");
    nc_log("");
    nc_log("");
    nc_log("LEFT:  SOUNDFX 1");
    nc_log("DOWN:  SOUNDFX 2");
    nc_log("RIGHT: SOUNDFX 3");
    nc_log("UP:    ALL SOUNDFX TOGETHER");

    nc_set_position_log(3, 2);
    nc_debug_joypad(0);

    if (nc_joypad_is_up(0)) {
      nc_stop_adpcm();
      play_adpcm(ADPCM_ALARM01);
      nc_wait_vbl();
      play_adpcm(ADPCM_BELL);
      nc_wait_vbl();
      play_adpcm(ADPCM_FAIL);
    }

    if (nc_joypad_is_down(0)) {
      nc_stop_adpcm();
      play_adpcm(ADPCM_BELL);
    }

    if (nc_joypad_is_left(0)) {
      nc_stop_adpcm();
      play_adpcm(ADPCM_ALARM01);
    }

    if (nc_joypad_is_right(0)) {
      nc_stop_adpcm();
      play_adpcm(ADPCM_FAIL);
    }
  };

  return 0;
}
