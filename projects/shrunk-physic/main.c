/*
  David Vandensteen
  2019
*/
#include <neocore.h>
#include <math.h>
#include "player.h"
#include "externs.h"

NEOCORE_INIT

static vec2short laser_position, boss_position;
static picturePhysic laser, boss;
static BYTE shrunk_x;
static WORD shrunk_y = 0;
static box laser_box_origin, boss_box_origin;
static box *boxes_collide_to_test[2];

static picture5 laser_box_pics, boss_box_pics;

static void boxShrunk(box *b, box *bOrigin, WORD shrunkValue); // TODO move in neocore

static void init();
static void display();
static void update();

static void boxShrunk(box *b, box *bOrigin, WORD shrunkValue) {
  // TODO optim.
  // if i can read the shrunk VRAM value, i can compute the origin box...

  // TODO improve precision

  // TODO consider box offsets

  // TODO compute box point 4 (center)

  // TODO move the code to neocore

  BYTE shrunk_x = SHRUNK_EXTRACT_X(shrunkValue);
  BYTE pix_step_x = (bOrigin->width DIV16);
  BYTE trim_x = (((15 - shrunk_x) * pix_step_x) DIV2) + 8;

  int trim_y;
  FIXED shrunk_y = FIX(SHRUNK_EXTRACT_Y(shrunkValue));
  FIXED pix_step_y = FIX((float)bOrigin->height / (float)256); // TODO hmmm float
  FIXED shrunk_y_multiplicator = fsub(FIX(255), shrunk_y);
  shrunk_y_multiplicator = fmul(shrunk_y_multiplicator, pix_step_y);
  trim_y = fixtoi(shrunk_y_multiplicator);
  trim_y =  (trim_y DIV2);
  trim_y += 1;

  b->p0.x = bOrigin->p0.x + trim_x - (bOrigin->width DIV2);
  b->p0.y = bOrigin->p0.y + trim_y - (bOrigin->height DIV2);

  b->p1.x = bOrigin->p1.x - trim_x - (bOrigin->width DIV2);
  b->p1.y = bOrigin->p1.y + trim_y - (bOrigin->height DIV2);

  b->p2.x = bOrigin->p2.x - trim_x - (bOrigin->width DIV2);
  b->p2.y = bOrigin->p2.y - trim_y - (bOrigin->height DIV2);

  b->p3.x = bOrigin->p3.x + trim_x - (bOrigin->width DIV2);
  b->p3.y = bOrigin->p3.y - trim_y - (bOrigin->height DIV2);
}

static void init() {
  laser_position.x = 160;
  laser_position.y = 180;
  boss_position.x = 160;
  boss_position.y = 60;
  shrunk_x = 0;
  player_init();
  boxInit(&laser.box, 320, 80, 0, 0);
  boxInit(&boss.box, 160, 128, 0, 0);
  boxes_collide_to_test[0] = &laser.box;
  boxes_collide_to_test[1] = &boss.box;
}

static void display() {
  picturePhysicDisplay(&laser, &laser_sprite, &laser_sprite_Palettes, laser_position.x, laser_position.y);
  player_display();
  picturePhysicDisplay(&boss, &boss_city_sprite, &boss_city_sprite_Palettes, boss_position.x, boss_position.y);

  BOXCOPY(&boss.box, &boss_box_origin);
  BOXCOPY(&laser.box, &laser_box_origin);

  boxDisplay(&laser_box_pics, &laser.box, &dot_sprite, &dot_sprite_Palettes);
  // TODO pallete inc
  boxDisplay(&boss_box_pics, &boss.box, &dot_sprite, &dot_sprite_Palettes);
}

static void update() {
  joypadUpdateEdge();
  if (DAT_frameCounter % 5 == 0) {
    loggerInit();
    //loggerBox("BOSS BOX ", &boss.box);
    //shrunk_x = 0xF;
    pictureShrunkCentroid(&laser.p, &laser_sprite, laser_position.x, laser_position.y, shrunkForge(shrunk_x, shrunk_y)); // centroid position
    pictureShrunkCentroid(&boss.p, &boss_city_sprite, boss_position.x, boss_position.y, shrunkForge(shrunk_x, shrunk_y)); // centroid position
    shrunk_x++;
    shrunk_y++;
    boxShrunk(&laser.box, &laser_box_origin, shrunkForge(shrunk_x, shrunk_y));
    boxShrunk(&boss.box, &boss_box_origin, shrunkForge(shrunk_x, shrunk_y));
    boxDebugUpdate(&laser_box_pics, &laser.box);
    boxDebugUpdate(&boss_box_pics, &boss.box);
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
