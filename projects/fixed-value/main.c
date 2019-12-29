#include <neocore.h>
#include <math.h>

NEOCORE_INIT

int main(void) {
  FIXED val1 = FIX(10.5);
  FIXED val2 = FIX(10.5);
  GPU_INIT
  logger_init();
  logger_int("10.5 ADD 10.5 : ", fixtoi(fadd(val1, val2)));
  while(1) {
    WAIT_VBL
    SCClose();
  };
  SCClose();
  return 0;
}
