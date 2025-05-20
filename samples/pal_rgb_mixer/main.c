#include <neocore.h>
#include "externs.h"

#define MENU_X          10
#define MENU_Y_RED      10
#define MENU_Y_GREEN    MENU_Y_RED + 2
#define MENU_Y_BLUE     MENU_Y_GREEN + 2


#define cursorX MENU_X - 2
static WORD cursorY = MENU_Y_RED;
static RGB_Color backdrop_color = {0x7, 0x7, 0x7};

static void init();
static void display();
static void display_menu();
static void display_cursor();
static void display_rgb_values();

static void display_menu() {
  Hex_Packed_Color packed_color_text;
  WORD packed_color;

  packed_color = nc_rgb_to_packed_color(backdrop_color);
  nc_word_to_hex(packed_color, packed_color_text);

  nc_set_position_log(5, 5);
  nc_log_info("RGB COLOR MIXER");
  nc_set_position_log(MENU_X, MENU_Y_RED);
  nc_log_info("RED :");
  nc_set_position_log(MENU_X, MENU_Y_GREEN);
  nc_log_info("GREEN :");
  nc_set_position_log(MENU_X, MENU_Y_BLUE);
  nc_log_info("BLUE :");
  nc_log_info("");
  nc_log_info("PACKED COLOR : 0x");
  nc_log_info(packed_color_text);
  nc_log_info("");
  nc_log_word("PACKED COLOR :", nc_rgb_to_packed_color(backdrop_color));
}

static void display_cursor() {
  nc_set_position_log(cursorX, cursorY);
  nc_log_info(">");
}

static void display_rgb_values() {
  Hex_Color r, g, b;

  nc_byte_to_hex(backdrop_color.r, r);
  nc_byte_to_hex(backdrop_color.g, g);
  nc_byte_to_hex(backdrop_color.b, b);

  nc_set_position_log(MENU_X + 10, MENU_Y_RED);
  nc_log_info(r);

  nc_set_position_log(MENU_X + 10, MENU_Y_GREEN);
  nc_log_info(g);

  nc_set_position_log(MENU_X + 10, MENU_Y_BLUE);
  nc_log_info(b);
}

static void init() {
  nc_set_joypad_edge_mode(TRUE);
}

static void display() {
  nc_init_log();
  display_menu();
  display_cursor();
  display_rgb_values();
  nc_set_palette_backdrop_by_rgb_color(backdrop_color);
}

int main(void) {
  init();
  display();
  while(1) {
    nc_update();
    if (nc_joypad_is_down(0) && cursorY < MENU_Y_BLUE) {
      cursorY += 2;
      display();
    } else if (nc_joypad_is_up(0) && cursorY > MENU_Y_RED) {
      cursorY -= 2;
      display();
    } else if (nc_joypad_is_right(0)) {
      if (cursorY == MENU_Y_RED) {
        backdrop_color.r += 1;
      } else if (cursorY == MENU_Y_GREEN) {
        backdrop_color.g += 1;
      } else if (cursorY == MENU_Y_BLUE) {
        backdrop_color.b += 1;
      }
      display();
    } else if (nc_joypad_is_left(0)) {
      if (cursorY == MENU_Y_RED) {
        backdrop_color.r -= 1;
      } else if (cursorY == MENU_Y_GREEN) {
        backdrop_color.g -= 1;
      } else if (cursorY == MENU_Y_BLUE) {
        backdrop_color.b -= 1;
      }
      display();
    }
  };
  return 0;
}
