#include <neocore.h>
#include "externs.h"
#include "asteroid.h"

static GFX_Picture_Physic asteroid;
static BYTE hit;

void asteroid_init() {
  hit = 0;
  init_gpp(&asteroid, &asteroid_sprite, &asteroid_sprite_Palettes, 8, 8, 0, 0, AUTOBOX);
}

void asteroid_display() {
  display_gpp(&asteroid, 200, 100);
}

void asteroid_update() {
  init_log();
  log_byte("HIT", hit);
}

BOOL asteroid_collide(Box *b) {
  BOOL r = false;
  if (collide_box(&asteroid.box, b)) {
    hit += 1;
    r = true;
  }
  return r;
}
