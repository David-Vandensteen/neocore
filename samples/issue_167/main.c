#include <neocore.h>
#include "externs.h"

static bool menu() {
  static GFX_Picture menu_anime_girl_darker8;
  static WORD menu_sprite_id;

  nc_joypad_set_edge_mode(true);
  menu_sprite_id = nc_gfx_init_and_display_picture(
    &menu_anime_girl_darker8,
    &menu_anime_girl_darker8_img,
    &menu_anime_girl_darker8_img_Palettes,
    0,
    0
  );
  nc_log_init();  // Init log after displaying the image
  while (1) {
    nc_gpu_update();
    nc_log_set_position(10, 10);
    nc_log_info("PRESS START");
    nc_log_set_position(1, 1); // TODO not in screen ?
    nc_log_next_line();
    nc_log_info("Menu Sprite ID: ");
    nc_log_word(menu_sprite_id);
    if (nc_joypad_is_start(0) & nc_joypad_is_a(0)) {
      nc_gfx_destroy_picture(&menu_anime_girl_darker8);
      nc_gpu_update();
      return true;
    }
  }
}

static void game() {
  static GFX_Animated_Physic_Sprite player;
  static GFX_Picture alpha;
  static WORD player_sprite_id;

  nc_palette_set_backdrop_packed_color16(0x000F);
  nc_joypad_set_edge_mode(false);
  nc_log_init();  // Init log for game

  nc_gfx_display_with_sprite_id(1);
  nc_gfx_init_and_display_picture(
    &alpha,
    &alpha_img,
    &alpha_img_Palettes,
    100,
    100
  );

  nc_gpu_update();

  nc_gfx_display_with_sprite_id(1);
  player_sprite_id = nc_gfx_init_and_display_animated_physic_sprite(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    100,
    100,
    16,  // box_width
    16,  // box_height
    0,   // box_width_offset
    0,   // box_height_offset
    PLAYER_SPRITE_ANIM_IDLE
  );

  nc_gpu_update();
  nc_shrunk(player_sprite_id, player.gfx_animated_sprite.spriteInfoDAT->maxWidth, nc_gpu_get_shrunk_proportional_table(150));

  while(1) {
    Position position;

    nc_gpu_update();

    nc_log_set_position(10, 10);
    nc_log_info("Player Sprite ID: ");
    nc_log_word(player_sprite_id);

    // nc_gfx_get_animated_physic_sprite_position(&player, &position);
    // if (nc_joypad_is_left(0) && position.x > 0) { nc_gfx_move_animated_physic_sprite(&player, -1, 0); }
    // if (nc_joypad_is_right(0) && position.y < 280) { nc_gfx_move_animated_physic_sprite(&player, 1, 0); }
    // if (nc_joypad_is_up(0) && position.y > 0) {
    //   nc_gfx_move_animated_physic_sprite(&player, 0, -1);
    //   nc_gfx_set_animated_sprite_animation_physic(&player, PLAYER_SPRITE_ANIM_UP);
    // }
    // if (nc_joypad_is_down(0) && position.y < 200) {
    //   nc_gfx_move_animated_physic_sprite(&player, 0, 1);
    //   nc_gfx_set_animated_sprite_animation_physic(&player, PLAYER_SPRITE_ANIM_DOWN);
    // }
    // if (!nc_joypad_is_down(0) && !nc_joypad_is_up(0)) { nc_gfx_set_animated_sprite_animation_physic(&player, PLAYER_SPRITE_ANIM_IDLE); }
    // nc_gfx_update_animated_physic_sprite_animation(&player);
  }
}

int main(void) {
  if (menu()) {
    /* nc_gpu_clear_display(); // TODO reset sprite index table ? */
    nc_system_reset();
    game();
  }
  return 0;
}
