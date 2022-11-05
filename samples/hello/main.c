/*
  David Vandensteen
  2019
  <dvandensteen@gmail.com>
*/

#include <neocore.h>
#include "externs.h"

NEOCORE_INIT

GFX_Picture neogeoLogo;

int main(void) {
  init_gpu();
  init_gp(&neogeoLogo, &logo, &logo_Palettes);
  display_gp(&neogeoLogo, 100, 160);
  while(1) {
    wait_vbl();
    init_logger();
    /* logger set automatically the cursor position on next line */
    logger_info("HELLO NEO GEO !!!");
    logger_info("");
    logger_dword("FRAME : ", DAT_frameCounter);
    logger_info("");
    logger_int("PRINT INT : ", 10);
    logger_short("PRINT SHORT", -10);

    /* force a position */
    logger_set_position(7, 20);
    logger_info("DAVID VANDENSTEEN");
    /* logger is an easy way to write a text without coordinate constraint */

    close_vbl();
  };
  close_vbl();
  return 0;
}
