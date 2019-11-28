#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

// todo - patch neocore
typedef struct Animated_Sprite_Physic Animated_Sprite_Physic;
struct Animated_Sprite_Physic {
  Animated_Sprite animated_sprite;
  Box box;
  BOOL physic_enabled;
};

static void animated_sprite_physic_init(
    Animated_Sprite_Physic *animated_sprite_physic,
    spriteInfo *si,
    paletteInfo *pali,
    short box_witdh,
    short box_height,
    short box_width_offset,
    short box_height_offset
  ) {
  /*
  box_init(
    &animated_sprite_physic->box,
    box_witdh,
    box_height,
    box_width_offset,
    box_height_offset
  );
  animated_sprite_physic->physic_enabled = true;
  */
  animated_sprite_init(
    &animated_sprite_physic->animated_sprite,
    si,
    pali
  );
}

static void NEW_animated_sprite_physic_display(Animated_Sprite_Physic *animated_sprite_physic, short x, short y, WORD anim) {
  animated_sprite_display(
    &animated_sprite_physic->animated_sprite,
    x,
    y,
    PLAYER_SPRITE_ANIM_IDLE
  );
  box_update(&animated_sprite_physic->box, x, y);
}

#define animated_sprite_physic_animate(animated_sprite_physic) aSpriteAnimate(animated_sprite_physic.animated_sprite.as)

Animated_Sprite_Physic player;

int main(void) {
  gpu_init();
  animated_sprite_physic_init(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    16,
    16,
    0,
    0
  );

  NEW_animated_sprite_physic_display(
    &player,
    100,
    100,
    PLAYER_SPRITE_ANIM_IDLE
  );

  // animated_sprite_init(&player.animated_sprite, &player_sprite, &player_sprite_Palettes);
  // animated_sprite_display(&player.animated_sprite, 100, 100, PLAYER_SPRITE_ANIM_IDLE);

  while(1) {
    WAIT_VBL
    animated_sprite_animate(&player.animated_sprite);
    SCClose();
  };
  SCClose();
  return 0;
}
