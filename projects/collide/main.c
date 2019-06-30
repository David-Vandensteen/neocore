#include <neocore.h>
#include "externs.h"

typedef struct bkp_ram_info {
	WORD debug_dips;
	BYTE stuff[254];
	//256 bytes
} bkp_ram_info;

bkp_ram_info bkp_data;

int main(void) {
  aSpritePhysic player;
  picturePhysic asteroid;
  gpuInit();
  player = aSpritePhysicDisplayAutobox(&player_sprite, &player_sprite_Palettes, 10, 10, 8, PLAYER_SPRITE_ANIM_IDLE);
  asteroid = picturePhysicDisplayAutobox(&asteroid_sprite, &asteroid_sprite_Palettes, 100, 100);
  while(1) {
    waitVBlank();
    joypadUpdate();

    if (joypadIsLeft() && player.as.posX > 0) { aSpritePhysicMove(&player, -1, 0); }
    if (joypadIsRight() && player.as.posX < 280) { aSpritePhysicMove(&player, 1, 0); }
    if (joypadIsUp() && player.as.posY > 0) {
      aSpritePhysicMove(&player, 0, -1);
      aSpriteSetAnim(&player.as, PLAYER_SPRITE_ANIM_UP);
    }
    if (joypadIsDown() && player.as.posY < 200) {
      aSpritePhysicMove(&player, 0, 1);
      aSpriteSetAnim(&player.as, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!joypadIsDown() && !joypadIsUp()) { aSpriteSetAnim(&player.as, PLAYER_SPRITE_ANIM_IDLE); }

    if (boxCollide(&player.box, &asteroid.box)) {
      aSpritePhysicFlash(&player, true, 5);
    } else {
      aSpritePhysicFlash(&player, false, 0);
    }
    aSpritePhysicFlashUpdate(&player);

    aSpriteAnimate(&player.as);
    SCClose();
  };
	SCClose();
  return 0;
}
