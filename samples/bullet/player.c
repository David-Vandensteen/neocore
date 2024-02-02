/*
  David Vandensteen
  2020
*/

#include <neocore.h>
#include "externs.h"
#include "player.h"
#include "bullet_player.h"

static GFX_Animated_Sprite_Physic player_sprite;

void player_init() {
  nc_init_gfx_animated_sprite_physic(&player_sprite, &player_img, &player_img_Palettes, 48, 16, 0, 0);
  bullet_player_init();
}

void player_display(short x, short y) {
  nc_display_gfx_animated_sprite_physic(&player_sprite, x, y, PLAYER_IMG_ANIM_IDLE);
  bullet_player_display(x, y);
}

void player_update() {
  Vec2short position = nc_get_position_gfx_animated_sprite_physic(player_sprite);
  nc_update_animation_gfx_animated_sprite_physic(&player_sprite);
  if (nc_joypad_is_up(0) && position.y > get_player_min_y()) {
    nc_move_gfx_animated_sprite_physic(&player_sprite, 0, -get_player_speed());
    nc_set_animation_gfx_animated_sprite_physic(&player_sprite, PLAYER_IMG_ANIM_UP);
  }
  if (nc_joypad_is_down(0) && position.y < get_player_max_y()) {
    nc_move_gfx_animated_sprite_physic(&player_sprite, 0, get_player_speed());
    nc_set_animation_gfx_animated_sprite_physic(&player_sprite, PLAYER_IMG_ANIM_DOWN);
  }
  if (nc_joypad_is_left(0) && position.x > get_player_min_x()) nc_move_gfx_animated_sprite_physic(&player_sprite, -get_player_speed(), 0);
  if (nc_joypad_is_right(0) && position.x < get_player_max_x()) nc_move_gfx_animated_sprite_physic(&player_sprite, get_player_speed(), 0);

  if (!nc_joypad_is_down(0) && !nc_joypad_is_up(0)) nc_set_animation_gfx_animated_sprite_physic(&player_sprite, PLAYER_IMG_ANIM_IDLE);
  bullet_player_update(nc_joypad_is_a(0), position.x, position.y);
}
