/*
  David Vandensteen
  2020
*/

#include <neocore.h>
#include "externs.h"
#include "bullet_player.h"
#include "asteroid.h"

static Animated_Sprite_Physic sprites[BULLET_MAX];

static BOOL sprites_state[BULLET_MAX];
static BOOL state;

static Animated_Sprite_Physic *get_free_sprite();

static void free_sprite(BYTE index);
static void debug();
static void update_move();
static void update_states(short x, short y);
static void collide();

static Animated_Sprite_Physic *get_free_sprite() {
  BYTE i = 0;
  for (i = 0; i < BULLET_MAX; i++) {
    if (!sprites_state[i]) {
      sprites_state[i] = true;
      return &sprites[i];
    }
  }
  return null;
}

static void collide() {
  BYTE j = 0;
  for (j = 0; j < BULLET_MAX; j++) {
    if (sprites_state[j]) {
      if (asteroid_collide(&sprites[j].box)) free_sprite(j);
    }
  }
}

static void free_sprite(BYTE index) {
  sprites_state[index] = false;
  animated_sprite_physic_hide(&sprites[index]);
}

static void debug() {
  BYTE i = 0;
  logger_init();
  for (i = 0; i < BULLET_MAX; i++) {
    logger_bool("STATE ", sprites_state[i]);
  }
  logger_byte("PAL I :", sprites[0].animated_sprite.as.basePalette);
  if (joypad_is_a()) {
    logger_info("JOYPAD A 1");
  } else {
    logger_info("JOYPAD A 0");
  }
}

static void update_states(short x, short y) {
  Animated_Sprite_Physic *free_aSprite;
  free_aSprite = get_free_sprite();
  if (free_aSprite) {
    animated_sprite_physic_set_position(free_aSprite, x + BULLET_XOFFSET, y);
    animated_sprite_physic_show(free_aSprite);
  }
}

static void update_move() {
  BYTE i = 0;
  for (i = 0; i < BULLET_MAX; i++) {
    if (sprites_state[i]) {
      animated_sprite_physic_move(&sprites[i], BULLET_SPEED, 0);
      animated_sprite_animate(&sprites[i].animated_sprite);
      if (sprites[i].animated_sprite.as.posX > 320) {
        free_sprite(i);
      }
    }
  }
}

void bullet_player_init() {
  BYTE i = 0;
  state = false;
  for (i = 0; i < BULLET_MAX; i++) {
    sprites_state[i] = false;
    animated_sprite_physic_init(&sprites[i], &bullet_img, &bullet_img_Palettes, 8, 8, 0, 0);
  }
}

void bullet_player_display(short x, short y) {
  BYTE i = 0;
  for (i = 0; i < BULLET_MAX; i++) {
    animated_sprite_physic_display(&sprites[i], x + (i * BULLET_XOFFSET), y, BULLET_IMG_ANIM_IDLE);
    animated_sprite_physic_hide(&sprites[i]);
  }
  animated_sprite_show(&sprites[0].animated_sprite);
}

void bullet_player_update(BOOL pstate, short x, short y) {
  state = pstate;
  update_move();
  collide();
  if (DAT_frameCounter % BULLET_RATE == 0 && state) update_states(x, y);
}

void bullet_player_destroy() {
  BYTE i;
  bullet_player_init();
  for (i = 0; i < BULLET_MAX; i++) {
    animated_sprite_physic_hide(&sprites[i]);
  }
}