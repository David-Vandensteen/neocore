#include <neocore.h>
#include "externs.h"

#define ASTEROID_MAX  10

NEOCORE_INIT

int main(void) {
  aSpritePhysic player;
  picturePhysic asteroids[ASTEROID_MAX];
  box *asteroids_box[ASTEROID_MAX];
  BYTE i = 0;
  gpu_init();
  box_init(&player.box, 48, 16, 0, 0);
  animated_sprite_physic_display(&player, &player_sprite, &player_sprite_Palettes, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  for (i = 0; i < ASTEROID_MAX; i++) {
    box_init(&asteroids[i].box, 8, 8, 0, 0);
    picturePhysicDisplay(&asteroids[i], &asteroid_sprite, &asteroid_sprite_Palettes, RAND(300), RAND(200));
    asteroids_box[i] = &asteroids[i].box;
  }
  while(1) {
    waitVBlank();
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
    (boxes_collide(&player.box, asteroids_box, ASTEROID_MAX)) ? animated_sprite_flash(&player.as, 4) : animated_sprite_flash(&player.as, false);
    aSpriteAnimate(&player.as);
    SCClose();
  };
  SCClose();
  return 0;
}
