#include <neocore.h>
#include "externs.h"

typedef struct bkp_ram_info {
	WORD debug_dips;
	BYTE stuff[254];
	//256 bytes
} bkp_ram_info;

bkp_ram_info bkp_data;

#define LOGO1_POSITION_CENTER_X_INIT 160
#define LOGO3_POSITION_CENTER_Y_INIT 100

static picture logo1, logo2, logo3;

static BYTE logo1_shrunk_x = 0xF;
static short logo1_shrunk_inc = -1;

static BYTE logo3_shrunk_y = 0xFF;
static short logo3_shrunk_inc = -1;

static vec2short logo1_position_center, logo2_position_center, logo3_position_center;

static WORD shrunkTableIndex = 0;

static void init();
static void display();
static void update();
static void update_logo1();
static void update_logo2();
static void update_logo3();

static void init() {
  loggerInit();
  logo1_position_center = vec2shortMake(LOGO1_POSITION_CENTER_X_INIT, 30);
  logo2_position_center = vec2shortMake(160, 180);
  logo3_position_center = vec2shortMake(160, LOGO3_POSITION_CENTER_Y_INIT);
}

static void display() {
  paletteDisableAutoinc();
  logo1 = pictureDisplay(&logo_sprite, &logo_sprite_Palettes, logo1_position_center.x, logo1_position_center.y);
  logo3 = pictureDisplay(&logo_sprite, &logo_sprite_Palettes, logo3_position_center.x, logo3_position_center.y);
  paletteEnableAutoinc();
  logo2 = pictureDisplay(&logo_sprite, &logo_sprite_Palettes, logo2_position_center.x, logo2_position_center.y);
  loggerInfo("HORIZONTAL SHRUNK");
  loggerPositionSet(1, 11);
  loggerInfo("VERTICAL SHRUNK");
  loggerPositionSet(1, 20);
  loggerInfo("PROPORTIONAL SHRUNK");
}

static void update() {
  if (DAT_frameCounter % 5 == 0) update_logo1();
  update_logo2();
  update_logo3();
}

static void update_logo1() { // Horizontal
  logo1_shrunk_x += logo1_shrunk_inc;
  pictureShrunkCentroid(&logo1, &logo_sprite, logo1_position_center.x, logo1_position_center.y, shrunkForge(logo1_shrunk_x, 0xFF));
  if (logo1_shrunk_x == 0) {
    logo1_shrunk_inc = 1;
    logo1_position_center.x = LOGO1_POSITION_CENTER_X_INIT;
  } else {
    if (logo1_shrunk_x >= 0xF) {
      logo1_shrunk_inc = -1;
    }
  }
}

static void update_logo2() { // Proportional
  pictureShrunkCentroid(&logo2, &logo_sprite, logo2_position_center.x, logo2_position_center.y, shrunkPropTableGet(shrunkTableIndex));
  shrunkTableIndex++;
  if (shrunkTableIndex >= SHRUNK_TABLE_PROP_SIZE) shrunkTableIndex = 0;
}

static void update_logo3() { // Verical
  logo3_shrunk_y += logo3_shrunk_inc;
  pictureShrunkCentroid(&logo3, &logo_sprite, logo3_position_center.x, logo3_position_center.y, shrunkForge(0XF ,logo3_shrunk_y));
  if (logo3_shrunk_y == 0) {
    logo3_shrunk_inc = 1;
    logo3_position_center.y = LOGO3_POSITION_CENTER_Y_INIT;
  } else {
    if (logo3_shrunk_y >= 0xFF) {
      logo3_shrunk_inc = -1;
    }
  }
}

int main(void) {
  gpuInit();
  init();
  display();
  while(1) {
    waitVBlank();
    update();
    SCClose();
  };
  SCClose();
  return 0;
}
