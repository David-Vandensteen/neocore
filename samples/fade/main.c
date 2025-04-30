#include <neocore.h>
#include "externs.h"

// IN PROGRESS

// // D R0 G0 B0 R4 R3 R2 R1 G4 G3 G2 G1 B4 B3 B2 B1

// typedef struct RGBColor {
//     BYTE r, g, b;
// } RGBColor;

// BOOL joypad_is_start() {
//   return nc_joypad_is_start(0) || nc_joypad_is_start(1);
// }

// void debug_rgb_color(RGBColor color) {
//   nc_log_word("R", color.r);
//   nc_log_word("G", color.g);
//   nc_log_word("B", color.b);
// }

// WORD get_rgb_from_color(RGBColor color) {
//     WORD rgb565 = ((color.r >> 3) << 11) | ((color.g >> 2) << 5) | (color.b >> 3);
//     return rgb565;
// }

// RGBColor get_color_from_rgb(WORD rgb) {
//     RGBColor color;
//     color.r = ((rgb >> 11) & 0x1F) << 3;
//     color.g = ((rgb >> 5) & 0x3F) << 2;
//     color.b = (rgb & 0x1F) << 3;
//     return color;
// }

// static GFX_Picture playfield;
// static WORD playfield_fading_palette[16];

// void copy_word_array(WORD *source_array, WORD *destination_array, WORD depth) {
//   WORD i = depth;
//   for (i = 0; i < depth; i++) destination_array[i] = source_array[i];
// }

// static void init();
// static void display();
// static void update();

// static void init() {
//   WORD i = 0;
//   copy_word_array((WORD*) &playfield_asset_Palettes.data, (WORD*) &playfield_fading_palette, 16);

//   for (i = 0; i < 16; i++) {
//     RGBColor color = get_color_from_rgb(playfield_fading_palette[i]);
//     color.r = 0;
//     color.b = 0;
//     color.g = 0;
//     playfield_fading_palette[i] = get_rgb_from_color(color);
//   }

//   // init_gpu();
//   nc_init_gfx_picture(&playfield, &playfield_asset, &playfield_asset_Palettes);
//   nc_set_joypad_edge_mode(1);
// }

// static void display() {
//   nc_display_gfx_picture(&playfield, 0, 0);
// }

// static void update() {
//   if (nc_each_frame(60)) {
//     WORD i = 0;
//     nc_init_log();


//     // log_dword("frame", get_frame_counter());
//     // log_info("");

//     // log_info("COLOR 0");
//     // debug_rgb565_color(get_color_from_rgb565(playfield_fading_palette[0]));
//     // log_info("");

//     // log_info("COLOR 1");
//     // debug_rgb565_color(get_color_from_rgb565(playfield_fading_palette[1]));
//     // log_info("");

//     // log_info("COLOR 2");
//     // debug_rgb565_color(get_color_from_rgb565(playfield_fading_palette[2]));
//     // log_info("");

// for (i = 0; i < 16; i++) {
//     RGBColor current_color = get_color_from_rgb(playfield_fading_palette[i]);
//     RGBColor destination_color = get_color_from_rgb(playfield_asset_Palettes.data[i]);

//     nc_log_info("CUR");
//     debug_rgb_color(current_color);
//     nc_log_info("");

//     nc_log_info("DST");
//     debug_rgb_color(destination_color);
//     nc_log_info("");

//     if (current_color.r < destination_color.r) current_color.r += 1;
//     if (current_color.g < destination_color.g) current_color.g += 1;
//     if (current_color.b < destination_color.b) current_color.b += 1;

//     nc_log_info("TO APPLY");
//     debug_rgb_color(current_color);
//     nc_log_info("");

//     nc_log_info("TO APPLY");
//     nc_log_word("RGB", get_rgb_from_color(current_color));
//     nc_log_info("");

//     playfield_fading_palette[i] = get_rgb_from_color(current_color);

//     nc_log_info("APPLYIED");
//     debug_rgb_color(get_color_from_rgb(playfield_fading_palette[i]));
//     nc_log_info("");

//     nc_wait_vbl();
//     nc_pause(&joypad_is_start);
//     nc_init_log();
//   }
//     palJobPut(playfield.pictureDAT.basePalette, playfield_asset_Palettes.palCount, playfield_fading_palette);
//   }
// }

// int main(void) {
//   init();
//   display();
//   while(1) {
//     nc_update();
//     update();
//   };
//   return 0;
// }

static GFX_Picture playfield;

typedef struct RGBColor {
    BYTE r, g, b;
} RGBColor;

BOOL joypad_is_start() {
  return nc_joypad_is_start(0) || nc_joypad_is_start(1);
}

void debug_rgb_color(RGBColor color) {
  nc_log_word("R", color.r);
  nc_log_word("G", color.g);
  nc_log_word("B", color.b);
}

WORD get_rgb_from_color(RGBColor color) {
    WORD rgb565 = ((color.r >> 3) << 11) | ((color.g >> 2) << 5) | (color.b >> 3);
    return rgb565;
}

RGBColor get_color_from_rgb(WORD rgb) {
    RGBColor color;
    color.r = ((rgb >> 11) & 0x1F) << 3;
    color.g = ((rgb >> 5) & 0x3F) << 2;
    color.b = (rgb & 0x1F) << 3;
    return color;
}

void nc_log_palette_info(paletteInfo *paletteInfo) {
  WORD i = 0;
  for (i = 0; i < 16; i++) {
    nc_log_short("", &paletteInfo[i]);
  }
}

void nc_set_palette_color_by_int(int paletteNumber, int paletteIndex, int color) {
  int address = 0x400000 + (paletteNumber * 32) + (paletteIndex * 2);
  disableIRQ();
  volMEMWORD(address) = color;
  enableIRQ();
}

static void init();
static void display();
static void update();

static void init() {
  // nc_init_gfx_picture(&playfield, &playfield_asset, &playfield_asset_Palettes);
  nc_set_joypad_edge_mode(1);
}

static void display() {
  // nc_display_gfx_picture(&playfield, 0, 0);
}

static void update() {
  // nc_init_log();
  // nc_log_palette_info(&playfield_asset_Palettes.data);
  // asm("move #0xCF00,0x401FFE");
  nc_set_palette_color_by_int(255, 15, 0xCF00);

}

int main(void) {
  init();
  display();
  while(1) {
    nc_update();
    update();
    // nc_pause(&joypad_is_start);

  };
  return 0;
}
