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
  for (i = 0; i < PLANETS_MAX; i++) nc_gfx_init_picture(&planets[i], planet04_sprite_pict_rom.pictureInfo, planet04_sprite_pict_rom.paletteInfo);
}

static void display() {
  WORD i = 0;
  short x, y;
  for(i = 0; i < PLANETS_MAX; i++) {
    //x = 100;
    //y = 10 + (i * 3);
    x = 100 + ( i * 10);
    y = 100;
    nc_gfx_display_picture(&planets[i], 0, 0 + i);
    nc_gpu_shrunk_centroid_gfx_picture(&planets[i], x, y, nc_gpu_get_shrunk_proportional_table(50));
  }
}

static void update() {
  DWORD x;
  DWORD result;
  WORD i = 0;
  nc_log_init();
  nc_log_info_line("F : %08ld", nc_gpu_get_frame_number());
  nc_log_info("FD : %04d", DAT_droppedFrames);
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
    nc_gpu_update();
    update();
  };

  return 0;
}
