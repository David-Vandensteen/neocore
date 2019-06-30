#include <neocore.h>
#include "externs.h"

typedef struct bkp_ram_info {
	WORD debug_dips;
	BYTE stuff[254];
	//256 bytes
} bkp_ram_info;

bkp_ram_info bkp_data;

int main(void) { // TODO palette index
  picture logo1, logo2, logo3;
  BYTE logo1_shrunk_x = 0;
  BYTE logo2_shrunk_y = 0;
  gpuInit();
  logo1 = pictureDisplay(&logo_sprite, &logo_sprite_Palettes, 10, 10);
  logo2 = pictureDisplay(&logo_sprite, &logo_sprite_Palettes, 10, 60);
  logo3 = pictureDisplay(&logo_sprite, &logo_sprite_Palettes, 10, 110);
  while(1) {
    waitVBlank();
    if (DAT_frameCounter % 10 == 0) logo1_shrunk_x++;
    logo2_shrunk_y++;
    pictureShrunk(&logo1, &logo_sprite, shrunkForge(logo1_shrunk_x, 0xFF));
    pictureShrunk(&logo2, &logo_sprite, shrunkForge(0XF, logo2_shrunk_y));
    SCClose();
  };
	SCClose();
  return 0;
}
