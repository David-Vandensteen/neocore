#include <neocore.h>
#include <math.h>

NEOCORE_INIT

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
