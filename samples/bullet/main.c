#include <neocore.h>
#include <math.h>
#include "player.h"
#include "asteroid.h"

static void init();
static void display();
static void update();

static void init() {
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
    nc_update();
    update();
  };

  return 0;
}
