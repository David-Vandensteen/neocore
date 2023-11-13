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
  init_gpu();
  copy_word_array((WORD*) &logo_Palettes.data, (WORD*) &duplicated_palette, 16);
}

static void display() {

}

static void update() {
  if (each_frame(60)) {
    init_log();
    log_word("SRC 0", logo_Palettes.data[0]);
    log_word("DST 0", duplicated_palette[0]);
    log_info("");
    log_word("SRC 1", logo_Palettes.data[1]);
    log_word("DST 1", duplicated_palette[1]);
  }
}

int main(void) {
  init();
  // display();
  while(1) {
    wait_vbl();
    update();
    close_vbl();
  };
  close_vbl();
  return 0;
}
