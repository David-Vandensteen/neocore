#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

static Image planet;
static Animated_Sprite player;
// todo (major) - scroller

int main(void) {
  gpu_init();
  image_init(&planet, &planet04_sprite, &planet04_sprite_Palettes);
  animated_sprite_init(&player, &player_sprite, &planet04_sprite_Palettes);

  palette_disable_auto_index();
  image_display(&planet, 100, 150);
  animated_sprite_display(&player, 100, 10, PLAYER_SPRITE_ANIM_IDLE);


  while(1) {
    WAIT_VBL
    logger_init();
    logger_byte("PAL I 1 ", player.as.basePalette);
    logger_byte("PAL I 2 ", planet.pic.basePalette);
    logger_info(" ");
    logger_word("PAL 1 ", (WORD)player.pali);
    logger_word("PAL 2 ", (WORD)planet.pali);
    animated_sprite_animate(&player);
    SCClose();
  };
  SCClose();
  return 0;
}
