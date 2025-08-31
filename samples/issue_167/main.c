#include <neocore.h>
#include "externs.h"


static bool menu() {
  static GFX_Picture menu_anime_girl_darker8;
  static WORD menu_sprite_id;

  nc_set_joypad_edge_mode(true);
  menu_sprite_id = nc_init_display_gfx_picture(
    &menu_anime_girl_darker8,
    &menu_anime_girl_darker8_img,
    &menu_anime_girl_darker8_img_Palettes,
    0,
    0
  );
  nc_init_log();  // Init log after displaying the image
  while (1) {
    nc_update();
    nc_set_position_log(10, 10);
    nc_log_info("PRESS START");
    nc_set_position_log(1, 1); // TODO not in screen ?
    nc_log_next_line();
    nc_log_info("Menu Sprite ID: ");
    nc_log_word(menu_sprite_id);
    if (nc_joypad_is_start(0)) return true;
  }
}

static void game() {
  static GFX_Animated_Sprite_Physic player;
  static WORD player_sprite_id;

  nc_set_joypad_edge_mode(false);
  nc_init_log();  // Init log for game

  player_sprite_id = nc_init_display_gfx_animated_sprite_physic(
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

  nc_shrunk(player_sprite_id, player.gfx_animated_sprite.spriteInfoDAT->maxWidth, nc_get_shrunk_proportional_table(150));

  while(1) {
    Position position;

    nc_update();

    // Display sprite ID each frame
    nc_set_position_log(10, 10);
    nc_log_info("Player Sprite ID: ");
    nc_log_word(player_sprite_id);

    nc_get_position_gfx_animated_sprite_physic(&player, &position);
    if (nc_joypad_is_left(0) && position.x > 0) { nc_move_gfx_animated_sprite_physic(&player, -1, 0); }
    if (nc_joypad_is_right(0) && position.y < 280) { nc_move_gfx_animated_sprite_physic(&player, 1, 0); }
    if (nc_joypad_is_up(0) && position.y > 0) {
      nc_move_gfx_animated_sprite_physic(&player, 0, -1);
      nc_set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_UP);
    }
    if (nc_joypad_is_down(0) && position.y < 200) {
      nc_move_gfx_animated_sprite_physic(&player, 0, 1);
      nc_set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_DOWN);
    }
    if (!nc_joypad_is_down(0) && !nc_joypad_is_up(0)) { nc_set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_IDLE); }
    nc_update_animation_gfx_animated_sprite_physic(&player);
  }
}

int main(void) {
  if (menu()) {
    // nc_clear_display(); // TODO reset sprite index table ?
    nc_reset();
    game();
  }
  return 0;
}
