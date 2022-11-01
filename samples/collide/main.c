#include <neocore.h>
#include "externs.h"

NEOCORE_INIT

static GFX_Animated_Sprite_Physic player;
static GFX_Image_Physic asteroid;

int main(void) {
  gpu_init();
  gfx_animated_sprite_physic_init(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    10,
    10,
    0,
    0
  );
  gfx_image_physic_init(
    &asteroid,
    &asteroid_sprite,
    &asteroid_sprite_Palettes,
    (asteroid_sprite.tileWidth MULT8),
    32,
    0,
    0,
    AUTOBOX
  );
  gfx_animated_sprite_physic_display(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  gfx_image_physic_display(&asteroid, 100, 100);

  while(1) {
    wait_vbl();
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

    if (box_collide(&player.box, &asteroid.box)) flash_init(&player.gfx_animated_sprite.flash, true, 10, 10);

    gfx_animated_sprite_flash(&player.gfx_animated_sprite);
    gfx_animated_sprite_animate(&player.gfx_animated_sprite);
    SCClose();
  };
  SCClose();
  return 0;
}
