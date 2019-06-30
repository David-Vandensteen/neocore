#include <neocore.h>
#include "externs.h"

typedef struct bkp_ram_info {
	WORD debug_dips;
	BYTE stuff[254];
	//256 bytes
} bkp_ram_info;

bkp_ram_info bkp_data;

int main(void) {
  aSprite player;
  scroller background;
  gpuInit();
  background = scrollerDisplay(&background_sprite, &background_sprite_Palettes, 0, 0);
  pictureDisplay(&planet04_sprite, &planet04_sprite_Palettes, 20, 100);
  player = aSpriteDisplay(&player_sprite, &player_sprite_Palettes, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  while(1) {
    waitVBlank();
    joypadUpdate();

    if (joypadIsLeft() && player.posX > 0) { aSpriteMove(&player, -1, 0); }
    if (joypadIsRight() && player.posX < 280) { aSpriteMove(&player, 1, 0); }
    if (joypadIsUp() && player.posY > 0) {
      aSpriteMove(&player, 0, -1);
      aSpriteSetAnim(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (joypadIsDown() && player.posY < 200) {
      aSpriteMove(&player, 0, 1);
      aSpriteSetAnim(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!joypadIsDown() && !joypadIsUp()) { aSpriteSetAnim(&player, PLAYER_SPRITE_ANIM_IDLE); }

    scrollerMove(&background, 1, 0);
    if (background.scrlPosX > 512)  scrollerSetPos(&background, 0, background.scrlPosY);
    aSpriteAnimate(&player);
    SCClose();
  };
	SCClose();
  return 0;
}
