#include <neocore.h>
#include <math.h>
#include "externs.h"

static GFX_Picture planet;
static GFX_Animated_Sprite player;
static GFX_Scroller backgroung;

int main(void) {
  nc_gfx_init_and_display_scroller(
    &backgroung,
    &background_sprite,
    &background_sprite_Palettes,
    0,
    0
  );

  nc_gfx_init_and_display_picture(
    &planet,
    &planet04_sprite,
    &background_sprite_Palettes,
    100,
    150
  );

  nc_gfx_init_and_display_animated_sprite(
    &player,
    &player_sprite,
    &background_sprite_Palettes,
    150,
    10,
    PLAYER_SPRITE_ANIM_IDLE
  );

  while(1) {
    nc_gpu_update();
    nc_log_init();
    nc_log_info_line("FRAME : %d", nc_gpu_get_frame_number());
    nc_log_info_line("PALI PLAYER : %d", player.aSpriteDAT.basePalette);
    nc_log_info_line("PALI PLANET : %d", planet.pictureDAT.basePalette);
    nc_log_info_line("PALI BACK   : %d", backgroung.scrollerDAT.basePalette);
    nc_log_info_line(" ");
    nc_log_info_line("PAL PLAYER : %d", (int)player.paletteInfoDAT);
    nc_log_info_line("PAL PLANET : %d", (int)planet.paletteInfoDAT);
    nc_log_info("PAL BACK   : %d", (int)backgroung.paletteInfoDAT);
    nc_gfx_update_animated_sprite_animation(&player);
    if (nc_joypad_is_start(0) & nc_joypad_is_a(0)) {
      nc_gfx_destroy_animated_sprite(&player);
      nc_gfx_destroy_picture(&planet);
      nc_gfx_destroy_scroller(&backgroung);
    }
  };
  
  return 0;
}
