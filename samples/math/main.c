#include <neocore.h>

int main(void) {
  FIXED val1 = nc_math_fix(10.5);
  FIXED val2 = nc_math_fix(10.5);

  nc_log_init();
  nc_log_info_line("10.5 ADD 10.5 : %d", nc_math_fix_to_int(nc_math_fix_add(val1, val2)));
  nc_log_info_line("11 MULT 2 : %d", nc_math_bitwise_multiplication_2(11));
  nc_log_info_line("11 MULT 4 : %d", nc_math_bitwise_multiplication_4(11));
  nc_log_info_line("40 DIV 4 : %d", nc_math_bitwise_division_4(40));
  nc_log_info_line("MIN 15, 20 : %d", nc_math_min(15, 20));
  nc_log_info_line("MAX 15, 20 : %d", nc_math_max(15, 20));
  nc_log_info("ABS -11: %d", nc_math_abs(-11));

  while(1) {
    nc_gpu_update();
  };

  return 0;
}
