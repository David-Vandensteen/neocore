#include <neocore.h>
#include "externs.h"

int main(void) {
  GFX_Animated_Sprite player;
  GFX_Scroller background;
  GFX_Picture planet;
  init_gpu();
  init_gp(&planet, &planet04_sprite, &planet04_sprite_Palettes);
  init_gas(&player, &player_sprite, &player_sprite_Palettes);
  init_gs(&background, &background_sprite, &background_sprite_Palettes);

  display_gs(&background, 0, 0);
  display_gp(&planet, 20, 100);
  display_gas(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  while(1) {
    wait_vbl();
    update_joypad();
    if (joypad_is_left() && player.as.posX > 0) { move_gas(&player, -1, 0); }
    if (joypad_is_right() && player.as.posX < 280) { move_gas(&player, 1, 0); }
    if (joypad_is_up() && player.as.posY > 0) {
      move_gas(&player, 0, -1);
      set_anim_gas(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (joypad_is_down() && player.as.posY < 200) {
      move_gas(&player, 0, 1);
      set_anim_gas(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!joypad_is_down() && !joypad_is_up()) { set_anim_gas(&player, PLAYER_SPRITE_ANIM_IDLE); }

    move_gs(background, 1, 0);
    if (background.s.scrlPosX > 512) set_pos_gs(&background.s, 0, background.s.scrlPosY);
    update_anim_gas(&player);
    close_vbl();
  };
  close_vbl();
  return 0;
}
