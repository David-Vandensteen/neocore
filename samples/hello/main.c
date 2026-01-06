#include <neocore.h>
#include "externs.h"

static GFX_Picture neogeoLogo;


int main(void) {
  nc_gfx_init_and_display_picture(&neogeoLogo, logo_pict_rom.pictureInfo, logo_pict_rom.paletteInfo, 100, 160);

  while(1) {
    nc_gpu_update();
    nc_log_init();

    /* nc_log_info_line - adds automatic newline */
    nc_log_info_line("HELLO NEO GEO !!!");
    nc_log_info_line("FRAME : %08ld", nc_gpu_get_frame_number());

    /* nc_log_info - no automatic newline, continues on same line */
    nc_log_info("PRINT INT: ");
    nc_log_info("%d", 10);
    nc_log_next_line(); /* manually go to next line */
    nc_log_int(10); /* alternative way to log an integer */
    nc_log_info(" PRINT SHORT: ");
    nc_log_info("%d", -10);
    nc_log_next_line(); /* manually go to next line */
    nc_log_short(-10);
    nc_log_next_line(); /* manually go to next line */

    /* using nc_log_info_line for automatic newlines */
    nc_log_info_line("DEC %d %d %d", 1, 2, 3);
    nc_log_info_line("HEX 0x%04X 0x%04X 0x%04X", 0x1234, 0x5678, 0x9abc);
    nc_log_info_line("");

    /* text with manual newlines - position updated automatically */
    nc_log_info("TEXT\nWITH\nMANUAL\nNEWLINES\n");
    nc_log_next_line();

    /* normal text - no automatic newline, stays on same line */
    nc_log_info("NORMAL TEXT ");
    nc_log_info("CONTINUES ");
    nc_log_info("ON SAME LINE");
    nc_log_next_line(); /* manually go to next line */

    /* text ending with newline - position updated automatically */
    nc_log_info("TEXT WITH ENDING NEWLINE\n");

    /* force a position */
    nc_log_set_position(7, 20);
    nc_log_info_line("DAVID VANDENSTEEN");
  };

  return 0;
}
