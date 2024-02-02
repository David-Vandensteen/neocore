#include <neocore.h>
#include "externs.h"

#define PEAK_MASK_VECTOR_MAX 6
#define X 0
#define Y 1

// todo (minor) - improve neocore collision detection (bug on top of peak)

static Vec2short peak_mask[PEAK_MASK_VECTOR_MAX];
static GFX_Animated_Sprite_Physic player;

static GFX_Picture peak;
static short peak_position[2] = { 100, 80 };

static void init_mask();
static void init();
static void display();
static void display_mask_debug();
static void update();
static void update_player();

static void init() {
  init_mask();
  nc_init_gfx_animated_sprite_physic(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    10,
    10,
    0,
    0
  );
  nc_init_gfx_picture(&peak, &peak_sprite, &peak_sprite_Palettes);
}

static void display() {
  nc_display_gfx_picture(&peak, peak_position[X], peak_position[Y]);
  nc_display_gfx_animated_sprite_physic(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  display_mask_debug();
}

static void display_mask_debug() {
  BYTE i = 0;
  GFX_Picture p;
  for (i = 0; i < PEAK_MASK_VECTOR_MAX; i++) {
    nc_init_gfx_picture(&p, &dot_sprite, &dot_sprite_Palettes);
    nc_display_gfx_picture(&p, peak_mask[i].x, peak_mask[i].y);
  }
}

static void init_mask() {
  peak_mask[0].x = 53 + peak_position[X];
  peak_mask[0].y = 5 + peak_position[Y];

  peak_mask[1].x = 67 + peak_position[X];
  peak_mask[1].y = 5 + peak_position[Y];

  peak_mask[2].x = 70 + peak_position[X];
  peak_mask[2].y = 80 + peak_position[Y];

  peak_mask[3].x = 80 + peak_position[X];
  peak_mask[3].y = 136 + peak_position[Y];

  peak_mask[4].x = 6 + peak_position[X];
  peak_mask[4].y = 136 + peak_position[Y];

  peak_mask[5].x = 35 + peak_position[X];
  peak_mask[5].y = 55 + peak_position[Y];
}

static void update_player() {
  Vec2short position;
  position = nc_get_position_gfx_animated_sprite_physic(player);
  if (nc_joypad_is_left(0) && position.x > 0) { nc_move_gfx_animated_sprite_physic(&player, -1, 0); }
  if (nc_joypad_is_right(0) && position.x < 280) { nc_move_gfx_animated_sprite_physic(&player, 1, 0); }
  if (nc_joypad_is_up(0) && position.y > 0) {
    nc_move_gfx_animated_sprite_physic(&player, 0, -1);
    nc_set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_UP);
  }
  if (nc_joypad_is_down(0) && position.y < 200) {
    nc_move_gfx_animated_sprite_physic(&player, 0, 1);
    nc_set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_DOWN);
  }
  if (!nc_joypad_is_down(0) && !nc_joypad_is_up(0)) { nc_set_animation_gfx_animated_sprite_physic(&player, PLAYER_SPRITE_ANIM_IDLE); }
  if (nc_vectors_collide(&player.box, peak_mask, PEAK_MASK_VECTOR_MAX)) {
      if (nc_get_frame_counter() % 20) { nc_hide_gfx_animated_sprite_physic(&player); } else { nc_show_gfx_animated_sprite_physic(&player); }
  } else { nc_show_gfx_animated_sprite_physic(&player); }
  nc_update_animation_gfx_animated_sprite_physic(&player);
}

static void update() {
  update_player();
}

int main(void) {
  init();
  display();

  while(1) {
    nc_update();
    update();
  };

  return 0;
}
