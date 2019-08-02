#include <neocore.h>
#include "externs.h"

NEOCORE_INIT

int main(void) {
  aSpritePhysic player;
  picturePhysic asteroid;
  gpuInit();
  boxInit(&player.box, 48, 16, 0, 0);
  boxInit(&asteroid.box, (asteroid_sprite.tileWidth MULT8), 32, 0, 0);
  aSpritePhysicDisplay(&player, &player_sprite, &player_sprite_Palettes, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  picturePhysicDisplay(&asteroid, &asteroid_sprite, &asteroid_sprite_Palettes, 100, 100);
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

    (boxCollide(&player.box, &asteroid.box)) ? aSpritePhysicFlash(&player, true, 5) : aSpritePhysicFlash(&player, false, 0);
    aSpritePhysicFlashUpdate(&player);

    aSpriteAnimate(&player.as);
    SCClose();
  };
  SCClose();
  return 0;
}
