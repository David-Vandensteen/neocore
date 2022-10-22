/*
  David Vandensteen
  2020
*/
#include <neocore.h>
#include "externs.h"
#include "player.h"
#include "bullet_player.h"

static Animated_Sprite_Physic player_sprite;

static short x = 0;
static short y = 0;

void player_init(short px, short py) {
  x = px;
  y = py;
  animated_sprite_physic_init(&player_sprite, &player_img, &player_img_Palettes, 48, 16, 0, 0);
  bullet_player_init();
}

void player_display() {
  animated_sprite_physic_display(&player_sprite, x, y, PLAYER_IMG_ANIM_IDLE);
  bullet_player_display(x, y);
}

void player_update() {
  animated_sprite_animate(&player_sprite.animated_sprite);
  joypad_update();
  if (joypad_is_up() && y > PLAYER_Y_MIN) {
    y -= PLAYER_SPEED;
    animated_sprite_set_animation(&player_sprite.animated_sprite, PLAYER_IMG_ANIM_UP);
  }
  if (joypad_is_down() && y < PLAYER_Y_MAX) {
    y += PLAYER_SPEED;
    animated_sprite_set_animation(&player_sprite.animated_sprite, PLAYER_IMG_ANIM_DOWN);
  }
  if (joypad_is_left() && x > PLAYER_X_MIN)   x -= PLAYER_SPEED + 1;
  if (joypad_is_right() && x < PLAYER_X_MAX)  x += PLAYER_SPEED + 1;
  if (!joypad_is_down() && !joypad_is_up()) animated_sprite_set_animation(&player_sprite.animated_sprite, PLAYER_IMG_ANIM_IDLE);
  animated_sprite_physic_set_position(&player_sprite, x, y);
  animated_sprite_flash(&player_sprite.animated_sprite);
  bullet_player_update(joypad_is_a(), x, y);
  if (!player_sprite.animated_sprite.flash.enabled) player_sprite.physic_enabled = true;
}

Box *player_box_get() {
  return &player_sprite.box;
}

Animated_Sprite_Physic *player_get_sprite() {
  return &player_sprite;
}

short player_position_get_x() {
  return x;
}

short player_position_get_y() {
  return y;
}

void player_position_set(short px, short py) {
  x = px;
  y = py;
}

void player_move(short px, short py) {
  animated_sprite_physic_move(&player_sprite, px, py);
  x = player_sprite.animated_sprite.as.posX;
  y = player_sprite.animated_sprite.as.posY;
}

void player_destroy() {
  bullet_player_destroy();
  clearSprites(player_sprite.animated_sprite.as.baseSprite, player_sprite.animated_sprite.as.tileWidth);
}
