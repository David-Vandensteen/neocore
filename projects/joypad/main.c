/*
  David Vandensteen
  2019
  <dvandensteen@gmail.com>
 */

#include <neocore.h>

typedef struct bkp_ram_info {
	WORD debug_dips;
	BYTE stuff[254];
	//256 bytes
} bkp_ram_info;

bkp_ram_info bkp_data;

int main(void) {
  gpuInit();
  while(1) {
    waitVBlank();
    loggerInit();
    loggerInfo("INTERACT WITH JOYPAD ...");
    joypadUpdateEdge();
    joypadDebug(); /* display which control is actived */

    if (joypadIsUp()) loggerInfo("ITS UP !");
    if (joypadIsDown()) loggerInfo("ITS DOWN !");
    if (joypadIsLeft()) loggerInfo("ITS LEFT !");
    if (joypadIsRight()) loggerInfo("ITS RIGHT !");
    if (joypadIsA()) loggerInfo("ITS A !");
    if (joypadIsB()) loggerInfo("ITS B !");
    if (joypadIsC()) loggerInfo("ITS C !");
    if (joypadIsD()) loggerInfo("ITS D !");

    SCClose();
  };
	SCClose();
  return 0;
}
