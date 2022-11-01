#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

static GFX_Image planet;
static GFX_Animated_Sprite player;
static GFX_Scroller backgroung;

int main(void) {
  gpu_init();
  gfx_scroller_init(&backgroung, &background_sprite, &background_sprite_Palettes);
  gfx_image_init(&planet, &planet04_sprite, &background_sprite_Palettes);
  gfx_animated_sprite_init(&player, &player_sprite, &background_sprite_Palettes);

  gfx_scroller_display(&backgroung, 0, 0);
  gfx_image_display(&planet, 100, 150);
  gfx_animated_sprite_display(&player, 150, 10, PLAYER_SPRITE_ANIM_IDLE);

  while(1) {
    wait_vbl();
    logger_init();
    logger_byte("PALI PLAYER ", player.as.basePalette);
    logger_byte("PALI PLANET ", planet.pic.basePalette);
    logger_byte("PALI BACK   ", backgroung.s.basePalette);
    logger_info(" ");
    logger_word("PAL PLAYER ", (int)player.pali);
    logger_word("PAL PLANET ", (int)planet.pali);
    logger_word("PAL BACK   ", (int)backgroung.pali);
    gfx_animated_sprite_animate(&player);
    SCClose();
  };
  SCClose();
  return 0;
}
