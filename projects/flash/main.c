#include <neocore.h>
#include <math.h>
#include "player.h"
#include "externs.h"

NEOCORE_INIT

static void init();
static void display();
static void update();

static picture pic;

// todo - patch neocore
typedef struct Flash Flash;
struct Flash {
  short frequency;
  short lengh;
  BOOL visible;
  BOOL enabled;
};

static void flash_init(Flash *flash, short frequency, short lengh, BOOL enabled) {
  flash->enabled = enabled;
  flash->frequency = frequency;
  flash->lengh = lengh;
  flash->visible = true;
};

static BOOL flash_update(Flash *flash) {
  if (flash->lengh == 0 && flash->enabled) {
    flash->enabled = false;
  }
  if (flash->enabled) {
    if (DAT_frameCounter % flash->frequency == 0) {
      if (flash->visible) {
        flash->visible = !flash->visible;
      } else {
        flash->visible = !flash->visible;
      }
    };
    flash->lengh -= 1;
    return (flash->visible) ? true : false;
  };
};

static void flash_enable(Flash *flash) {
  flash->enabled = true;
};

static void flash_disable(Flash *flash) {
  flash->enabled = false;
};

// todo - patch neocore
static void animated_sprite_flash_update(aSprite *as, Flash *flash) {
  if (flash_update(flash)) {
    aSpriteShow(as);
  } else {
    aSpriteHide(as);
  }
}

Flash player_flash;
Flash laser_flash;

static void init() {
  player_init();
  flash_init(&player_flash, 10, 200, true);
  flash_init(&pic, 3, 600, true);
}

static void display() {
  image_display(&pic, &laser_sprite, &laser_sprite_Palettes, 100, 200);
  player_display();
  // todo - refactor animated_sprite_flash
  //animated_sprite_flash(&player_get()->as, 10);
}

static void update() {
  BYTE i = 0;
  WORD val = 0;
  player_update();
  flash_update(&player_flash, &player_get()->as);
  //animated_sprite_flash_update(&player_get()->as);
}

int main(void) {
  gpu_init();
  init();
  display();
  while(1) {
    WAIT_VBL
    update();
    SCClose();
  };
  SCClose();
  return 0;
}
