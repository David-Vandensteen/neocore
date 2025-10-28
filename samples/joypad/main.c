#include <neocore.h>

int main(void) {
  nc_joypad_set_edge_mode(true);

  while(1) {
    nc_gpu_update();
    nc_log_init();
    nc_log_info_line("INTERACT WITH JOYPAD ...");
    nc_joypad_debug(0);

    if (nc_joypad_is_up(0)) nc_log_info_line("ITS UP !");
    if (nc_joypad_is_down(0)) nc_log_info_line("ITS DOWN !");
    if (nc_joypad_is_left(0)) nc_log_info_line("ITS LEFT !");
    if (nc_joypad_is_right(0)) nc_log_info_line("ITS RIGHT !");
    if (nc_joypad_is_a(0)) nc_log_info_line("ITS A !");
    if (nc_joypad_is_b(0)) nc_log_info_line("ITS B !");
    if (nc_joypad_is_c(0)) nc_log_info_line("ITS C !");
    if (nc_joypad_is_d(0)) nc_log_info("ITS D !");
  };

  return 0;
}
