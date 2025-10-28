#include <neocore.h>
#include "externs.h"
#include "asteroid.h"

static GFX_Physic_Picture asteroid;
static BYTE hit;

void asteroid_init() {
  hit = 0;
  nc_gfx_init_physic_picture(&asteroid, &asteroid_sprite, &asteroid_sprite_Palettes, 8, 8, 0, 0, AUTOBOX);
}

void asteroid_display() {
  nc_gfx_display_physic_picture(&asteroid, 200, 100);
}

void asteroid_update() {
  nc_log_init();
  nc_log_info("HIT: ");
  nc_log_byte(hit);
}

BOOL asteroid_collide(Box *b) {
  BOOL r = false;
  if (nc_physic_collide_box(&asteroid.box, b)) {
    hit += 1;
    r = true;
  }
  return r;
}
