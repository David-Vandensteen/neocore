#include <neocore.h>
#include "externs.h"

/* Clone de nc_shrunk avec la méthode originale NeoCore (addition) */
static void nc_shrunk_old_method(WORD base_sprite, WORD max_width, WORD value) {
  WORD cur_addr = 0x8000 + base_sprite;
  WORD addr_end = 0x8000 + base_sprite + max_width;
  while (cur_addr < addr_end) {
    SC234Put(cur_addr, value);
    cur_addr++;
  }
}

/* Clone de nc_shrunk avec la méthode DATlib 0.3 (OR) */
static void nc_shrunk_new_method(WORD base_sprite, WORD max_width, WORD value) {
  WORD cur_addr = VRAM_SHRINK_ADDR(base_sprite);
  WORD addr_end = VRAM_SHRINK_ADDR(base_sprite + max_width);
  while (cur_addr < addr_end) {
    SC234Put(cur_addr, value);
    cur_addr++;
  }
}

/* Test simple des deux méthodes avec affichage */
static void test_shrunk_methods() {
  static GFX_Picture test_picture;
  WORD sprite_id;
  WORD width = 4;

  /* Initialisation et affichage d'un sprite */
  sprite_id = nc_init_display_gfx_picture(
    &test_picture,
    &menu_anime_girl_darker8_img,
    &menu_anime_girl_darker8_img_Palettes,
    100,
    100
  );

  nc_init_log();
  nc_set_position_log(1, 1);
  nc_log_info_line("=== TEST SHRUNK METHODS ===");
  nc_log_info("Using sprite ID: ");
  nc_log_word(sprite_id);
  nc_log_next_line();
  nc_log_info_line("");

  nc_log_info_line("Sprite normal. Press A for old method...");
  while (!nc_joypad_is_a(0)) { nc_update(); }

  nc_log_info_line("1. Old method (0x8000 + i)");
  nc_shrunk_old_method(sprite_id, width, 0x88); /* Shrink 50% */
  nc_log_info_line("Applied! Press B for new method...");
  while (!nc_joypad_is_b(0)) { nc_update(); }

  nc_log_info_line("2. New method (VRAM_SHRINK_ADDR)");
  nc_shrunk_new_method(sprite_id, width, 0x88); /* Shrink 50% */
  nc_log_info_line("Applied!");
  nc_log_info_line("");

  nc_log_info_line("Press START to continue...");
  while (!nc_joypad_is_start(0)) { nc_update(); }
}

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
    if (nc_joypad_is_start(0)) {
      nc_destroy_gfx_picture(&menu_anime_girl_darker8);
      nc_update();
      return true;
    }
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

  // nc_shrunk(player_sprite_id, player.gfx_animated_sprite.spriteInfoDAT->maxWidth, nc_get_shrunk_proportional_table(150));

  /* TESTS DES MÉTHODES SHRUNK - DÉCOMMENTEZ UNE SEULE LIGNE : */

  /* Test ancienne méthode (NeoCore actuel) */
  // nc_shrunk_old_method(player_sprite_id, player.gfx_animated_sprite.spriteInfoDAT->maxWidth, 0x88);

  /* Test nouvelle méthode (DATlib 0.3) */
  nc_shrunk_new_method(player_sprite_id, player.gfx_animated_sprite.spriteInfoDAT->maxWidth, nc_get_shrunk_proportional_table(150));

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
    /* nc_clear_display(); // TODO reset sprite index table ? */
    nc_reset();
    game();
  }
  return 0;
}
