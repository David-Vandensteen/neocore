#include <neocore.h>

int main(void) {
  FIXED val1 = nc_fix(10.5);
  FIXED val2 = nc_fix(10.5);

  nc_init_log();
  nc_log_int("10.5 ADD 10.5 : ", nc_fix_to_int(nc_fix_add(val1, val2)));
  nc_log_short("11 MULT 2 : ", nc_bitwise_multiplication_2(11));
  nc_log_short("11 MULT 4 : ", nc_bitwise_multiplication_4(11));
  nc_log_short("40 DIV 4 : ", nc_bitwise_division_4(40));
  nc_log_short("MIN 15, 20 : ", nc_min(15, 20));
  nc_log_short("MAX 15, 20 : ", nc_max(15, 20));
  nc_log_short("ABS -11", nc_abs(-11));

  while(1) {
    nc_update();
  };

  return 0;
}
