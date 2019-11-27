#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

// todo - patch neocore
typedef struct Flash Flash;
struct Flash {
  short frequency;
  short lengh;
  BOOL visible;
  BOOL enabled;
};

// todo - patch neocore
typedef struct Animated_Sprite Animated_Sprite;
struct Animated_Sprite {
  aSprite as;
  spriteInfo *si;
  paletteInfo *pali;
  Flash flash;
};

static void animated_sprite_init(Animated_Sprite *animated_sprite ,spriteInfo *si, paletteInfo *pali) {
  animated_sprite->si = si;
  animated_sprite->pali = pali;
};

static void NEW_animated_sprite_display(Animated_Sprite *animated_sprite, short x, short y, WORD anim) {
  aSpriteInit(
    &animated_sprite->as,
    animated_sprite->si,
		animated_sprite_index_auto(animated_sprite->si),
    palette_get_index(),
    x,
    y,
    anim,
    FLIP_NONE
  );
}

Animated_Sprite player;

int main(void) {
  gpu_init();
  animated_sprite_init(&player, &player_sprite, &player_sprite_Palettes);
  // NEW_animated_sprite_display(&player, 100, 100, PLAYER_SPRITE_ANIM_IDLE);
  while(1) {
    WAIT_VBL
    logger_init();
    logger_word("ANIM", PLAYER_SPRITE_ANIM_IDLE);
    aSpriteAnimate(&player.as);
    SCClose();
  };
  SCClose();
  return 0;
}
