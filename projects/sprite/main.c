#include <neocore.h>
#include "externs.h"

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
    scrollerDisplay(&background_sprite, &background_sprite_Palettesn, 0, 0);
    SCClose();
  };
	SCClose();
  return 0;
}
