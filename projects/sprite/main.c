#include <neocore.h>
#include "externs.h"

NEOCORE_INIT

int main(void) {
  aSprite player;
  scroller background;
  picture planet;
  gpu_init();
  scrollerDisplay(&background, &background_sprite, &background_sprite_Palettes, 0, 0);
  pictureDisplay(&planet, &planet04_sprite, &planet04_sprite_Palettes, 20, 100);
  animated_sprite_display(&player, &player_sprite, &player_sprite_Palettes, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  while(1) {
    waitVBlank();
    joypad_update();

    if (joypad_is_left() && player.posX > 0) { aSpriteMove(&player, -1, 0); }
    if (joypad_is_right() && player.posX < 280) { aSpriteMove(&player, 1, 0); }
    if (joypad_is_up() && player.posY > 0) {
      aSpriteMove(&player, 0, -1);
      aSpriteSetAnim(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (joypad_is_down() && player.posY < 200) {
      aSpriteMove(&player, 0, 1);
      aSpriteSetAnim(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!joypad_is_down() && !joypad_is_up()) { aSpriteSetAnim(&player, PLAYER_SPRITE_ANIM_IDLE); }

    scrollerMove(&background, 1, 0);
    if (background.scrlPosX > 512)  scrollerSetPos(&background, 0, background.scrlPosY);
    aSpriteAnimate(&player);
    SCClose();
  };
  SCClose();
  return 0;
}
