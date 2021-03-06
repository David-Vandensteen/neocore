#include <neocore.h>
#include <math.h>

NEOCORE_INIT

static void init();
static void display();
static void update();

static void init() {
  gpu_init();
}

static void display() {

}

static void update() {
  logger_init();
  logger_info("HELLO NEO GEO !!!");
}

int main(void) {
  init();
  while(1) {
    wait_vbl();
    update();
    SCClose();
  };
  SCClose();
  return 0;
}
