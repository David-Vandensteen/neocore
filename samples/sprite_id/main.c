#include <neocore.h>
#include "externs.h"

static GFX_Animated_Sprite player;
static GFX_Scroller background;
static GFX_Picture planet;

int main(void) {
  WORD background_sprite_id, planet_sprite_id, player_sprite_id;

  // Test automatic sprite allocation and store returned sprite indices
  background_sprite_id = nc_init_display_gfx_scroller(
    &background,
    &background_sprite,
    &background_sprite_Palettes,
    0,
    0
  );

  planet_sprite_id = nc_init_display_gfx_picture(
    &planet,
    &planet04_sprite,
    &planet04_sprite_Palettes,
    20,
    100
  );

  // Test forced sprite ID allocation
  nc_display_gfx_with_sprite_id(50); // Force player to use sprite index 50
  player_sprite_id = nc_init_display_gfx_animated_sprite(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    10,
    200,
    PLAYER_SPRITE_ANIM_IDLE
  );

  // Reset to automatic allocation for future sprites
  nc_display_gfx_with_sprite_id(0xFFFF);

  // Display sprite allocation information
  nc_init_log();
  nc_log_info_line("=== SPRITE ALLOCATION TEST ===");
  nc_log_info_line("Background sprite ID: %d", background_sprite_id);
  nc_log_info_line("Planet sprite ID: %d", planet_sprite_id);
  nc_log_info_line("Player sprite ID: %d (forced to 50)", player_sprite_id);
  nc_log_info_line("Free sprites available: %d", nc_get_max_free_sprite_index());
  nc_log_info_line("Next free sprite index: %d", nc_get_free_sprite_index());
  nc_log_info_line("Used sprites: %d", nc_get_max_sprite_index_used());
  nc_log_info_line("=============================");

  while(1) {
    Position position, backgroundPosition;
    static WORD frame_counter = 0;

    nc_update();
    frame_counter++;

    // Display sprite info every 60 frames (1 second)
    if (frame_counter % 60 == 0) {
      nc_set_position_log(1, 10);
      nc_log_info_line("Frame: %d", frame_counter / 60);
      nc_log_info_line("Free sprites: %d", nc_get_max_free_sprite_index());
      nc_log_info_line("Used sprites: %d", nc_get_max_sprite_index_used());
      nc_log_info_line("Next free: %d", nc_get_free_sprite_index());
    }

    nc_get_position_gfx_animated_sprite(&player, &position);
    if (nc_joypad_is_left(0) && position.x > 0) { nc_move_gfx_animated_sprite(&player, -1, 0); }
    if (nc_joypad_is_right(0) && position.x < 280) { nc_move_gfx_animated_sprite(&player, 1, 0); }
    if (nc_joypad_is_up(0) && position.y > 0) {
      nc_move_gfx_animated_sprite(&player, 0, -1);
      nc_set_animation_gfx_animated_sprite(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (nc_joypad_is_down(0) && position.y < 200) {
      nc_move_gfx_animated_sprite(&player, 0, 1);
      nc_set_animation_gfx_animated_sprite(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!nc_joypad_is_down(0) && !nc_joypad_is_up(0)) {
      nc_set_animation_gfx_animated_sprite(&player, PLAYER_SPRITE_ANIM_IDLE);
    }

    // Test sprite ID forcing with START button
    if (nc_joypad_is_start(0)) {
      static WORD sprite_cycle[] = {60, 70, 80, 90, 100, 110};
      static BYTE cycle_index = 0;

      WORD new_sprite_id = sprite_cycle[cycle_index];
      cycle_index = (cycle_index + 1) % 6; // Cycle through the array

      nc_set_position_log(1, 15);
      nc_log_info_line("START pressed - reallocating player");
      nc_log_info_line("Old sprite ID: %d", player_sprite_id);

      // Destroy current player
      nc_destroy_gfx_animated_sprite(&player);

      // Force new sprite ID
      nc_display_gfx_with_sprite_id(new_sprite_id);
      player_sprite_id = nc_init_display_gfx_animated_sprite(
        &player,
        &player_sprite,
        &player_sprite_Palettes,
        position.x,
        position.y,
        PLAYER_SPRITE_ANIM_IDLE
      );

      nc_log_info_line("New sprite ID: %d", player_sprite_id);
      nc_log_info_line("Cycling to sprite ID: %d", sprite_cycle[cycle_index]);

      // Reset to automatic allocation
      nc_display_gfx_with_sprite_id(0xFFFF);
    }

    nc_move_gfx_scroller(&background, 1, 0);
    nc_get_position_gfx_scroller(&background, &backgroundPosition);
    if (backgroundPosition.x > 512) {
      nc_set_position_gfx_scroller(
        &background,
        0,
        backgroundPosition.y
      );
    }
    nc_update_animation_gfx_animated_sprite(&player);
  };

  return 0;
}
