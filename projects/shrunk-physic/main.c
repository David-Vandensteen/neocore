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
  image_physic_shrunk_centroid_init(&laser, &laser_sprite, &laser_sprite_Palettes, 160, 180);
  image_physic_shrunk_centroid_init(&boss, &boss_city_sprite, &boss_city_sprite_Palettes, 160, 60);

  shrunk_x = 0;
  player_init();
  box_init(&laser.pp.box, 320, 80, 0, 0);
  box_init(&boss.pp.box, 160, 128, 0, 0);
  boxes_collide_to_test[0] = &laser.pp.box;
  boxes_collide_to_test[1] = &boss.pp.box;
}

static void display() {
  image_physic_shrunk_centroid_display(&laser, shrunk_forge(shrunk_x, shrunk_y));
  image_physic_shrunk_centroid_display(&boss, shrunk_forge(shrunk_x, shrunk_y));
  player_display();

  box_display(&laser_box_pics, &laser.pp.box, &dot_sprite, &dot_sprite_Palettes);
  // TODO pallete inc
  box_display(&boss_box_pics, &boss.pp.box, &dot_sprite, &dot_sprite_Palettes);
}

static void update() {
  joypad_update_edge();
  if (DAT_frameCounter % 5 == 0) {
    logger_init();
    image_physic_shrunk_centroid_update(&laser, shrunk_forge(shrunk_x, shrunk_y));
    image_physic_shrunk_centroid_update(&boss, shrunk_forge(shrunk_x, shrunk_y));
    box_debug_update(&laser_box_pics, &laser.pp.box);
    box_debug_update(&boss_box_pics, &boss.pp.box);

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
  gpu_init();
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