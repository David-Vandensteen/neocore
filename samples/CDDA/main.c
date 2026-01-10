#include <neocore.h>
#include <cdda.h>
#include "externs.h"

static void init();
static void display();
static void update();

static BOOL k7_direction = false;

static GFX_Picture k7;
static GFX_Scroller spectrum02;
static BYTE track_num = 2;
static BOOL isPause = false;

static void init() {
  nc_sound_play_cdda(track_num);
  nc_gfx_init_scroller(
    &spectrum02,
    spectrum02_sprite_scrl_rom.scrollerInfo,
    spectrum02_sprite_scrl_rom.paletteInfo 
  );
  nc_gfx_init_picture(
    &k7,
    k7_sprite_pict_rom.pictureInfo,
    k7_sprite_pict_rom.paletteInfo
  );
  nc_joypad_set_edge_mode(true);
}

static void display() {
  nc_gfx_display_scroller(&spectrum02, 0, 0);
  nc_gfx_display_picture(&k7, 30, 30);
}

static void update() {
  Position position_spectrum02;
  Position position_k7;

  nc_gfx_get_scroller_position(&spectrum02, &position_spectrum02);
  nc_gfx_get_picture_position(&k7, &position_k7);

  nc_log_init();
  nc_log_info("AUDIO TRACK : ");
  nc_log_byte(track_num - 1);
  if (nc_gpu_get_frame_number() % 2 == 0) {
    nc_gfx_move_scroller(&spectrum02, 1, 0);
    if (position_spectrum02.x > 960) nc_gfx_set_scroller_position(&spectrum02, 0, position_spectrum02.y);
  }
  if (nc_gpu_get_frame_number() % 5 == 0) {
    if (k7_direction) {
      nc_gfx_move_picture(&k7, 1, 0);
    } else {
      nc_gfx_move_picture(&k7, -1, 0);
    }
  }
  if (position_k7.x > 50) k7_direction = false;
  if (position_k7.x < 40) k7_direction = true;
  if (nc_joypad_is_left(0) && track_num > 2) nc_sound_play_cdda(--track_num);
  if (nc_joypad_is_right(0) && track_num < 5) nc_sound_play_cdda(++track_num);
  if (nc_joypad_is_a(0)) {
    if (!isPause) {
      nc_sound_pause_cdda();
      isPause = true;
    } else {
      nc_sound_resume_cdda();
      isPause = false;
    }
  }
}

int main(void) {
  init();
  display();

  while(1) {
    nc_gpu_update();;
    update();
  };

  return 0;
}
