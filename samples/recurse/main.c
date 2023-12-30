#include <neocore.h>
#include "lib/hello.h"
// #include "externs.h"

static void init();
static void display();
static void update();

static void init() {
  nc_init_gpu();
}

static void display() {}

static void update() {
  display_hello();
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
