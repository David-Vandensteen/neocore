#include <neocore.h>
#include "externs.h"

typedef struct bkp_ram_info {
	WORD debug_dips;
	BYTE stuff[254];
	//256 bytes
} bkp_ram_info;

bkp_ram_info bkp_data;

int main(void) {
  picture logo1, logo2, logo3;
  BYTE logo1_shrunk_x = 0;
  BYTE logo2_shrunk_y = 0;
  gpuInit();
  loggerInit();
  paletteDisableAutoinc(); /* logo1, logo2 & logo3 use the same palette ... disable auto counter */
  loggerInfo("HORIZONTAL SHRUNK");
  logo1 = pictureDisplay(&logo_sprite, &logo_sprite_Palettes, 10, 20);
  loggerPositionSet(1, 10);
  loggerInfo("VERTICAL SHRUNK");
  logo2 = pictureDisplay(&logo_sprite, &logo_sprite_Palettes, 10, 80);
  loggerPositionSet(1, 19);
  loggerInfo("PROPORTIONAL SHRUNK");
  logo3 = pictureDisplay(&logo_sprite, &logo_sprite_Palettes, 10, 150);
  paletteEnableAutoinc();

  while(1) {
    waitVBlank();
    if (DAT_frameCounter % 5 == 0) logo1_shrunk_x++;
    logo2_shrunk_y +=3 ;
    pictureShrunk(&logo1, &logo_sprite, shrunkForge(logo1_shrunk_x, 0xFF));
    pictureShrunk(&logo2, &logo_sprite, shrunkForge(0XF, logo2_shrunk_y));
    pictureShrunk(&logo3, &logo_sprite, shrunkPropTableGet(DAT_frameCounter & SHRUNK_TABLE_PROP_SIZE)); /* neocore provide a precalculated table for keep "aspect ratio" */
    SCClose();
  };
	SCClose();
  return 0;
}