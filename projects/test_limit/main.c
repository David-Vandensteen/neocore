#include <neocore.h>
#include <math.h>
#include "externs.h"

// 96 sprites per line
// 380 sprites max

// #define PLANETS_MAX 47
#define PLANETS_MAX 47

NEOCORE_INIT

static void init();
static void display();
static void update();

static Image planets[PLANETS_MAX];

static void init() {
  WORD i = 0;
  gpu_init();
  for (i = 0; i < PLANETS_MAX; i++) image_init(&planets[i], &planet04_sprite, &planet04_sprite_Palettes);
}

static void display() {
  WORD i = 0;
  short x, y;
  for(i = 0; i < PLANETS_MAX; i++) {
    //x = 100;
    //y = 10 + (i * 3);
    x = 100 + ( i * 10);
    y = 100;
    image_display(&planets[i], 0, 0 + i);
    image_shrunk_centroid(&planets[i], x, y, get_shrunk_proportional_table(50));
  }
}

static void update() {
  DWORD x;
  DWORD result;
  WORD i = 0;
  logger_init();
  logger_dword("F : ", DAT_frameCounter);
  logger_word("FD : ", DAT_droppedFrames);
  logger_word("S : ", get_sprite_index());
  // BURN
  /*
  for (i = 1; i < 0xFFFF; i++ ) {
    x = rand();
    result = x / i;
  }
  logger_dword("R : ", result);
  for (i = 0; i < PLANETS_MAX; i++) image_move(&planets[i], 1, 0);
  */
}

int main(void) {
  init();
  display();
  while(1) {
    WAIT_VBL
    update();
    SCClose();
  };
  SCClose();
  return 0;
}
