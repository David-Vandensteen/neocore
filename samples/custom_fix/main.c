#include <neocore.h>
#include "externs.h"

int main(void) {
  WORD font0_palette_index;

  nc_init_log();
  font0_palette_index = nc_fix_load_palette_info(&font0_Palettes);

  /* System font with default palette */
  nc_set_position_log(2, 4);
  nc_log_info_line("HELLO WORLD");
  nc_log_next_line();

  /* Custom font0 with custom palette */
  nc_fix_set_bank(3);                               /* Custom font0 bank */
  nc_fix_set_palette_id(font0_palette_index);             /* Custom palette */
  nc_log_info_line("CUSTOM FONT");
  nc_log_info_line("PALETTE INDEX: %d", font0_palette_index);
  nc_log_next_line();

  /* Formatted text with system font */
  nc_fix_set_bank(0);
  nc_fix_set_palette_id(0);
  nc_log_info_line("SCORE: %d", 12500);
  nc_log_next_line();

  /* Formatted text with custom font0 */
  nc_fix_set_bank(3);
  nc_fix_set_palette_id(font0_palette_index);
  nc_log_info_line("LIVES: %d", 3);
  nc_log_next_line();

  /* Time formatting with system font */
  nc_fix_set_bank(0);
  nc_fix_set_palette_id(0);
  nc_log_info_line("TIME: %02d:%02d", 5, 30);
  nc_log_next_line();

  /* Level with custom font0 */
  nc_fix_set_bank(3);
  nc_fix_set_palette_id(font0_palette_index);
  nc_log_info_line("LEVEL %d", 7);
  nc_log_next_line();

  nc_fix_set_bank(5);
  nc_log_info("AOZ");


  while(1) {
    nc_update();
  };

  return 0;
}
