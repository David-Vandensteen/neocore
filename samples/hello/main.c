/*
  David Vandensteen
  2019
  <dvandensteen@gmail.com>
*/

#include <neocore.h>
#include "externs.h"

GFX_Picture neogeoLogo;

int main(void) {
  init_gpu();
  init_gfx_picture(&neogeoLogo, &logo, &logo_Palettes);
  display_gfx_picture(&neogeoLogo, 100, 160);
  while(1) {
    wait_vbl();
    init_log();
    /* logger set automatically the cursor position on next line */
    log_info("HELLO NEO GEO !!!");
    log_info("");
    log_dword("FRAME : ", get_frame_counter());
    log_info("");
    log_int("PRINT INT : ", 10);
    log_short("PRINT SHORT", -10);

    /* force a position */
    set_position_log(7, 20);
    log_info("DAVID VANDENSTEEN");
    /* logger is an easy way to write a text without coordinate constraint */

    close_vbl();
  };
  close_vbl();
  return 0;
}
