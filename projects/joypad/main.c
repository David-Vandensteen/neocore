/*
  David Vandensteen
  2019
  <dvandensteen@gmail.com>
*/

#include <neocore.h>

NEOCORE_INIT

int main(void) {
  gpu_init();
  while(1) {
    WAIT_VBL
    logger_init();
    logger_info("INTERACT WITH JOYPAD ...");
    joypad_update_edge();
    joypad_debug(); /* display which control is actived */

    if (joypad_is_up()) logger_info("ITS UP !");
    if (joypad_is_down()) logger_info("ITS DOWN !");
    if (joypad_is_left()) logger_info("ITS LEFT !");
    if (joypad_is_right()) logger_info("ITS RIGHT !");
    if (joypad_is_a()) logger_info("ITS A !");
    if (joypad_is_b()) logger_info("ITS B !");
    if (joypad_is_c()) logger_info("ITS C !");
    if (joypad_is_d()) logger_info("ITS D !");

    SCClose();
  };
	SCClose();
  return 0;
}
