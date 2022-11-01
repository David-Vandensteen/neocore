#include <neocore.h>
#include "externs.h"

#define PEAK_MASK_VECTOR_MAX 6

// todo (minor) - improve neocore collision detection (bug on top of peak)

NEOCORE_INIT

static Vec2short peak_mask[PEAK_MASK_VECTOR_MAX];
static GFX_Animated_Sprite_Physic player;

static GFX_Image peak;
static short peak_position[2] = { 100, 80 };

static void init_mask();
static void init();
static void display();
static void display_mask_debug();
static void update();
static void update_player();

static void init() {
  init_mask();
  gfx_animated_sprite_physic_init(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    10,
    10,
    0,
    0
  );
  gfx_image_init(&peak, &peak_sprite, &peak_sprite_Palettes);
}

static void display() {
  gfx_image_display(&peak, peak_position[X], peak_position[Y]);
  gfx_animated_sprite_physic_display(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  display_mask_debug();
}

static void display_mask_debug() {
  BYTE i = 0;
  GFX_Image p;
  for (i = 0; i < PEAK_MASK_VECTOR_MAX; i++) {
    gfx_image_init(&p, &dot_sprite, &dot_sprite_Palettes);
    gfx_image_display(&p, peak_mask[i].x, peak_mask[i].y);
  }
}

static void init_mask() {
  peak_mask[0].x = 53 + peak_position[X];
  peak_mask[0].y = 5 + peak_position[Y];

  peak_mask[1].x = 67 + peak_position[X];
  peak_mask[1].y = 5 + peak_position[Y];

  peak_mask[2].x = 70 + peak_position[X];
  peak_mask[2].y = 80 + peak_position[Y];

  peak_mask[3].x = 80 + peak_position[X];
  peak_mask[3].y = 136 + peak_position[Y];

  peak_mask[4].x = 6 + peak_position[X];
  peak_mask[4].y = 136 + peak_position[Y];

  peak_mask[5].x = 35 + peak_position[X];
  peak_mask[5].y = 55 + peak_position[Y];
}

static void update_player() {
  joypad_update();
  if (joypad_is_left() && player.gfx_animated_sprite.as.posX > 0) { gfx_animated_sprite_physic_move(&player, -1, 0); }
  if (joypad_is_right() && player.gfx_animated_sprite.as.posX < 280) { gfx_animated_sprite_physic_move(&player, 1, 0); }
  if (joypad_is_up() && player.gfx_animated_sprite.as.posY > 0) {
    gfx_animated_sprite_physic_move(&player, 0, -1);
    gfx_animated_sprite_set_animation(&player.gfx_animated_sprite, PLAYER_SPRITE_ANIM_UP);
  }
  if (joypad_is_down() && player.gfx_animated_sprite.as.posY < 200) {
    gfx_animated_sprite_physic_move(&player, 0, 1);
    gfx_animated_sprite_set_animation(&player.gfx_animated_sprite, PLAYER_SPRITE_ANIM_DOWN);
  }
  if (!joypad_is_down() && !joypad_is_up()) { gfx_animated_sprite_set_animation(&player.gfx_animated_sprite, PLAYER_SPRITE_ANIM_IDLE); }
  if (vectors_collide(&player.box, peak_mask, PEAK_MASK_VECTOR_MAX)) flash_init(&player.gfx_animated_sprite.flash, true, 10, 10);
  gfx_animated_sprite_flash(&player.gfx_animated_sprite);
  gfx_animated_sprite_animate(&player.gfx_animated_sprite);
}

static void update() {
  update_player();
}

int main(void) {
  gpu_init();
  init();
  display();
  while(1) {
    wait_vbl();
    update();
    SCClose();
  };
  SCClose();
  return 0;
}
