#include <neocore.h>
#include <math.h>
#include "externs.h"

// 96 sprites per line
// 380 sprites max

// #define PLANETS_MAX 47
#define PLANETS_MAX 47

static void init();
static void display();
static void update();

static GFX_Picture planets[PLANETS_MAX];

static void init() {
  WORD i = 0;
  init_gpu();
  for (i = 0; i < PLANETS_MAX; i++) init_gp(&planets[i], &planet04_sprite, &planet04_sprite_Palettes);
}

static void display() {
  WORD i = 0;
  short x, y;
  for(i = 0; i < PLANETS_MAX; i++) {
    //x = 100;
    //y = 10 + (i * 3);
    x = 100 + ( i * 10);
    y = 100;
    display_gp(&planets[i], 0, 0 + i);
    gfx_picture_shrunk_centroid(&planets[i], x, y, get_shrunk_proportional_table(50));
  }
}

static void update() {
  DWORD x;
  DWORD result;
  WORD i = 0;
  init_log();
  log_dword("F : ", get_frame_counter());
  log_word("FD : ", DAT_droppedFrames);
  // BURN
  /*
  for (i = 1; i < 0xFFFF; i++ ) {
    x = rand();
    result = x / i;
  }
  log_dword("R : ", result);
  for (i = 0; i < PLANETS_MAX; i++) image_move(&planets[i], 1, 0);
  */
}

int main(void) {
  init();
  display();
  while(1) {
    wait_vbl();
    update();
    close_vbl();
  };
  close_vbl();
  return 0;
}
