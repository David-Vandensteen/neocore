#include <neocore.h>
#include "externs.h"

NEOCORE_INIT

static Animated_Sprite_Physic player;
static Image_Physic asteroid;

int main(void) {
  gpu_init();
  animated_sprite_physic_init(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    10,
    10,
    0,
    0
  );
  image_physic_init(
    &asteroid,
    &asteroid_sprite,
    &asteroid_sprite_Palettes,
    (asteroid_sprite.tileWidth MULT8),
    32,
    0,
    0
  );
  animated_sprite_physic_display(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  image_physic_display(&asteroid, 100, 100);

  while(1) {
    WAIT_VBL
    joypad_update();

    if (joypad_is_left() && player.animated_sprite.as.posX > 0) { animated_sprite_physic_move(&player, -1, 0); }
    if (joypad_is_right() && player.animated_sprite.as.posX < 280) { animated_sprite_physic_move(&player, 1, 0); }
    if (joypad_is_up() && player.animated_sprite.as.posY > 0) {
      animated_sprite_physic_move(&player, 0, -1);
      animated_sprite_set_animation(&player.animated_sprite, PLAYER_SPRITE_ANIM_UP);
    }
    if (joypad_is_down() && player.animated_sprite.as.posY < 200) {
      animated_sprite_physic_move(&player, 0, 1);
      animated_sprite_set_animation(&player.animated_sprite, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!joypad_is_down() && !joypad_is_up()) { animated_sprite_set_animation(&player.animated_sprite, PLAYER_SPRITE_ANIM_IDLE); }

    if (box_collide(&player.box, &asteroid.box)) flash_init(&player.animated_sprite.flash, true, 10, 10);

    animated_sprite_flash(&player.animated_sprite);
    animated_sprite_animate(&player.animated_sprite);
    SCClose();
  };
  SCClose();
  return 0;
}
