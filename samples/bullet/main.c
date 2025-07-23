#include <neocore.h>
#include <DATlib.h>
#include <math.h>
#include "externs.h"

// #include "player.h"
// #include "asteroid.h"

static GFX_Animated_Sprite player_sprite;
// static GFX_Animated_Sprite_Physic player_sprite;
// static GFX_Picture_Physic asteroid;

static void init();
static void display();
static void update();

static void init() {
  nc_init_gfx_animated_sprite(&player_sprite, &player_img, &player_img_Palettes);
}

static void display() {
  nc_init_display_gfx_animated_sprite(
    &player_sprite,
    &player_img,
    &player_img_Palettes,
    100,
    100,
    PLAYER_IMG_ANIM_IDLE
  );
}

static void update() {
  // player_update();
  // asteroid_update();
}

int main(void) {
  init();
  display();

  while(1) {
    nc_update();
    nc_update_animation_gfx_animated_sprite(&player_sprite);
    // update();
  };

  return 0;
}
