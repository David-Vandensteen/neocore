/*
  David Vandensteen
  2019
*/
#include <neocore.h>
#include <math.h>
#include "player.h"
#include "externs.h"

NEOCORE_INIT

typedef struct picturePhysicShrunkCentroid picturePhysicShrunkCentroid;
struct picturePhysicShrunkCentroid {
  picturePhysic pp;
  pictureInfo *pi;
  paletteInfo *pali;
  vec2short positionCenter;
  box boxOrigin;
};

static picturePhysicShrunkCentroid laser, boss;
static BYTE shrunk_x;
static WORD shrunk_y = 0;
static box *boxes_collide_to_test[2];

static picture5 laser_box_pics, boss_box_pics;

static void boxShrunk(box *b, box *bOrigin, WORD shrunkValue); // TODO move in neocore

static void init();
static void display();
static void update();

void picturePhysicShrunkCentroidInit(picturePhysicShrunkCentroid *pps, pictureInfo *pi, paletteInfo *pali, short xCenter, short yCenter) {
  pps->pi = pi;
  pps->pali = pali;
  pps->positionCenter.x = xCenter;
  pps->positionCenter.y = yCenter;
}

void picturePhysicShrunkCentroidSetPos(box *boxOrigin, short x, short y) {
  boxUpdate(boxOrigin, x, y);
}

void picturePhysicShrunkCentroidMove(picturePhysicShrunkCentroid *pps, short xShift, short yShift) {
  pps->positionCenter.x += xShift;
  pps->positionCenter.y += yShift;
  picturePhysicShrunkCentroidSetPos(&pps->boxOrigin, pps->positionCenter.x, pps->positionCenter.y);
}

void picturePhysicShrunkCentroidDo(picturePhysicShrunkCentroid *pps, WORD shrunk) {
  pictureShrunkCentroid(&pps->pp.p, pps->pi, pps->positionCenter.x, pps->positionCenter.y, shrunk);
  boxShrunk(&pps->pp.box, &pps->boxOrigin, shrunk);
}

void pictureShrunkCentroidDisplay(picturePhysicShrunkCentroid *pps, WORD shrunk) {
  picturePhysicDisplay(&pps->pp, pps->pi, pps->pali, pps->positionCenter.x, pps->positionCenter.y);
  pictureShrunkCentroid(&pps->pp.p, pps->pi, pps->positionCenter.x, pps->positionCenter.y, shrunk);
  BOXCOPY(&pps->pp.box, &pps->boxOrigin);
}

static void boxShrunk(box *b, box *bOrigin, WORD shrunkValue) {
  // TODO optim.
  // if i can read the shrunk VRAM value, i can compute the origin box...

  // TODO improve precision

  // TODO consider box offsets

  // TODO move the code to neocore

  BYTE shrunk_x = SHRUNK_EXTRACT_X(shrunkValue);
  BYTE pix_step_x = (bOrigin->width DIV16);
  BYTE trim_x = (((15 - shrunk_x) * pix_step_x) DIV2);

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

  b->p4.x = b->p0.x + ((b->p1.x - b->p0.x) DIV2);
  b->p4.y = b->p0.y + ((b->p3.y - b->p0.y) DIV2);
}

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
  pictureShrunkCentroidDisplay(&laser, shrunkForge(shrunk_x, shrunk_y));
  pictureShrunkCentroidDisplay(&boss, shrunkForge(shrunk_x, shrunk_y));
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