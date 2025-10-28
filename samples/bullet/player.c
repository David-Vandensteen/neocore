/*
  David Vandensteen
  2020
*/

#include <neocore.h>
#include "externs.h"
#include "player.h"
#include "bullet_player.h"

static GFX_Animated_Physic_Sprite player_sprite;

void player_init() {
  nc_gfx_init_animated_physic_sprite(&player_sprite, &player_img, &player_img_Palettes, 48, 16, 0, 0);
  bullet_player_init();
}

void player_display(short x, short y) {
  nc_gfx_display_animated_physic_sprite(&player_sprite, x, y, PLAYER_IMG_ANIM_IDLE);
  bullet_player_display(x, y);
}

void player_update() {
  Position position;
  nc_gfx_get_animated_physic_sprite_position(&player_sprite, &position);
  nc_gfx_update_animated_physic_sprite_animation(&player_sprite);
  if (nc_joypad_is_up(0) && position.y > get_player_min_y()) {
    nc_gfx_move_animated_physic_sprite(&player_sprite, 0, -get_player_speed());
    nc_gfx_set_animated_sprite_animation_physic(&player_sprite, PLAYER_IMG_ANIM_UP);
  }
  if (nc_joypad_is_down(0) && position.y < get_player_max_y()) {
    nc_gfx_move_animated_physic_sprite(&player_sprite, 0, get_player_speed());
    nc_gfx_set_animated_sprite_animation_physic(&player_sprite, PLAYER_IMG_ANIM_DOWN);
  }
  if (nc_joypad_is_left(0) && position.x > get_player_min_x()) nc_gfx_move_animated_physic_sprite(&player_sprite, -get_player_speed(), 0);
  if (nc_joypad_is_right(0) && position.x < get_player_max_x()) nc_gfx_move_animated_physic_sprite(&player_sprite, get_player_speed(), 0);

  if (!nc_joypad_is_down(0) && !nc_joypad_is_up(0)) nc_gfx_set_animated_sprite_animation_physic(&player_sprite, PLAYER_IMG_ANIM_IDLE);
  bullet_player_update(nc_joypad_is_a(0), position.x, position.y);
}
