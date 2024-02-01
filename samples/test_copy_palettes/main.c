#include <neocore.h>
#include "externs.h"

static WORD duplicated_palette[16];

void copy_word_array(WORD *source_array, WORD *destination_array, WORD depth) {
  WORD i = depth;
  for (i = 0; i < depth; i++) destination_array[i] = source_array[i];
}

static void init();
static void display();
static void update();

static void init() {
  copy_word_array((WORD*) &logo_Palettes.data, (WORD*) &duplicated_palette, 16);
}

static void display() {}

static void update() {
  if (nc_each_frame(60)) {
    nc_init_log();
    nc_log_word("SRC 0", logo_Palettes.data[0]);
    nc_log_word("DST 0", duplicated_palette[0]);
    nc_log_info("");
    nc_log_word("SRC 1", logo_Palettes.data[1]);
    nc_log_word("DST 1", duplicated_palette[1]);
  }
}

int main(void) {
  init();

  while(1) {
    nc_update();
    update();
  };

  return 0;
}
