#include <neocore.h>
#include <math.h>
#include "player.h"
#include "asteroid.h"

static void init();
static void display();
static void update();

static void init() {
  nc_init_gpu();
  player_init();
  asteroid_init();
}

static void display() {
  player_display(100, 100);
  asteroid_display();
}

static void update() {
  player_update();
  asteroid_update();
}

int main(void) {
  init();
  display();
  while(1) {
    nc_wait_vbl();
    update();
    nc_close_vbl();
  };
  nc_close_vbl();
  return 0;
}
