#include <neocore.h>
// #include "externs.h"

static void init();
static void display();
static void update();

static void init() {
  gpu_init();
}

static void display() {

}

static void update() {
  init_log();
  log_info("HELLO NEO GEO !!!");
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
