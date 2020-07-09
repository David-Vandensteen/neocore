/*
  David Vandensteen
  2020
*/
#ifndef BULLET_PLAYER_H
#define BULLET_PLAYER_H
#define BULLET_MAX        20
#define WEAPON_XOFFSET    48
#define BULLET_RATE       10

void bullet_player_init();
void bullet_player_display(short x, short y);
void bullet_player_update(BOOL pstate, short x, short y);
void bullet_player_destroy();
#endif
