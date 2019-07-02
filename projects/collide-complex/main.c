#include <neocore.h>

#define PEAK2_MASK_VECTOR_MAX 6

typedef struct bkp_ram_info {
	WORD debug_dips;
	BYTE stuff[254];
	//256 bytes
} bkp_ram_info;

bkp_ram_info bkp_data;

static vec2short peak2_mask[PEAK2_MASK_VECTOR_MAX];
static vec2short peak2_mask_offset[PEAK2_MASK_VECTOR_MAX];
static void init_mask();
static void init();
static void display();
static void update();
static void mask_update();

static void init() {
  init_mask();
}

static void display() {

}

static void init_mask() {
  peak2_mask_offset[0].x = 50;
  peak2_mask_offset[0].y = 5;

  peak2_mask_offset[1].x = 67;
  peak2_mask_offset[1].y = 5;

  peak2_mask_offset[2].x = 70;
  peak2_mask_offset[2].y = 80;

  peak2_mask_offset[3].x = 80;
  peak2_mask_offset[3].y = 130;

  peak2_mask_offset[4].x = 10;
  peak2_mask_offset[4].y = 130;

  peak2_mask_offset[5].x = 35;
  peak2_mask_offset[5].y = 55;
}

int main(void) {

  gpuInit();
  while(1) {
    waitVBlank();
    loggerInit();
    loggerInfo("HELLO NEO GEO !!!");
    SCClose();
  };
	SCClose();
  return 0;
}
