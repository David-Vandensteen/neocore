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
    update_joypad_edge(0);
    debug_joypad(0);

    if (joypad_is_up(0)) log_info("ITS UP !");
    if (joypad_is_down(0)) log_info("ITS DOWN !");
    if (joypad_is_left(0)) log_info("ITS LEFT !");
    if (joypad_is_right(0)) log_info("ITS RIGHT !");
    if (joypad_is_a(0)) log_info("ITS A !");
    if (joypad_is_b(0)) log_info("ITS B !");
    if (joypad_is_c(0)) log_info("ITS C !");
    if (joypad_is_d(0)) log_info("ITS D !");

    close_vbl();
  };
  close_vbl();
  return 0;
}
