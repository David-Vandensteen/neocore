#include <neocore.h>
#include "externs.h"

#define MENU_X          10
#define MENU_Y_DARK     10
#define MENU_Y_RED      MENU_Y_DARK + 2
#define MENU_Y_GREEN    MENU_Y_RED + 2
#define MENU_Y_BLUE     MENU_Y_GREEN + 2


#define cursorX MENU_X - 2
static WORD cursorY = MENU_Y_RED;
static RGB16 backdrop_color = {0x0, 0x7, 0x7, 0x7};

static void init();
static void display();
static void display_menu();
static void display_cursor();
static void display_rgb_values();

static void display_menu() {
  WORD packed_color;
  packed_color = nc_rgb16_to_packed_color16(backdrop_color);

  nc_set_position_log(5, 5);
  nc_log_info("RGB COLOR MIXER");
  nc_set_position_log(MENU_X, MENU_Y_DARK);
  nc_log_info("DARK :");
  nc_set_position_log(MENU_X, MENU_Y_RED);
  nc_log_info("RED :");
  nc_set_position_log(MENU_X, MENU_Y_GREEN);
  nc_log_info("GREEN :");
  nc_set_position_log(MENU_X, MENU_Y_BLUE);
  nc_log_info("BLUE :");
  nc_next_line_log();
  nc_log_packed_color16(packed_color);
  nc_next_line_log();
}

static void display_cursor() {
  nc_set_position_log(cursorX, cursorY);
  nc_log_info(">");
}

static void display_rgb_values() {
  nc_set_position_log(MENU_X + 10, MENU_Y_DARK);
  nc_log_info("%1X", backdrop_color.dark);

  nc_set_position_log(MENU_X + 10, MENU_Y_RED);
  nc_log_info("%1X", backdrop_color.r);

  nc_set_position_log(MENU_X + 10, MENU_Y_GREEN);
  nc_log_info("%1X", backdrop_color.g);

  nc_set_position_log(MENU_X + 10, MENU_Y_BLUE);
  nc_log_info("%1X", backdrop_color.b);
}

static void init() {
  nc_set_joypad_edge_mode(TRUE);
}

static void display() {
  nc_init_log();
  display_menu();
  display_cursor();
  display_rgb_values();
  nc_set_palette_backdrop_by_rgb16(backdrop_color);
}

int main(void) {
  init();
  display();
  while(1) {
    nc_update();
    if (nc_joypad_is_down(0) && cursorY < MENU_Y_BLUE) {
      cursorY += 2;
      display();
    } else if (nc_joypad_is_up(0) && cursorY > MENU_Y_DARK) {
      cursorY -= 2;
      display();
    } else if (nc_joypad_is_right(0)) {
      if (cursorY == MENU_Y_DARK) {
        backdrop_color.dark++;
      } else if (cursorY == MENU_Y_RED) {
        backdrop_color.r++;
      } else if (cursorY == MENU_Y_GREEN) {
        backdrop_color.g--;
      } else if (cursorY == MENU_Y_BLUE) {
        backdrop_color.b++;
      }
      display();
    } else if (nc_joypad_is_left(0)) {
      if (cursorY == MENU_Y_DARK) {
        backdrop_color.dark--;
      } else if (cursorY == MENU_Y_RED) {
        backdrop_color.r--;
      } else if (cursorY == MENU_Y_GREEN) {
        backdrop_color.g--;
      } else if (cursorY == MENU_Y_BLUE) {
        backdrop_color.b--;
      }
      display();
    }
  };
  return 0;
}
