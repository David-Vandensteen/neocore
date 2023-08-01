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
  init_gfx_animated_sprite_physic(&player_sprite, &player_img, &player_img_Palettes, 48, 16, 0, 0);
  bullet_player_init();
}

void player_display(short x, short y) {
  display_gfx_animated_sprite_physic(&player_sprite, x, y, PLAYER_IMG_ANIM_IDLE);
  bullet_player_display(x, y);
}

void player_update() {
  update_animation_gfx_animated_sprite_physic(&player_sprite);
  update_joypad_p1();
  if (joypad_p1_is_up() && get_y_gasp(player_sprite) > get_player_min_y()) {
    move_gfx_animated_sprite_physic(&player_sprite, 0, -get_player_speed());
    set_animation_gfx_animated_sprite_physic(&player_sprite, PLAYER_IMG_ANIM_UP);
  }
  if (joypad_p1_is_down() && get_y_gfx_animated_sprite_physic(player_sprite) < get_player_max_y()) {
    move_gfx_animated_sprite_physic(&player_sprite, 0, get_player_speed());
    set_animation_gfx_animated_sprite_physic(&player_sprite, PLAYER_IMG_ANIM_DOWN);
  }
  if (joypad_p1_is_left() && get_x_gfx_animated_sprite_physic(player_sprite) > get_player_min_x()) move_gfx_animated_sprite_physic(&player_sprite, -get_player_speed(), 0);
  if (joypad_p1_is_right() && get_x_gfx_animated_sprite_physic(player_sprite) < get_player_max_x()) move_gfx_animated_sprite_physic(&player_sprite, get_player_speed(), 0);

  if (!joypad_p1_is_down() && !joypad_p1_is_up()) set_animation_gfx_animated_sprite_physic(&player_sprite, PLAYER_IMG_ANIM_IDLE);
  bullet_player_update(joypad_p1_is_a(), get_x_gfx_animated_sprite_physic(player_sprite), get_y_gfx_animated_sprite_physic(player_sprite));
}
