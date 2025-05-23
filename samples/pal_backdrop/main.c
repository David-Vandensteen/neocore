#include <neocore.h>
#include "externs.h"

static RGB16 backdrop_color = {0x0, 0x0, 0x0, 0xF};

static void init();
static void update();

static void init() {
  nc_set_palette_backdrop_by_rgb16(backdrop_color);
}

static void update() {
  backdrop_color.b--;
  nc_set_palette_backdrop_by_rgb16(backdrop_color);
}

int main(void) {
  init();
  while(1) {
    nc_update();
    update();
  };
  return 0;
}
