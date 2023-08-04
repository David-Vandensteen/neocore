/*
  David Vandensteen
  2023
*/

#include <neocore.h>
#include "externs.h"
#include "sound.h"

#define SAMPLE_LENGTH 3

// TODO : refactor & patch neocore
// TODO : once, loop on triger ....

enum sound_state { IDLE, PLAYING };

typedef struct Adpcm_player {
  enum sound_state state;
  DWORD remaining_frame;
} Adpcm_player;

Adpcm_player adpcm_player;

void log(char *message) {
  log_info(message);
}

void init_adpcm_player() {
  adpcm_player.state = IDLE;
  adpcm_player.remaining_frame = 0;
}

void add_remaining_frame_adpcm_player(DWORD frame) {
  adpcm_player.remaining_frame += frame;
  adpcm_player.state = PLAYING;
}

Adpcm_player *get_adpcm_player() {
  return &adpcm_player;
}

void update_adpcm_player() {
  if (adpcm_player.remaining_frame != 0) {
    adpcm_player.state = PLAYING;
    adpcm_player.remaining_frame -= 1;
  }

  if (adpcm_player.remaining_frame > 0 && adpcm_player.state != IDLE) {
    adpcm_player.state = PLAYING;
    adpcm_player.remaining_frame -= 1;
  }

  if (adpcm_player.remaining_frame == 0) adpcm_player.state = IDLE;
}

void wait_vbl_patched() {
  update_adpcm_player();
  wait_vbl();
}

DWORD get_frame_to_second(DWORD frame) {
  return frame / 60;
}

DWORD get_second_to_frame(DWORD second) {
  return second * 60;
}

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
//

int main(void) {
  init_adpcm_player(); // TODO : inside neocore
  init_gpu();
  init_log();
  log_and_sound("");

  while(1) {
    wait_vbl_patched();
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
