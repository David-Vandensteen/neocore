#include <neocore.h>
#include <math.h>
#include "externs.h"

typedef struct bkp_ram_info {
	WORD debug_dips;
	BYTE stuff[254];
	//256 bytes
} bkp_ram_info;

bkp_ram_info bkp_data;

#define SHRUNK_EXTRACT_X(value) value >> 8
#define SHRUNK_EXTRACT_Y(value) (BYTE)value

static picture laser1, laser2, dot;

static BYTE laser1_shrunk_x = 0xF;

static FIXED laser1_position_center[2] = { 160, 40 };
static FIXED laser2_position_center[2] = { 160, 150 };

static WORD shrunkTableIndex = 0;

static void display();
static void update();
static void update_laser1();
static void update_laser2();

static void pictureShrunkCentroid(picture *p, pictureInfo *pi, short centerPosX, short centerPosY, WORD shrunk_value);

static void display() {
  paletteDisableAutoinc();
  laser1 = pictureDisplay(&laser_sprite, &laser_sprite_Palettes, fixtoi(laser1_position_center[X]), fixtoi(laser1_position_center[Y]));
  paletteEnableAutoinc();
  laser2 = pictureDisplay(&laser_sprite, &laser_sprite_Palettes, laser2_position_center[X], laser2_position_center[Y]);
  pictureDisplay(&dot_sprite, &dot_sprite_Palettes, laser2_position_center[X], laser2_position_center[Y]);
}

static void update() {
  if (DAT_frameCounter % 5 == 0) update_laser1();
//  if (DAT_frameCounter % 5 == 0) update_laser2();
  update_laser2();

  /*
  loggerInit();
  loggerShort("X : ", laser2.posX);
  loggerShort("Y : ", laser2.posY);
  loggerInfo("");
  loggerShort("CX : ", laser2_position_center[X]);
  loggerShort("CY : ", laser2_position_center[Y]);
  loggerInfo("");
  loggerWord("SH : ", shrunkPropTableGet(shrunkTableIndex));
  loggerInfo("");
  loggerByte("SH X : ", SHRUNK_EXTRACT_X(shrunkPropTableGet(shrunkTableIndex)));
  loggerByte("SH Y : ", SHRUNK_EXTRACT_Y(shrunkPropTableGet(shrunkTableIndex)));
  */

  joypadUpdateEdge();
  // if(joypadIsStart()) update_laser2();
}

static void update_laser1() {
  laser1_shrunk_x--;
  pictureShrunkCentroid(&laser1, &laser_sprite, laser1_position_center[X], laser1_position_center[Y], shrunkForge(laser1_shrunk_x, 0xFF));
  if (laser1_shrunk_x == 0) {
    laser1_shrunk_x = 0xF;
    laser1_position_center[X] = 160;
  }
}

static void update_laser2() {
  pictureShrunkCentroid(&laser2, &laser_sprite, laser2_position_center[X], laser2_position_center[Y], shrunkPropTableGet(shrunkTableIndex));

  shrunkTableIndex++;
  if (shrunkTableIndex >= SHRUNK_TABLE_PROP_SIZE) shrunkTableIndex = 0;
  // TODO add to the git tools for make tables
}

static short shrunkCentroidGetTranslatedX(short centerPosX, WORD tileWidth, BYTE shrunkX) {
  FIXED newX = FIX(centerPosX);
  newX -= (shrunkX + 1) * FIX((tileWidth MULT8) / 0x10);
  return fixtoi(newX);
}

static short shrunkCentroidGetTranslatedY(short centerPosY, WORD tileHeight, BYTE shrunkY) {
  FIXED newY = FIX(centerPosY);
  newY -= shrunkY * FIX((tileHeight MULT8) / 0xFF);
  return fixtoi(newY);
}

static void pictureShrunkCentroid(picture *p, pictureInfo *pi, short centerPosX, short centerPosY, WORD shrunk_value) {
  short position[2];
  pictureShrunk(p, pi, shrunk_value);

  position[X] = shrunkCentroidGetTranslatedX(centerPosX, pi->tileWidth, SHRUNK_EXTRACT_X(shrunk_value));
  position[Y] = shrunkCentroidGetTranslatedY(centerPosY, pi->tileHeight, SHRUNK_EXTRACT_Y(shrunk_value));

  pictureSetPos(p, position[X], position[Y]);
}

int main(void) {
  gpuInit();
  display();
  while(1) {
    waitVBlank();
    update();
    SCClose();
  };
	SCClose();
  return 0;
}
