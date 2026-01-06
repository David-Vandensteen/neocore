#include <neocore.h>
#include "externs.h"

static GFX_Physic_Picture asteroid;
static Position position;

static void init();
static void display();
static void update();

static void init() {
  nc_gfx_init_physic_picture(
    &asteroid,
    asteroid_asset_pict_rom.pictureInfo,
    asteroid_asset_pict_rom.paletteInfo,
    0, 0, 0, 0,
    AUTOBOX
  );
}

static void display() {
  nc_gfx_display_physic_picture(&asteroid, 100, 100);
}

static void update() {
  const DWORD accumulator = 200;
  DWORD frame_seq = accumulator;

  nc_log_init();

  if (nc_gpu_get_frame_number() < frame_seq) {
    nc_log_info_line("INIT GPP");
    nc_log_info("DISPLAY GPP AT 100 100");
  }

  frame_seq += accumulator;

  if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
    nc_log_info("SET POS GPP 150 150");
    nc_gfx_set_physic_picture_position(&asteroid, 150, 150);
  }

  frame_seq += accumulator;

  if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
    nc_gfx_get_physic_picture_position(&asteroid, &position);
    if (position.x < 0) {
      nc_gfx_set_physic_picture_position(&asteroid, 150, 150);
    } else {
      nc_log_info("MOVE GPP -1 -1");
      nc_gfx_move_physic_picture(&asteroid, -1, -1);
    }
  }

  frame_seq += accumulator;

  if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
    nc_log_info_line("GET X AND Y GPP");
    nc_gfx_set_physic_picture_position(&asteroid, 181, 57);
    nc_gfx_get_physic_picture_position(&asteroid, &position);
    nc_log_info_line("X: %d", position.x);
    nc_log_info("Y: %d", position.y);
  }

  frame_seq += accumulator;

  if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
    nc_log_info("HIDE GPP");
    nc_gfx_hide_physic_picture(&asteroid);
  }

  frame_seq += accumulator;

  if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
    nc_log_info("SHOW GPP");
    nc_gfx_show_physic_picture(&asteroid);
  }

  frame_seq += accumulator;

  if (nc_gpu_get_frame_number() >= (frame_seq - accumulator) && nc_gpu_get_frame_number() < frame_seq) {
    nc_log_info("DESTROY GPP");
    nc_gfx_destroy_physic_picture(&asteroid);
  }

  frame_seq += accumulator;

  if (nc_gpu_get_frame_number() >= (frame_seq - accumulator)) {
    nc_log_info("TEST GPP END");
  }
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
