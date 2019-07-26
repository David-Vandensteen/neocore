#include <neocore.h>
#include <math.h>
#include "player.h"
#include "externs.h"

typedef struct bkp_ram_info {
  WORD debug_dips;
  BYTE stuff[254];
  //256 bytes
} bkp_ram_info;

bkp_ram_info bkp_data;

static vec2short laser_position;
static picturePhysic laser;
static BYTE shrunk_x;

static void boxShrunk(box *b, WORD shrunkValue);


static void init();
static void display();
static void update();

static void boxShrunk(box *b, WORD shrunkValue) {
  FIXED newX = FIX(b->p0.x);
  FIXED stepX = FIX(b->width / 0x10);
  FIXED trimX = (SHRUNK_EXTRACT_X(shrunkValue)) * stepX;
  b->p0.x = fixtoi(newX - trimX);
  //loggerInit();
  //loggerShort("NEWX ", fixtoi(newX));
  //loggerShort("STEPX ", fixtoi(stepX));
  //loggerShort("TRIMX ", fixtoi(trimX));

  /*
  b->p0.x = shrunkCentroidGetTranslatedX(b->p0.x, b->width / 8, SHRUNK_EXTRACT_X(shrunkValue));
  b->p0.y = shrunkCentroidGetTranslatedY(b->p0.y, b->height / 8, SHRUNK_EXTRACT_Y(shrunkValue));

  b->p1.x = shrunkCentroidGetTranslatedX(b->p1.x, b->width / 8, SHRUNK_EXTRACT_X(shrunkValue));
  b->p1.y = shrunkCentroidGetTranslatedY(b->p1.y, b->height / 8, SHRUNK_EXTRACT_Y(shrunkValue));

  b->p2.x = shrunkCentroidGetTranslatedX(b->p2.x, b->width / 8, SHRUNK_EXTRACT_X(shrunkValue));
  b->p2.y = shrunkCentroidGetTranslatedY(b->p2.y, b->height / 8, SHRUNK_EXTRACT_Y(shrunkValue));

  b->p3.x = shrunkCentroidGetTranslatedX(b->p3.x, b->width / 8, SHRUNK_EXTRACT_X(shrunkValue));
  b->p3.y = shrunkCentroidGetTranslatedY(b->p3.y, b->height / 8, SHRUNK_EXTRACT_Y(shrunkValue));
  */
}


static void init() {
  laser_position.x = 160;
  laser_position.y = 100;
  shrunk_x = 0;
  player_init();
  boxInit(&laser.box, 320, (laser_sprite.tileHeight MULT8), 0, 0);
}

static void display() {
  picturePhysicDisplay(&laser, &laser_sprite, &laser_sprite_Palettes, 100, 100);
  player_display();
}

static void update() {
  loggerInit();
  loggerBox("LASER BOX", &laser.box);
  if (DAT_frameCounter % 10 == 0) {
    pictureShrunkCentroid(&laser.p, &laser_sprite, laser_position.x, laser_position.y, shrunkForge(shrunk_x, 0xFF)); // centroid position
    shrunk_x++;
    // boxUpdate(&laser.box, laser.p.posX, laser.p.posY); // real position
    boxShrunk(&laser.box, shrunkForge(shrunk_x, 0xFF));
    if (shrunk_x >= 0xF) shrunk_x = 0;
  }
  player_update();
  player_collide(&laser.box);
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
