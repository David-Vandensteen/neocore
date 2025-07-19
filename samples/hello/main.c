#include <neocore.h>
#include "externs.h"

GFX_Picture neogeoLogo;

int main(void) {
  nc_init_display_gfx_picture(&neogeoLogo, (pictureInfo*)&logo, (paletteInfo*)&logo_Palettes, 100, 160);

  while(1) {
    nc_update();
    nc_init_log();

    nc_log_info("HELLO NEO GEO !!!");
    nc_next_line_log();
    nc_log_dword("FRAME : ", nc_get_frame_counter());
    nc_next_line_log();

    /* logger set automatically the cursor position on next line */
    nc_log_int("PRINT INT : ", 10);
    nc_log_short("PRINT SHORT", -10);

    /* formatting */
    nc_next_line_log();
    nc_log_info("DEC %d %d %d", 1, 2, 3);
    nc_log_info("HEX 0x%04X 0x%04X 0x%04X", 0x1234, 0x5678, 0x9abc);
    nc_next_line_log();
    nc_next_line_log();

    /* disable auto next line */
    nc_set_auto_next_line_log(false);
    nc_log_info("TEXT");
    nc_log_info(" WITHOUT");
    nc_log_info(" NEXT LINE");

    /* manual next line */
    nc_next_line_log();
    nc_log_info("NEXT LINE MANUAL");

    /* force a position */
    nc_set_position_log(7, 20);
    nc_log_info("DAVID VANDENSTEEN");
  };

  return 0;
}
