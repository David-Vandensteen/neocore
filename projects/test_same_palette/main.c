#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

static Image planet;
static Animated_Sprite player;
static Scroller backgroung;
// todo (major) - scroller

int main(void) {
  gpu_init();
  scroller_init(&backgroung, &background_sprite, &background_sprite_Palettes);
  image_init(&planet, &planet04_sprite, &background_sprite_Palettes);
  animated_sprite_init(&player, &player_sprite, &background_sprite_Palettes);

  palette_disable_auto_index();

  scroller_display(&backgroung, 0, 0);
  image_display(&planet, 100, 150);
  animated_sprite_display(&player, 150, 10, PLAYER_SPRITE_ANIM_IDLE);


  while(1) {
    WAIT_VBL
    logger_init();
    logger_byte("PALI PLAYER ", player.as.basePalette);
    logger_byte("PALI PLANET ", planet.pic.basePalette);
    logger_byte("PALI BACK   ", backgroung.s.basePalette);
    logger_info(" ");
    logger_word("PAL PLAYER ", (WORD)player.pali);
    logger_word("PAL PLANET ", (WORD)planet.pali);
    logger_word("PAL BACK   ", (WORD)backgroung.pali);
    scroller_move(&backgroung, 1, 0);
    animated_sprite_animate(&player);
    SCClose();
  };
  SCClose();
  return 0;
}
