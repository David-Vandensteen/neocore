#include <neocore.h>
#include <math.h>
#include "externs.h"

static GFX_Picture planet;
static GFX_Animated_Sprite player;
static GFX_Scroller backgroung;

int main(void) {
  init_gpu();
  init_gs(&backgroung, &background_sprite, &background_sprite_Palettes);
  init_gp(&planet, &planet04_sprite, &background_sprite_Palettes);
  init_gas(&player, &player_sprite, &background_sprite_Palettes);

  display_gs(&backgroung, 0, 0);
  display_gp(&planet, 100, 150);
  display_gas(&player, 150, 10, PLAYER_SPRITE_ANIM_IDLE);

  while(1) {
    wait_vbl();
    init_logger();
    logger_byte("PALI PLAYER ", player.as.basePalette);
    logger_byte("PALI PLANET ", planet.pic.basePalette);
    logger_byte("PALI BACK   ", backgroung.s.basePalette);
    logger_info(" ");
    logger_word("PAL PLAYER ", (int)player.pali);
    logger_word("PAL PLANET ", (int)planet.pali);
    logger_word("PAL BACK   ", (int)backgroung.pali);
    update_anim_gas(&player);
    close_vbl();
  };
  close_vbl();
  return 0;
}
