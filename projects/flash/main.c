#include <neocore.h>
#include <math.h>
#include "player.h"
#include "externs.h"

NEOCORE_INIT

static void init();
static void display();
static void update();

static void flash(aSprite *as, WORD freq);

static void init() {
  player_init();
}

static void display() {
  player_display();
}

static void update() {
  player_update();
  flash(player_get(), 10);
}

static void flash(aSprite *as, WORD freq) {
  if (DAT_frameCounter % freq) {
    aSpriteShow(as)
  } else {
    if (DAT_frameCounter % ((freq MULT2) + (freq DIV2))) {
      aSpriteHide(as);
      clearSprites(as->baseSprite, as->tileWidth);
    }
  }
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
