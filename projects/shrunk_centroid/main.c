#include <neocore.h>
#include "externs.h"

NEOCORE_INIT

#define LOGO1_POSITION_CENTER_X_INIT 160
#define LOGO3_POSITION_CENTER_Y_INIT 100

static Image logo1, logo2, logo3;

static BYTE logo1_shrunk_x = 0xF;
static short logo1_shrunk_inc = -1;

static BYTE logo3_shrunk_y = 0xFF;
static short logo3_shrunk_inc = -1;

static Vec2short logo1_position_center, logo2_position_center, logo3_position_center;

static WORD shrunkTableIndex = 0;

static void init();
static void display();
static void update();
static void update_logo1();
static void update_logo2();
static void update_logo3();

static void init() {
  logger_init();
  vec2short_init(&logo1_position_center, LOGO1_POSITION_CENTER_X_INIT, 30);
  vec2short_init(&logo2_position_center, 160, 180);
  vec2short_init(&logo3_position_center, 160, LOGO3_POSITION_CENTER_Y_INIT);
  image_init(&logo1, &logo_sprite, &logo_sprite_Palettes);
  image_init(&logo2, &logo_sprite, &logo_sprite_Palettes);
  image_init(&logo3, &logo_sprite, &logo_sprite_Palettes);
}

static void display() {
  image_display(&logo1, logo1_position_center.x, logo1_position_center.y);
  image_display(&logo2, logo2_position_center.x, logo2_position_center.y);
  image_display(&logo3, logo3_position_center.x, logo3_position_center.y);
  logger_info("HORIZONTAL SHRUNK");
  logger_set_position(1, 11);
  logger_info("VERTICAL SHRUNK");
  logger_set_position(1, 20);
  logger_info("PROPORTIONAL SHRUNK");
}

static void update() {
  if (DAT_frameCounter % 5 == 0) update_logo1();
  update_logo2();
  update_logo3();
}

static void update_logo1() { // Horizontal
  logo1_shrunk_x += logo1_shrunk_inc;
  image_shrunk_centroid(&logo1, (short)logo1_position_center.x, (short)logo1_position_center.y, shrunk_forge(logo1_shrunk_x, 0xFF));
  if (logo1_shrunk_x == 0) {
    logo1_shrunk_inc = 1;
    logo1_position_center.x = LOGO1_POSITION_CENTER_X_INIT;
  } else {
    if (logo1_shrunk_x >= 0xF) {
      logo1_shrunk_inc = -1;
    }
  }
}

static void update_logo2() { // Proportional
  image_shrunk_centroid(&logo2, (short)logo2_position_center.x, (short)logo2_position_center.y, get_shrunk_proportional_table(shrunkTableIndex));
  shrunkTableIndex++;
  if (shrunkTableIndex >= SHRUNK_TABLE_PROP_SIZE) shrunkTableIndex = 0;
}

static void update_logo3() { // Vertical
  logo3_shrunk_y += logo3_shrunk_inc;
  image_shrunk_centroid(&logo3, (short)logo3_position_center.x, (short)logo3_position_center.y, shrunk_forge(0XF ,logo3_shrunk_y));
  if (logo3_shrunk_y == 0) {
    logo3_shrunk_inc = 1;
    logo3_position_center.y = LOGO3_POSITION_CENTER_Y_INIT;
  } else {
    if (logo3_shrunk_y >= 0xFF) {
      logo3_shrunk_inc = -1;
    }
  }
}

int main(void) {
  gpu_init();
  init();
  display();
  while(1) {
    wait_vbl();
    update();
    SCClose();
  };
  SCClose();
  return 0;
}
