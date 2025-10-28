#include <neocore.h>
#include "externs.h"

static GFX_Picture neogeoLogo;

int main(void) {
  nc_gfx_init_and_display_picture(&neogeoLogo, &logo, &logo_Palettes, 100, 160);

  while(1) {
    nc_gpu_update();
    nc_log_init();
    nc_log_set_position(0, 0);
    nc_log_info_line("LINE 1 : Do you see this line ?");
    nc_log_info_line("LINE 2 : Do you see line 1 ?");
  }

  return 0;
}
