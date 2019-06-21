#include <neocore.h>

typedef struct bkp_ram_info {
	WORD debug_dips;
	BYTE stuff[254];
	//256 bytes
} bkp_ram_info;

bkp_ram_info bkp_data;

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
