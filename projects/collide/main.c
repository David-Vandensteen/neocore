#include <neocore.h>
#include "externs.h"

NEOCORE_INIT

int main(void) {
  aSpritePhysic player;
  picturePhysic asteroid;
  gpu_init();
  box_init(&player.box, 48, 16, 0, 0);
  box_init(&asteroid.box, (asteroid_sprite.tileWidth MULT8), 32, 0, 0);
  animated_sprite_physic_display(&player, &player_sprite, &player_sprite_Palettes, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  image_physic_display(&asteroid, &asteroid_sprite, &asteroid_sprite_Palettes, 100, 100);
  while(1) {
    WAIT_VBL
    joypad_update();

    if (joypad_is_left() && player.as.posX > 0) { animated_sprite_physic_move(&player, -1, 0); }
    if (joypad_is_right() && player.as.posX < 280) { animated_sprite_physic_move(&player, 1, 0); }
    if (joypad_is_up() && player.as.posY > 0) {
      animated_sprite_physic_move(&player, 0, -1);
      animated_sprite_set_animation(&player.as, PLAYER_SPRITE_ANIM_UP);
    }
    if (joypad_is_down() && player.as.posY < 200) {
      animated_sprite_physic_move(&player, 0, 1);
      animated_sprite_set_animation(&player.as, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!joypad_is_down() && !joypad_is_up()) { animated_sprite_set_animation(&player.as, PLAYER_SPRITE_ANIM_IDLE); }
    (box_collide(&player.box, &asteroid.box)) ? animated_sprite_flash(&player.as, 4) : animated_sprite_flash(&player.as, false);

    animated_sprite_animate(&player.as);
    SCClose();
  };
  SCClose();
  return 0;
}
