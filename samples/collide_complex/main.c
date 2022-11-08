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
  init_gasp(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    10,
    10,
    0,
    0
  );
  init_gp(&peak, &peak_sprite, &peak_sprite_Palettes);
}

static void display() {
  display_gp(&peak, peak_position[X], peak_position[Y]);
  display_gasp(&player, 10, 10, PLAYER_SPRITE_ANIM_IDLE);
  display_mask_debug();
}

static void display_mask_debug() {
  BYTE i = 0;
  GFX_Picture p;
  for (i = 0; i < PEAK_MASK_VECTOR_MAX; i++) {
    init_gp(&p, &dot_sprite, &dot_sprite_Palettes);
    display_gp(&p, peak_mask[i].x, peak_mask[i].y);
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
  update_joypad_p1();
  if (joypad_p1_is_left() && get_x_gasp(player) > 0) { move_gasp(&player, -1, 0); }
  if (joypad_p1_is_right() && get_x_gasp(player) < 280) { move_gasp(&player, 1, 0); }
  if (joypad_p1_is_up() && get_y_gasp(player) > 0) {
    move_gasp(&player, 0, -1);
    set_anim_gasp(&player, PLAYER_SPRITE_ANIM_UP);
  }
  if (joypad_p1_is_down() && get_y_gasp(player) < 200) {
    move_gasp(&player, 0, 1);
    set_anim_gasp(&player, PLAYER_SPRITE_ANIM_DOWN);
  }
  if (!joypad_p1_is_down() && !joypad_p1_is_up()) { set_anim_gasp(&player, PLAYER_SPRITE_ANIM_IDLE); }
  if (vectors_collide(&player.box, peak_mask, PEAK_MASK_VECTOR_MAX)) {
      if (get_frame_counter() % 20) { hide_gasp(&player); } else { show_gasp(&player); }
  } else { show_gasp(&player); }
  update_anim_gasp(&player);
}

static void update() {
  update_player();
}

int main(void) {
  init_gpu();
  init();
  display();
  while(1) {
    wait_vbl();
    update();
    close_vbl();
  };
  close_vbl();
  return 0;
}
