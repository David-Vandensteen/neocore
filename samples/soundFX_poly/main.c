/*
  David Vandensteen
  2024
*/

#include <neocore.h>
#include "externs.h"
#include "assets/sounds/fx/sfx.h"

// TODO patch neocore
#define nc_wait_vbl() waitVBlank();


static void sound1() {
  send_sound_command(ADPCM_ALARM01);
  nc_push_remaining_frame_adpcm_player(nc_second_to_frame(9));
}

static void sound2() {
  send_sound_command(ADPCM_BELL);
  nc_push_remaining_frame_adpcm_player(nc_second_to_frame(2));
}

static void sound3() {
  send_sound_command(ADPCM_FAIL);
  nc_push_remaining_frame_adpcm_player(nc_second_to_frame(2));
}

int main(void) {
  nc_init_log();
  nc_set_joypad_edge_mode(true);

  while(1) {
    nc_update();
    nc_init_log();
    nc_log("INTERACT WITH DIRECTION ON JOYPAD ...");
    nc_log("");
    nc_log("LEFT: SOUNDFX 1");
    nc_log("DOWN: SOUNDFX 2");
    nc_log("RIGHT: SOUNDFX 3");
    nc_log("UP: ALL SOUNDFX TOGETHER");

    nc_set_position_log(3, 2);
    nc_debug_joypad(0);

    if (nc_joypad_is_up(0)) {
      send_sound_command(ADPCM_STOP);
      sound1();
      nc_wait_vbl();
      sound2();
      nc_wait_vbl();
      sound3();
    }

    if (nc_joypad_is_down(0)) {
      send_sound_command(ADPCM_STOP);
      sound2();
    }

    if (nc_joypad_is_left(0)) {
      send_sound_command(ADPCM_STOP);
      sound1();
    }

    if (nc_joypad_is_right(0)) {
      send_sound_command(ADPCM_STOP);
      sound3();
    }

    nc_set_position_log(0, 0);
  };

  return 0;
}
