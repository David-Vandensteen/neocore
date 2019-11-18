#include <neocore.h>
#include "externs.h"

#define PEAK_MASK_VECTOR_MAX 6

// TODO improve neocore collision detection (bug on top of peak)

NEOCORE_INIT

static vec2short peak_mask[PEAK_MASK_VECTOR_MAX];
static aSpritePhysic player;
static picture peak;
static short peak_position[2] = { 100, 80 };

static void init_mask();
static void init();
static void display();
static void display_mask_debug();
static void update();
static void update_player();

static void init() {
  init_mask();
  box_init(&player.box, 48, 16, 0, 0);
}

static void display() {
  pictureDisplay(&peak,&peak_sprite, &peak_sprite_Palettes, peak_position[X], peak_position[Y]);
  animated_sprite_physic_display(&player, &player_sprite, &player_sprite_Palettes, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  display_mask_debug();
}

static void display_mask_debug() {
  BYTE i = 0;
  picture p;
  for (i = 0; i < PEAK_MASK_VECTOR_MAX; i++) {
    pictureDisplay(&p, &dot_sprite, &dot_sprite_Palettes, peak_mask[i].x, peak_mask[i].y);
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
  if (joypad_is_left() && player.as.posX > 0) { animated_sprite_physic_move(&player, -1, 0); }
  if (joypad_is_right() && player.as.posX < 280) { animated_sprite_physic_move(&player, 1, 0); }
  if (joypad_is_up() && player.as.posY > 0) {
    animated_sprite_physic_move(&player, 0, -1);
    aSpriteSetAnim(&player.as, PLAYER_SPRITE_ANIM_UP);
  }
  if (joypad_is_down() && player.as.posY < 200) {
    animated_sprite_physic_move(&player, 0, 1);
    aSpriteSetAnim(&player.as, PLAYER_SPRITE_ANIM_DOWN);
  }
  if (!joypad_is_down() && !joypad_is_up()) { aSpriteSetAnim(&player.as, PLAYER_SPRITE_ANIM_IDLE); }
  (vectorsCollide(&player.box, peak_mask, PEAK_MASK_VECTOR_MAX)) ? animated_sprite_flash(&player.as, 4) : animated_sprite_flash(&player.as, false);
  aSpriteAnimate(&player.as);
}

static void update() {
  update_player();
}

int main(void) {
  gpu_init();
  init();
  display();
  while(1) {
    waitVBlank();
    update();
    SCClose();
  };
  SCClose();
  return 0;
}
