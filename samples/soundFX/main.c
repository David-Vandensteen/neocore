/*
  David Vandensteen
  2023
*/

#include <neocore.h>
#include "externs.h"
#include "sound.h"

#define SAMPLE_LENGTH 3

void log_and_sound(char *message) {
  if (get_adpcm_player()->state == IDLE) {
    send_sound_command(ADPCM_STOP);
    send_sound_command(ADPCM_MIXKIT_GAME_CLICK_1114);
    add_remaining_frame_adpcm_player(get_second_to_frame(1));
  }
}

void debug_adpcm_player() {
  if (get_adpcm_player()->state == IDLE) log("ADPCM SAMPLE IS READY");
  log("");
  if (get_adpcm_player()->state == PLAYING) log("ADPCM SAMPLE IS PLAYING");
  log(""); log("");
  log_dword("REMAINING", get_adpcm_player()->remaining_frame);
}

int main(void) {
  init_all_system();
  init_log();
  log_and_sound("");

  while(1) {
    wait_vbl();
    init_log();
    log("INTERACT WITH JOYPAD ...");

    set_position_log(3, 2);
    update_joypad_edge(0);
    debug_joypad(0);

    if (joypad_p1_is_up()) log_and_sound("ITS UP !");
    if (joypad_p1_is_down()) log_and_sound("ITS DOWN !");
    if (joypad_p1_is_left()) log_and_sound("ITS LEFT !");
    if (joypad_p1_is_right()) log_and_sound("ITS RIGHT !");
    if (joypad_p1_is_a()) log_and_sound("ITS A !");
    if (joypad_p1_is_b()) log_and_sound("ITS B !");
    if (joypad_p1_is_c()) log_and_sound("ITS C !");
    if (joypad_p1_is_d()) log_and_sound("ITS D !");

    set_position_log(3, 20);
    debug_adpcm_player();

    set_pos_log(0, 0);
    close_vbl();
  };
  close_vbl();
  return 0;
}
