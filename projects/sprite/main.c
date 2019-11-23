#include <neocore.h>
#include "externs.h"

NEOCORE_INIT

int main(void) {
  aSprite player;
  scroller background;
  picture planet;
  gpu_init();
  scroller_display(&background, &background_sprite, &background_sprite_Palettes, 0, 0);
  image_display(&planet, &planet04_sprite, &planet04_sprite_Palettes, 20, 100);
  animated_sprite_display(&player, &player_sprite, &player_sprite_Palettes, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  while(1) {
    WAIT_VBL
    joypad_update();

    if (joypad_is_left() && player.posX > 0) { aSpriteMove(&player, -1, 0); }
    if (joypad_is_right() && player.posX < 280) { aSpriteMove(&player, 1, 0); }
    if (joypad_is_up() && player.posY > 0) {
      animated_sprite_move(&player, 0, -1);
      animated_sprite_set_animation(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (joypad_is_down() && player.posY < 200) {
      animated_sprite_move(&player, 0, 1);
      animated_sprite_set_animation(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!joypad_is_down() && !joypad_is_up()) { animated_sprite_set_animation(&player, PLAYER_SPRITE_ANIM_IDLE); }

    scroller_move(&background, 1, 0);
    if (background.scrlPosX > 512)  scrollerSetPos(&background, 0, background.scrlPosY);
    animated_sprite_animate(&player);
    SCClose();
  };
  SCClose();
  return 0;
}
