#include <neocore.h>

int main(void) {
  nc_set_joypad_edge_mode(true);

  while(1) {
    nc_update();
    nc_init_log();
    nc_log_info("INTERACT WITH JOYPAD ...");
    nc_debug_joypad(0);

    if (nc_joypad_is_up(0)) nc_log_info("ITS UP !");
    if (nc_joypad_is_down(0)) nc_log_info("ITS DOWN !");
    if (nc_joypad_is_left(0)) nc_log_info("ITS LEFT !");
    if (nc_joypad_is_right(0)) nc_log_info("ITS RIGHT !");
    if (nc_joypad_is_a(0)) nc_log_info("ITS A !");
    if (nc_joypad_is_b(0)) nc_log_info("ITS B !");
    if (nc_joypad_is_c(0)) nc_log_info("ITS C !");
    if (nc_joypad_is_d(0)) nc_log_info("ITS D !");
  };

  return 0;
}
