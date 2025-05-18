#include <neocore.h>
#include "externs.h"

static RGB_Color backdropColor = {0x00, 0x00, 0xFF};

static void init();
static void update();

static void init() {
  nc_set_palette_backdrop_by_rgb_color(backdropColor);
}

static void update() {
  backdropColor.b = --backdropColor.b;
  nc_set_palette_backdrop_by_rgb_color(backdropColor);
}

int main(void) {
  init();
  while(1) {
    nc_update();
    update();
  };
  return 0;
}
