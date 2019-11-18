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
    waitVBlank();
    loggerInit();
    loggerInfo("INTERACT WITH JOYPAD ...");
    joypad_update_edge();
    joypad_debug(); /* display which control is actived */

    if (joypad_is_up()) loggerInfo("ITS UP !");
    if (joypad_is_down()) loggerInfo("ITS DOWN !");
    if (joypad_is_left()) loggerInfo("ITS LEFT !");
    if (joypad_is_right()) loggerInfo("ITS RIGHT !");
    if (joypad_is_a()) loggerInfo("ITS A !");
    if (joypad_is_b()) loggerInfo("ITS B !");
    if (joypad_is_c()) loggerInfo("ITS C !");
    if (joypad_is_d()) loggerInfo("ITS D !");

    SCClose();
  };
	SCClose();
  return 0;
}
