#include <neocore.h>
#include "externs.h"

#define ASTEROID_MAX  10

NEOCORE_INIT

static Animated_Sprite_Physic player;
static Image_Physic asteroids[ASTEROID_MAX];
static Box *asteroids_box[ASTEROID_MAX];

int main(void) {
  BYTE i = 0;
  gpu_init();
  animated_sprite_physic_init(&player, &player_sprite, &player_sprite_Palettes, 48, 16, 0, 0);  
  animated_sprite_physic_display(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  for (i = 0; i < ASTEROID_MAX; i++) {
    image_physic_init(&asteroids[i], &asteroid_sprite, &asteroid_sprite_Palettes, 8, 8, 0, 0);
    image_physic_display(&asteroids[i], RAND(300), RAND(200));
    asteroids_box[i] = &asteroids[i].box;
  }
  while(1) {
    waitVBlank();
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
    
    if (boxes_collide(&player.box, asteroids_box, ASTEROID_MAX)) { flash_init(&player.animated_sprite.flash, 10, 10); }
    animated_sprite_flash(&player.animated_sprite);
    animated_sprite_animate(&player.animated_sprite);
    SCClose();
  };
  SCClose();
  return 0;
}
