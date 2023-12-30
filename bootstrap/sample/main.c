#include <neocore.h>
// #include "externs.h"

static void init();
static void display();
static void update();

static void init() {
  nc_init_gpu();
}

static void display() {

}

static void update() {
  nc_init_log();
  nc_log_info("HELLO NEO GEO !!!");
}

int main(void) {
  init();
  // display();
  while(1) {
    nc_wait_vbl();
    update();
    nc_close_vbl();
  };
  nc_close_vbl();
  return 0;
}
