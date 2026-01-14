#include <neocore.h>
#include <cdda.h>

void nc_sound_play_cdda(BYTE track) {
  nc_system_init_shadow();
  disableIRQ();
  asm(
    "loop_track_%=:              \n\t"
    "move.b  %0,%%d0             \n\t"
    "tst.b   0x10F6D9            \n\t"
    "beq.s   loop_track_%=       \n\t"
    "jsr     0xC0056A"
    :
    : "d"(track)
    : "d0"
  );
  enableIRQ();
}

void nc_sound_pause_cdda() {
  disableIRQ();
  asm(" move.w #0x200,%d0");
  asm(" jsr  0xC0056A");
  enableIRQ();
}

void nc_sound_resume_cdda() {
  disableIRQ();
  asm(" move.w #0x300,%d0");
  asm(" jsr  0xC0056A");
  enableIRQ();
}

// Legacy Sound functions
void nc_play_cdda(unsigned char track) {
  nc_sound_play_cdda(track);
}
