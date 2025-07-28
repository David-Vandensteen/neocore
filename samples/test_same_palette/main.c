#include <neocore.h>
#include <math.h>
#include "externs.h"

static GFX_Picture planet;
static GFX_Animated_Sprite player;
static GFX_Scroller backgroung;

int main(void) {
  nc_init_display_gfx_scroller(
    &backgroung,
    &background_sprite,
    &background_sprite_Palettes,
    0,
    0
  );

  nc_init_display_gfx_picture(
    &planet,
    &planet04_sprite,
    &background_sprite_Palettes,
    100,
    150
  );

  nc_init_display_gfx_animated_sprite(
    &player,
    &player_sprite,
    &background_sprite_Palettes,
    150,
    10,
    PLAYER_SPRITE_ANIM_IDLE
  );

  while(1) {
    nc_update();
    nc_init_log();
    nc_log_info("PALI PLAYER : %d", player.aSpriteDAT.basePalette);
    nc_log_info("PALI PLANET : %d", planet.pictureDAT.basePalette);
    nc_log_info("PALI BACK   : %d", backgroung.scrollerDAT.basePalette);
    nc_log_info(" ");
    nc_log_info("PAL PLAYER : %d", (int)player.paletteInfoDAT);
    nc_log_info("PAL PLANET : %d", (int)planet.paletteInfoDAT);
    nc_log_info("PAL BACK   : %d", (int)backgroung.paletteInfoDAT);
    nc_update_animation_gfx_animated_sprite(&player);
  };

  return 0;
}
