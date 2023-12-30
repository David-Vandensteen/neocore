#include <neocore.h>

int main(void) {
  FIXED val1 = FIX(10.5);
  FIXED val2 = FIX(10.5);
  nc_init_log();
  nc_log_int("10.5 ADD 10.5 : ", fixtoi(fadd(val1, val2)));
  while(1) {
    nc_update();
    nc_close_vbl();
  };
  nc_close_vbl();
  return 0;
}
