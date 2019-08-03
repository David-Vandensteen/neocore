/*
  David Vandensteen
  2019
*/
#include <neocore.h>
#include <math.h>
#include "player.h"
#include "externs.h"

NEOCORE_INIT

static picturePhysicShrunkCentroid laser, boss;
static BYTE shrunk_x;
static WORD shrunk_y = 0;
static box *boxes_collide_to_test[2];

static picture5 laser_box_pics, boss_box_pics;


static void init();
static void display();
static void update();



static void init() {
  picturePhysicShrunkCentroidInit(&laser, &laser_sprite, &laser_sprite_Palettes, 160, 180);
  picturePhysicShrunkCentroidInit(&boss, &boss_city_sprite, &boss_city_sprite_Palettes, 160, 60);

  shrunk_x = 0;
  player_init();
  boxInit(&laser.pp.box, 320, 80, 0, 0);
  boxInit(&boss.pp.box, 160, 128, 0, 0);
  boxes_collide_to_test[0] = &laser.pp.box;
  boxes_collide_to_test[1] = &boss.pp.box;
}

static void display() {
  picturePhysicShrunkCentroidDisplay(&laser, shrunkForge(shrunk_x, shrunk_y));
  picturePhysicShrunkCentroidDisplay(&boss, shrunkForge(shrunk_x, shrunk_y));
  player_display();

  boxDisplay(&laser_box_pics, &laser.pp.box, &dot_sprite, &dot_sprite_Palettes);
  // TODO pallete inc
  boxDisplay(&boss_box_pics, &boss.pp.box, &dot_sprite, &dot_sprite_Palettes);
}

static void update() {
  joypadUpdateEdge();
  if (DAT_frameCounter % 5 == 0) {
    loggerInit();
    picturePhysicShrunkCentroidDo(&laser, shrunkForge(shrunk_x, shrunk_y));
    picturePhysicShrunkCentroidDo(&boss, shrunkForge(shrunk_x, shrunk_y));
    boxDebugUpdate(&laser_box_pics, &laser.pp.box);
    boxDebugUpdate(&boss_box_pics, &boss.pp.box);

    /* Set Pos
    laser.positionCenter.x++;
    picturePhysicShrunkCentroidSetPos(&laser.boxOrigin, laser.positionCenter.x, laser.positionCenter.y);
    */

    /* Move
    picturePhysicShrunkCentroidMove(&laser, 1, 1);
    */

    shrunk_x++;
    shrunk_y++;

    if (shrunk_x >= 0xF) shrunk_x = 0;
    if (shrunk_y >= 0xFF) shrunk_y = 0;
  }
  player_update();
  player_collides(boxes_collide_to_test, 2);
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