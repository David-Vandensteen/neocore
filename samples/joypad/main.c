/*
  David Vandensteen
  2019
  <dvandensteen@gmail.com>
*/

#include <neocore.h>

int main(void) {
  init_gpu();
  while(1) {
    wait_vbl();
    init_log();
    log_info("INTERACT WITH JOYPAD ...");
    update_joypad_edge();
    joypad_debug(); /* display which control is actived */

    if (joypad_is_up()) log_info("ITS UP !");
    if (joypad_is_down()) log_info("ITS DOWN !");
    if (joypad_is_left()) log_info("ITS LEFT !");
    if (joypad_is_right()) log_info("ITS RIGHT !");
    if (joypad_is_a()) log_info("ITS A !");
    if (joypad_is_b()) log_info("ITS B !");
    if (joypad_is_c()) log_info("ITS C !");
    if (joypad_is_d()) log_info("ITS D !");

    close_vbl();
  };
  close_vbl();
  return 0;
}
