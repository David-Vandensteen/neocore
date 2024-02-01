#include <neocore.h>
#include <math.h>
#include "externs.h"

static GFX_Picture planet;
static GFX_Animated_Sprite player;
static GFX_Scroller backgroung;

int main(void) {
  nc_init_gfx_scroller(&backgroung, &background_sprite, &background_sprite_Palettes);
  nc_init_gfx_picture(&planet, &planet04_sprite, &background_sprite_Palettes);
  nc_init_gfx_animated_sprite(&player, &player_sprite, &background_sprite_Palettes);

  nc_display_gfx_scroller(&backgroung, 0, 0);
  nc_display_gfx_picture(&planet, 100, 150);
  nc_display_gfx_animated_sprite(&player, 150, 10, PLAYER_SPRITE_ANIM_IDLE);

  while(1) {
    nc_update();
    nc_init_log();
    nc_log_byte("PALI PLAYER ", player.aSpriteDAT.basePalette);
    nc_log_byte("PALI PLANET ", planet.pictureDAT.basePalette);
    nc_log_byte("PALI BACK   ", backgroung.scrollerDAT.basePalette);
    nc_log_info(" ");
    nc_log_word("PAL PLAYER ", (int)player.paletteInfoDAT);
    nc_log_word("PAL PLANET ", (int)planet.paletteInfoDAT);
    nc_log_word("PAL BACK   ", (int)backgroung.paletteInfoDAT);
    nc_update_animation_gfx_animated_sprite(&player);
  };

  return 0;
}
