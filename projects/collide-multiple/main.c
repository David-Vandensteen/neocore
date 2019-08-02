#include <neocore.h>
#include "externs.h"

#define ASTEROID_MAX  10

NEOCORE_INIT

int main(void) {
  aSpritePhysic player;
  picturePhysic asteroids[ASTEROID_MAX];
  box *asteroids_box[ASTEROID_MAX];
  BYTE i = 0;
  gpuInit();
  boxInit(&player.box, 48, 16, 0, 0);
  aSpritePhysicDisplay(&player, &player_sprite, &player_sprite_Palettes, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  for (i = 0; i < ASTEROID_MAX; i++) {
    boxInit(&asteroids[i].box, 8, 8, 0, 0);
    picturePhysicDisplay(&asteroids[i], &asteroid_sprite, &asteroid_sprite_Palettes, RAND(300), RAND(200));
    asteroids_box[i] = &asteroids[i].box;
  }
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
    if (boxesCollide(&player.box, asteroids_box, ASTEROID_MAX)) {
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
