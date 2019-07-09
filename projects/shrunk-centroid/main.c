#include <neocore.h>
#include <math.h>
#include "externs.h"

typedef struct bkp_ram_info {
	WORD debug_dips;
	BYTE stuff[254];
	//256 bytes
} bkp_ram_info;

bkp_ram_info bkp_data;

static picture laser1, laser2;

static BYTE laser1_shrunk_x = 0xF;

static FIXED laser1_position[2] = { FIX(0), FIX(20) };
static FIXED laser2_position[2] = { FIX(0), FIX(130) };

static void display();
static void update();
static void update_laser1();
static void update_laser2();

static void pictureShrunkCentroid(picture *p, pictureInfo *pi, WORD shrunk_value);

static void display() {
  paletteDisableAutoinc();
  // laser1 = pictureDisplay(&laser_sprite, &laser_sprite_Palettes, fixtoi(laser1_position[X]), fixtoi(laser1_position[Y]));
  laser2 = pictureDisplay(&laser_sprite, &laser_sprite_Palettes, fixtoi(laser2_position[X]), fixtoi(laser2_position[Y]));
  paletteEnableAutoinc();
}

static void update() {
  // if (DAT_frameCounter % 5 == 0) update_laser1();
  // if (DAT_frameCounter % 30 == 0) update_laser2();
  update_laser2();
  loggerInit();
}

static void update_laser1() {
  laser1_shrunk_x--;
  laser1_position[X] += FIX((320 DIV32));
  pictureShrunk(&laser1, &laser_sprite, shrunkForge(laser1_shrunk_x, 0xFF));
  pictureSetPos(&laser1, fixtoi(laser1_position[X]), fixtoi(laser1_position[Y]));
  loggerInt("X : ", fixtoi(laser1_position[X]));
  if (laser1_shrunk_x == 0) {
    laser1_shrunk_x = 0xF;
    laser1_position[X] = FIX(0);
  }
}

static void update_laser2() {
  pictureShrunkCentroid(&laser2, &laser_sprite, shrunkPropTableGet(DAT_frameCounter));
  // TODO add to the git tools for make tables
}

static void pictureShrunkCentroid(picture *p, pictureInfo *pi, WORD shrunk_value) {
  // loggerByte("SHRUNK X : ", shrunk_value >> 8);
  // loggerByte("SHRUNK Y : ", (BYTE)shrunk_value);
  FIXED pos[2] = { FIX(p->posX), FIX(p->posY) };
  pos[X] += FIX((320 DIV32));
  pictureShrunk(p, pi, shrunk_value);
  pictureSetPos(p, fixtoi(pos[X]), fixtoi(pos[Y]));
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
