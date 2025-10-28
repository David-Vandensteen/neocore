/*
  David Vandensteen
  2020
*/

#include <neocore.h>
#include "externs.h"
#include "bullet_player.h"
#include "asteroid.h"

static GFX_Animated_Physic_Sprite sprites[get_bullet_max()];

static BOOL sprites_state[get_bullet_max()];
static BOOL state;

static GFX_Animated_Physic_Sprite *get_free_sprite();

static void free_sprite(BYTE index);
static void debug();
static void update_move();
static void update_states(short x, short y);
static void collide();

static GFX_Animated_Physic_Sprite *get_free_sprite() {
  BYTE i = 0;
  for (i = 0; i < get_bullet_max(); i++) {
    if (!sprites_state[i]) {
      sprites_state[i] = true;
      return &sprites[i];
    }
  }
  return null;
}

static void collide() {
  BYTE j = 0;
  for (j = 0; j < get_bullet_max(); j++) {
    if (sprites_state[j]) {
      if (asteroid_collide(&sprites[j].box)) free_sprite(j);
    }
  }
}

static void free_sprite(BYTE index) {
  sprites_state[index] = false;
  nc_gfx_hide_animated_physic_sprite(&sprites[index]);
}

static void debug() {
  BYTE i = 0;
  nc_log_init();
  for (i = 0; i < get_bullet_max(); i++) {
    nc_log_info("STATE : %d", sprites_state[i]);
  }
  nc_log_info("PAL I : %d", sprites[0].gfx_animated_sprite.aSpriteDAT.basePalette);
  if (nc_joypad_is_a(0)) {
    nc_log_info("JOYPAD A 1");
  } else {
    nc_log_info("JOYPAD A 0");
  }
}

static void update_states(short x, short y) {
  GFX_Animated_Physic_Sprite *free_aSprite;
  free_aSprite = get_free_sprite();
  if (free_aSprite) {
    Position position = {x + get_bullet_xoffset(), y};
    nc_gfx_set_animated_physic_sprite_position(free_aSprite, position.x, position.y);
    nc_gfx_show_animated_physic_sprite(free_aSprite);
  }
}

static void update_move() {
  BYTE i = 0;
  Position position;
  for (i = 0; i < get_bullet_max(); i++) {
    if (sprites_state[i]) {
      nc_gfx_get_animated_physic_sprite_position(&sprites[i], &position);
      nc_gfx_move_animated_physic_sprite(&sprites[i], get_bullet_max(), 0);
      nc_gfx_update_animated_physic_sprite_animation(&sprites[i]);
      if (position.x > 320) {
        free_sprite(i);
      }
    }
  }
}

void bullet_player_init() {
  BYTE i = 0;
  state = false;
  for (i = 0; i < get_bullet_max(); i++) {
    sprites_state[i] = false;
    nc_gfx_init_animated_physic_sprite(&sprites[i], &bullet_img, &bullet_img_Palettes, 8, 8, 0, 0);
  }
}

void bullet_player_display(short x, short y) {
  BYTE i = 0;
  for (i = 0; i < get_bullet_max(); i++) {
    nc_gfx_display_animated_physic_sprite(&sprites[i], x + (i * get_bullet_xoffset()), y, BULLET_IMG_ANIM_IDLE);
    nc_gfx_hide_animated_physic_sprite(&sprites[i]);
  }
  nc_gfx_show_animated_physic_sprite(&sprites[0]);
}

void bullet_player_update(BOOL pstate, short x, short y) {
  state = pstate;
  update_move();
  collide();
  if (nc_gpu_get_frame_number() % get_bullet_rate() == 0 && state) update_states(x, y);
}

void bullet_player_destroy() {
  BYTE i;
  bullet_player_init();
  for (i = 0; i < get_bullet_max(); i++) nc_gfx_hide_animated_physic_sprite(&sprites[i]);
}