#include <neocore.h>
#include <math.h>

NEOCORE_INIT

static void init();
static void display();
static void update();

static void init() {
  cdda_play(3);
  GPU_INIT
  wait_vbl_max(1000);
  cdda_play(4);
}

static void display() {
}

static void update() {
  logger_init();
  logger_info("HELLO NEO GEO !!!");
}

int main(void) {
  init();
  // display();
  while(1) {
    WAIT_VBL
    update();
    SCClose();
  };
  SCClose();
  return 0;
}
