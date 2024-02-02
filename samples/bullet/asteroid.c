#include <neocore.h>
#include "externs.h"
#include "asteroid.h"

static GFX_Picture_Physic asteroid;
static BYTE hit;

void asteroid_init() {
  hit = 0;
  nc_init_gfx_picture_physic(&asteroid, &asteroid_sprite, &asteroid_sprite_Palettes, 8, 8, 0, 0, AUTOBOX);
}

void asteroid_display() {
  nc_display_gfx_picture_physic(&asteroid, 200, 100);
}

void asteroid_update() {
  nc_init_log();
  nc_log_byte("HIT", hit);
}

BOOL asteroid_collide(Box *b) {
  BOOL r = false;
  if (nc_collide_box(&asteroid.box, b)) {
    hit += 1;
    r = true;
  }
  return r;
}
