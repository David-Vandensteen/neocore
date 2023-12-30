#include <neocore.h>
#include <math.h>
#include "externs.h"

static GFX_Picture planet;
static GFX_Animated_Sprite player;
static GFX_Scroller backgroung;

int main(void) {
  init_gpu();
  init_gfx_scroller(&backgroung, &background_sprite, &background_sprite_Palettes);
  init_gfx_picture(&planet, &planet04_sprite, &background_sprite_Palettes);
  init_gfx_animated_sprite(&player, &player_sprite, &background_sprite_Palettes);

  display_gfx_scroller(&backgroung, 0, 0);
  display_gfx_picture(&planet, 100, 150);
  display_gfx_animated_sprite(&player, 150, 10, PLAYER_SPRITE_ANIM_IDLE);

  while(1) {
    wait_vbl();
    init_log();
    log_byte("PALI PLAYER ", player.aSpriteDAT.basePalette);
    log_byte("PALI PLANET ", planet.pictureDAT.basePalette);
    log_byte("PALI BACK   ", backgroung.scrollerDAT.basePalette);
    log_info(" ");
    log_word("PAL PLAYER ", (int)player.paletteInfoDAT);
    log_word("PAL PLANET ", (int)planet.paletteInfoDAT);
    log_word("PAL BACK   ", (int)backgroung.paletteInfoDAT);
    update_animation_gfx_animated_sprite(&player);
    close_vbl();
  };
  close_vbl();
  return 0;
}
