#include <neocore.h>
#include "externs.h"

// D R0 G0 B0 R4 R3 R2 R1 G4 G3 G2 G1 B4 B3 B2 B1

typedef struct RGBColor {
    BYTE r, g, b;
} RGBColor;

void debug_rgb_color(RGBColor color) {
  log_word("R", color.r);
  log_word("G", color.g);
  log_word("B", color.b);
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

static GFX_Picture playfield;
static WORD playfield_fading_palette[16];

void copy_word_array(WORD *source_array, WORD *destination_array, WORD depth) {
  WORD i = depth;
  for (i = 0; i < depth; i++) destination_array[i] = source_array[i];
}

static void init();
static void display();
static void update();

static void init() {
  WORD i = 0;
  copy_word_array((WORD*) &playfield_asset_Palettes.data, (WORD*) &playfield_fading_palette, 16);

  for (i = 0; i < 16; i++) {
    RGBColor color = get_color_from_rgb(playfield_fading_palette[i]);
    color.r = 0;
    color.b = 0;
    color.g = 0;
    playfield_fading_palette[i] = get_rgb_from_color(color);
  }

  init_gpu();
  init_gfx_picture(&playfield, &playfield_asset, &playfield_asset_Palettes);
}

static void display() {
  display_gfx_picture(&playfield, 0, 0);
}

static void update() {
  if (each_frame(60)) {
    WORD i = 0;
    init_log();


    // log_dword("frame", get_frame_counter());
    // log_info("");

    // log_info("COLOR 0");
    // debug_rgb565_color(get_color_from_rgb565(playfield_fading_palette[0]));
    // log_info("");

    // log_info("COLOR 1");
    // debug_rgb565_color(get_color_from_rgb565(playfield_fading_palette[1]));
    // log_info("");

    // log_info("COLOR 2");
    // debug_rgb565_color(get_color_from_rgb565(playfield_fading_palette[2]));
    // log_info("");

for (i = 0; i < 16; i++) {
    RGBColor current_color = get_color_from_rgb(playfield_fading_palette[i]);
    RGBColor destination_color = get_color_from_rgb(playfield_asset_Palettes.data[i]);

    log_info("CUR");
    debug_rgb_color(current_color);
    log_info("");

    log_info("DST");
    debug_rgb_color(destination_color);
    log_info("");

    if (current_color.r < destination_color.r) current_color.r += 1;
    if (current_color.g < destination_color.g) current_color.g += 1;
    if (current_color.b < destination_color.b) current_color.b += 1;

    log_info("TO APPLY");
    debug_rgb_color(current_color);
    log_info("");

    log_info("TO APPLY");
    log_word("RGB", get_rgb_from_color(current_color));
    log_info("");

    playfield_fading_palette[i] = get_rgb_from_color(current_color);

    log_info("APPLYIED");
    debug_rgb_color(get_color_from_rgb(playfield_fading_palette[i]));
    log_info("");

    wait_vbl();
    pause(&joypad_0_is_start);
  }
    palJobPut(playfield.pictureDAT.basePalette, playfield_asset_Palettes.palCount, playfield_fading_palette);
  }
}

int main(void) {
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
