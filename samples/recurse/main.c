#include <neocore.h>
#include "lib/hello.h"
// #include "externs.h"

static void init();
static void display();
static void update();

static void init() {}

static void display() {}

static void update() {
  display_hello();
}

int main(void) {
  init();

  while(1) {
    nc_update();
    update();
  };

  return 0;
}
