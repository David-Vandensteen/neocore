#include <neocore.h>
#include "externs.h"

#define PEAK_MASK_VECTOR_MAX 6

typedef struct bkp_ram_info {
	WORD debug_dips;
	BYTE stuff[254];
	//256 bytes
} bkp_ram_info;

bkp_ram_info bkp_data;

static vec2short peak_mask[PEAK_MASK_VECTOR_MAX];
static aSpritePhysic player;
static picturePhysic peak;
static short peak_position[2] = { 100, 80 };

static void init_mask();
static void init();
static void display();
static void update();
static void update_player();

static void init() {
  init_mask();
}

static void display() {
  player = aSpritePhysicDisplayAutobox(&player_sprite, &player_sprite_Palettes, 10, 10, 8, PLAYER_SPRITE_ANIM_IDLE);
  peak = picturePhysicDisplayAutobox(&peak_sprite, &peak_sprite_Palettes, peak_position[X], peak_position[Y]);
}

static void init_mask() {
  peak_mask[0].x = 50 + peak_position[X];
  peak_mask[0].y = 5 + peak_position[Y];

  peak_mask[1].x = 67 + peak_position[X];
  peak_mask[1].y = 5; + peak_position[Y];

  peak_mask[2].x = 70 + peak_position[X];
  peak_mask[2].y = 80 + peak_position[Y];

  peak_mask[3].x = 80 + peak_position[X];
  peak_mask[3].y = 130 + peak_position[Y];

  peak_mask[4].x = 10 + peak_position[X];
  peak_mask[4].y = 130 + peak_position[Y];

  peak_mask[5].x = 35 + peak_position[X];
  peak_mask[5].y = 55 + peak_position[Y];
}

static void update_player() {
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
  (vectorsCollide(&player.box, peak_mask, PEAK_MASK_VECTOR_MAX)) ? aSpritePhysicFlash(&player, true, 5) : aSpritePhysicFlash(&player, false, 0);
  aSpritePhysicFlashUpdate(&player);
  aSpriteAnimate(&player.as);
}

static void update() {
  update_player();
}

int main(void) {
  gpuInit();
  init();
  display();
  while(1) {
    waitVBlank();
    update();
    SCClose();
  };
	SCClose();
  return 0;
}
