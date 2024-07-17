/*
  David Vandensteen
  2023
*/

#include <neocore.h>
#include "externs.h"
#include "sound.h"

static void log_and_sound(char *message) {
  if (nc_get_adpcm_player()->state == IDLE) {
    nc_stop_adpcm();
    send_sound_command(ADPCM_MIXKIT_GAME_CLICK_1114);
    nc_push_remaining_frame_adpcm_player(nc_second_to_frame(1));
  }
}

static void debug_adpcm_player() {
  if (nc_get_adpcm_player()->state == IDLE) nc_log("ADPCM SAMPLE IS READY");
  nc_log("");
  if (nc_get_adpcm_player()->state == PLAYING) nc_log("ADPCM SAMPLE IS PLAYING");
  nc_log(""); nc_log("");
  nc_log_dword("REMAINING", nc_get_adpcm_player()->remaining_frame);
}

int main(void) {
  nc_init_log();
  log_and_sound("");
  nc_set_joypad_edge_mode(true);

  while(1) {
    nc_update();
    nc_init_log();
    nc_log("INTERACT WITH JOYPAD ...");

    nc_set_position_log(3, 2);
    nc_debug_joypad(0);

    if (nc_joypad_is_up(0)) log_and_sound("ITS UP !");
    if (nc_joypad_is_down(0)) log_and_sound("ITS DOWN !");
    if (nc_joypad_is_left(0)) log_and_sound("ITS LEFT !");
    if (nc_joypad_is_right(0)) log_and_sound("ITS RIGHT !");
    if (nc_joypad_is_a(0)) log_and_sound("ITS A !");
    if (nc_joypad_is_b(0)) log_and_sound("ITS B !");
    if (nc_joypad_is_c(0)) log_and_sound("ITS C !");
    if (nc_joypad_is_d(0)) log_and_sound("ITS D !");

    nc_set_position_log(3, 20);
    debug_adpcm_player();

    nc_set_position_log(0, 0);
  };

  return 0;
}
