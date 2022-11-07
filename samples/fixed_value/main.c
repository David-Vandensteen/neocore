#include <neocore.h>

int main(void) {
  FIXED val1 = FIX(10.5);
  FIXED val2 = FIX(10.5);
  init_gpu();
  init_log();
  log_int("10.5 ADD 10.5 : ", fixtoi(fadd(val1, val2)));
  while(1) {
    wait_vbl();
    close_vbl();
  };
  close_vbl();
  return 0;
}
