#include <neocore.h>
#include "externs.h"

NEOCORE_INIT

int main(void) {
  GFX_Animated_Sprite player;
  GFX_Scroller background;
  GFX_Image planet;
  gpu_init();
  gfx_image_init(&planet, &planet04_sprite, &planet04_sprite_Palettes);
  gfx_animated_sprite_init(&player, &player_sprite, &player_sprite_Palettes);
  gfx_scroller_init(&background, &background_sprite, &background_sprite_Palettes);

  // scroller_display(&background, &background_sprite, &background_sprite_Palettes, 0, 0);
  gfx_scroller_display(&background, 0, 0);
  gfx_image_display(&planet, 20, 100);
  gfx_animated_sprite_display(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  while(1) {
    wait_vbl();
    joypad_update();
    if (joypad_is_left() && player.as.posX > 0) { gfx_animated_sprite_move(&player, -1, 0); }
    if (joypad_is_right() && player.as.posX < 280) { gfx_animated_sprite_move(&player, 1, 0); }
    if (joypad_is_up() && player.as.posY > 0) {
      gfx_animated_sprite_move(&player, 0, -1);
      gfx_animated_sprite_set_animation(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (joypad_is_down() && player.as.posY < 200) {
      gfx_animated_sprite_move(&player, 0, 1);
      gfx_animated_sprite_set_animation(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!joypad_is_down() && !joypad_is_up()) { gfx_animated_sprite_set_animation(&player, PLAYER_SPRITE_ANIM_IDLE); }

    gfx_scroller_move(&background, 1, 0);
    if (background.s.scrlPosX > 512) scrollerSetPos(&background.s, 0, background.s.scrlPosY);
    gfx_animated_sprite_animate(&player);
    SCClose();
  };
  SCClose();
  return 0;
}
