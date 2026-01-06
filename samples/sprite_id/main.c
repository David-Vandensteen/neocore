#include <neocore.h>
#include "externs.h"

static GFX_Animated_Sprite player;
static GFX_Scroller background;
static GFX_Picture planet;

int main(void) {
  WORD background_sprite_id, planet_sprite_id, player_sprite_id;

  // Test automatic sprite allocation and store returned sprite indices
  background_sprite_id = nc_gfx_init_and_display_scroller(
    &background,
    background_sprite_scrl_rom.scrollerInfo,
    background_sprite_scrl_rom.paletteInfo,
    0,
    0
  );

  planet_sprite_id = nc_gfx_init_and_display_picture(
    &planet,
    planet04_sprite_pict_rom.pictureInfo,
    planet04_sprite_pict_rom.paletteInfo,
    20,
    100
  );

  // Test forced sprite ID allocation
  nc_gfx_display_with_sprite_id(50); // Force player to use sprite index 50
  player_sprite_id = nc_gfx_init_and_display_animated_sprite(
    &player,
    player_sprite_sprt_rom.spriteInfo,
    player_sprite_sprt_rom.paletteInfo,
    10,
    200,
    PLAYER_SPRITE_ANIM_IDLE
  );

  // Note: nc_display_gfx_with_sprite_id is automatically reset to DISPLAY_GFX_WITH_SPRITE_ID_AUTO after use

  // Display sprite allocation information
  nc_log_init();
  nc_log_info_line("=== SPRITE ALLOCATION TEST ===");
  nc_log_info_line("Background sprite ID: %d", background_sprite_id);
  nc_log_info_line("Planet sprite ID: %d", planet_sprite_id);
  nc_log_info_line("Player sprite ID: %d (forced to 50)", player_sprite_id);
  nc_log_info_line("Free sprites available: %d", nc_sprite_manager_get_max_free_index());
  nc_log_info_line("Next free sprite index: %d", nc_sprite_manager_get_free_index());
  nc_log_info_line("Used sprites: %d", nc_sprite_manager_get_max_used_index());
  nc_log_info_line("=============================");

  while(1) {
    Position position, backgroundPosition;
    static WORD frame_counter = 0;

    nc_gpu_update();
    frame_counter++;

    // Display sprite info every 60 frames (1 second)
    if (frame_counter % 60 == 0) {
      nc_log_set_position(1, 10);
      nc_log_info_line("Frame: %d", frame_counter / 60);
      nc_log_info_line("Free sprites: %d", nc_sprite_manager_get_max_free_index());
      nc_log_info_line("Used sprites: %d", nc_sprite_manager_get_max_used_index());
      nc_log_info_line("Next free: %d", nc_sprite_manager_get_free_index());
    }

    nc_gfx_get_animated_sprite_position(&player, &position);
    if (nc_joypad_is_left(0) && position.x > 0) { nc_gfx_move_animated_sprite(&player, -1, 0); }
    if (nc_joypad_is_right(0) && position.x < 280) { nc_gfx_move_animated_sprite(&player, 1, 0); }
    if (nc_joypad_is_up(0) && position.y > 0) {
      nc_gfx_move_animated_sprite(&player, 0, -1);
      nc_gfx_set_animated_sprite_animation(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (nc_joypad_is_down(0) && position.y < 200) {
      nc_gfx_move_animated_sprite(&player, 0, 1);
      nc_gfx_set_animated_sprite_animation(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!nc_joypad_is_down(0) && !nc_joypad_is_up(0)) {
      nc_gfx_set_animated_sprite_animation(&player, PLAYER_SPRITE_ANIM_IDLE);
    }

    // Test sprite ID forcing with START button
    if (nc_joypad_is_start(0)) {
      static WORD sprite_cycle[] = {60, 70, 80, 90, 100, 110};
      static BYTE cycle_index = 0;

      WORD new_sprite_id = sprite_cycle[cycle_index];
      cycle_index = (cycle_index + 1) % 6; // Cycle through the array

      nc_log_set_position(1, 15);
      nc_log_info_line("START pressed - reallocating player");
      nc_log_info_line("Old sprite ID: %d", player_sprite_id);

      // Destroy current player
      nc_gfx_destroy_animated_sprite(&player);

      // Force new sprite ID (auto-reset after use)
      nc_gfx_display_with_sprite_id(new_sprite_id);
      player_sprite_id = nc_gfx_init_and_display_animated_sprite(
        &player,
        &player_sprite,
        &player_sprite_Palettes,
        position.x,
        position.y,
        PLAYER_SPRITE_ANIM_IDLE
      );

      nc_log_info_line("New sprite ID: %d", player_sprite_id);
      nc_log_info_line("Cycling to sprite ID: %d", sprite_cycle[cycle_index]);

      // Note: nc_display_gfx_with_sprite_id automatically reset to DISPLAY_GFX_WITH_SPRITE_ID_AUTO
    }

    nc_gfx_move_scroller(&background, 1, 0);
    nc_gfx_get_scroller_position(&background, &backgroundPosition);
    if (backgroundPosition.x > 512) {
      nc_gfx_set_scroller_position(
        &background,
        0,
        backgroundPosition.y
      );
    }
    nc_gfx_update_animated_sprite_animation(&player);
    if (nc_joypad_is_start(0) & nc_joypad_is_a(0)) {
      nc_gfx_destroy_animated_sprite(&player);
      nc_gfx_destroy_picture(&planet);
      nc_gfx_destroy_scroller(&background);
    }
  };
  
  return 0;
}
