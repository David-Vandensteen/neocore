#include <neocore.h>
#include <math.h>
#include "externs.h"

#define SPRITE_MANAGER_INDEX_MAX 20

NEOCORE_INIT

static void init();
static void display();
static void update();

static BOOL sprite_manager_index_status[SPRITE_MANAGER_INDEX_MAX];

static void sprite_manager_init() {
  WORD i = 0;
  for (i = 0; i <= 10; i++) sprite_manager_index_status[i] = true;
  for (i = 11; i < SPRITE_MANAGER_INDEX_MAX; i++) sprite_manager_index_status[i] = false;
}

static WORD sprite_manager_get_free(WORD max) {
  // TODO : optimize
  WORD i, j = 0;
  BOOL found = false;
  for( i = 0; i < SPRITE_MANAGER_INDEX_MAX; i++) {
    if (!sprite_manager_index_status[i]) {
      for (j = i; j < i + max; j++) {
        if (!found) found = (!sprite_manager_index_status[j]) ? true : false;
      }
      if (found) return i;
    }
  }
  return 0;
}

static void sprite_manager_set(WORD index) {
  sprite_manager_index_status[index] = true;
}

static void sprite_manager_destroy(WORD index) {
  sprite_manager_index_status[index] = false;
}

static void sprite_manager_debug() {
  WORD i = 0;
  logger_init();
  for (i = 0; i < SPRITE_MANAGER_INDEX_MAX; i++) {
    logger_bool(" ", sprite_manager_index_status[i]);
  }
  logger_word("FOUND : ", sprite_manager_get_free(3));
}

static void init() {
  GPU_INIT
  sprite_manager_init();
}

static void display() {

}

static void update() {
  sprite_manager_debug();
}

int main(void) {
  init();
  display();
  sprite_manager_set(12);
  while(1) {
    WAIT_VBL
    update();
    SCClose();
  };
  SCClose();
  return 0;
}
