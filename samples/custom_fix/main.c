#include <neocore.h>
#include "externs.h"

static GFX_Picture neogeoLogo;

int main(void) {
  nc_init_display_gfx_picture(&neogeoLogo, &logo, &logo_Palettes, 100, 160);

  while(1) {
    nc_update();
    nc_init_log();
    nc_log_info_line("HELLO NEO GEO !!!");
  }
  return 0;
}
