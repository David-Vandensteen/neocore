#include <neocore.h>
#include "externs.h"

static GFX_Picture neogeoLogo;

int main(void) {
  nc_init_display_gfx_picture(&neogeoLogo, &logo, &logo_Palettes, 100, 160);

  while(1) {
    nc_update();
    nc_init_log();
    nc_set_position_log(0, 0);
    nc_log_info_line("LINE 1 : Do you see this line ?");
    nc_log_info_line("LINE 2 : Do you see line 1 ?");
  }

  return 0;
}
