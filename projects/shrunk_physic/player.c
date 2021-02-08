/*
  David Vandensteen
  2019
*/
#include <neocore.h>
#include "player.h"
#include "externs.h"

static aSpritePhysic player;

void player_init() {
  box_init(&player.box, 48, 16, 0, 0);
}

void player_display() {
  animated_sprite_physic_display(&player, &player_sprite, &player_sprite_Palettes, 100, 100, PLAYER_SPRITE_ANIM_IDLE);
}

void player_update() {
  joypad_update();

  if (joypad_is_left() && player.as.posX > PLAYER_MIN_X) { animated_sprite_physic_move(&player, -1, 0); }
  if (joypad_is_right() && player.as.posX < PLAYER_MAX_X) { animated_sprite_physic_move(&player, 1, 0); }
  if (joypad_is_up() && player.as.posY > PLAYER_MIN_Y) {
    animated_sprite_physic_move(&player, 0, -1);
    aSpriteSetAnim(&player.as, PLAYER_SPRITE_ANIM_UP);
  }
  if (joypad_is_down() && player.as.posY < PLAYER_MAX_Y) {
    animated_sprite_physic_move(&player, 0, 1);
    aSpriteSetAnim(&player.as, PLAYER_SPRITE_ANIM_DOWN);
  }
  if (!joypad_is_down() && !joypad_is_up()) { aSpriteSetAnim(&player.as, PLAYER_SPRITE_ANIM_IDLE); }
  aSpriteAnimate(&player.as);
  if (DAT_frameCounter % 60 == 0) animated_sprite_flash(&player.as, false);
}

void player_collide(box *b) {
  if (box_collide(b, &player.box)) animated_sprite_flash(&player.as, 4);
}

void player_collides(box *boxes[], BYTE box_max) {
  BYTE i = 0;
  for (i = 0; i < box_max; i++) {
    player_collide(boxes[i]);
  }
}

aSpritePhysic *player_get() {
  return &player;
}
