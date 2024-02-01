#include <neocore.h>
#include "externs.h"

GFX_Picture neogeoLogo;

int main(void) {
  nc_init_gfx_picture(&neogeoLogo, &logo, &logo_Palettes);
  nc_display_gfx_picture(&neogeoLogo, 100, 160);

  while(1) {
    nc_update();
    nc_init_log();
    /* logger set automatically the cursor position on next line */
    nc_log_info("HELLO NEO GEO !!!");
    nc_log_info("");
    nc_log_dword("FRAME : ", nc_get_frame_counter());
    nc_log_info("");
    nc_log_int("PRINT INT : ", 10);
    nc_log_short("PRINT SHORT", -10);

    /* force a position */
    nc_set_position_log(7, 20);
    nc_log_info("DAVID VANDENSTEEN");
    /* logger is an easy way to write a text without coordinate constraint */
  };

  return 0;
}
