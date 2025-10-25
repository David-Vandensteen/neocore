#include <neocore.h>
#include "externs.h"

#define PEAK_MASK_VECTOR_MAX 6
#define X 0
#define Y 1

// todo (minor) - improve neocore collision detection (bug on top of peak)

static Position peak_mask[PEAK_MASK_VECTOR_MAX];
static GFX_Animated_Physic_Sprite player;

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
  nc_gfx_init_animated_physic_sprite(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    10,
    10,
    0,
    0
  );
  nc_gfx_init_picture(&peak, &peak_sprite, &peak_sprite_Palettes);
}

static void display() {
  nc_gfx_display_picture(&peak, peak_position[X], peak_position[Y]);
  nc_gfx_display_animated_physic_sprite(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  display_mask_debug();
}

static void display_mask_debug() {
  BYTE i = 0;
  GFX_Picture p;
  for (i = 0; i < PEAK_MASK_VECTOR_MAX; i++) {
    nc_gfx_init_picture(&p, &dot_sprite, &dot_sprite_Palettes);
    nc_gfx_display_picture(&p, peak_mask[i].x, peak_mask[i].y);
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
  Position position;
  nc_gfx_get_animated_physic_sprite_position(&player, &position);
  if (nc_joypad_is_left(0) && position.x > 0) { nc_gfx_move_animated_physic_sprite(&player, -1, 0); }
  if (nc_joypad_is_right(0) && position.x < 280) { nc_gfx_move_animated_physic_sprite(&player, 1, 0); }
  if (nc_joypad_is_up(0) && position.y > 0) {
    nc_gfx_move_animated_physic_sprite(&player, 0, -1);
    nc_gfx_set_animated_sprite_animation_physic(&player, PLAYER_SPRITE_ANIM_UP);
  }
  if (nc_joypad_is_down(0) && position.y < 200) {
    nc_gfx_move_animated_physic_sprite(&player, 0, 1);
    nc_gfx_set_animated_sprite_animation_physic(&player, PLAYER_SPRITE_ANIM_DOWN);
  }
  if (!nc_joypad_is_down(0) && !nc_joypad_is_up(0)) { nc_gfx_set_animated_sprite_animation_physic(&player, PLAYER_SPRITE_ANIM_IDLE); }
  if (nc_math_vectors_is_collide(&player.box, peak_mask, PEAK_MASK_VECTOR_MAX)) {
      if ((nc_gpu_get_frame_number() % 20) < 10) { nc_gfx_hide_animated_physic_sprite(&player); } else { nc_gfx_show_animated_physic_sprite(&player); }
  } else { nc_gfx_show_animated_physic_sprite(&player); }
  nc_gfx_update_animated_physic_sprite_animation(&player);
}

static void update() {
  update_player();
}

int main(void) {
  init();
  display();

  while(1) {
    nc_gpu_update();
    update();
  };

  return 0;
}
