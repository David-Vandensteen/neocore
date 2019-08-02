/*
  David Vandensteen
  2019
  <dvandensteen@gmail.com>
*/

#include <neocore.h>

NEOCORE_INIT

int main(void) {
  gpuInit();
  while(1) {
    waitVBlank();
    loggerInit();
    /* logger set automatically the cursor position on next line */
    loggerInfo("HELLO NEO GEO !!!");
    loggerInfo("");
    loggerDword("FRAME : ", DAT_frameCounter);
    loggerInfo("");
    loggerInt("PRINT INT : ", 10);
    loggerShort("PRINT SHORT", -10);

    /* force a position */
    loggerPositionSet(7, 20);
    loggerInfo("DAVID VANDENSTEEN");

    /* logger is an easy way to write a text without coordinate constraint */

    SCClose();
  };
  SCClose();
  return 0;
}
