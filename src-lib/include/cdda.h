#ifndef CDDA_H
#define CDDA_H

#include <neocore.h>

void nc_sound_pause_cdda();
void nc_sound_resume_cdda();
void nc_sound_play_cdda(BYTE track);
#define nc_sound_stop_cdda() nc_sound_pause_cdda()

/** @deprecated Use nc_sound_play_cdda() instead */
void nc_play_cdda(BYTE track);

/** @deprecated Use nc_sound_pause_cdda() instead */
#define nc_pause_cdda() nc_sound_pause_cdda()
/** @deprecated Use nc_sound_resume_cdda() instead */
#define nc_resume_cdda() nc_sound_resume_cdda()
/** @deprecated Use nc_sound_stop_cdda() instead */
#define nc_stop_cdda() nc_sound_stop_cdda()

#endif