/*
  David Vandensteen
  2020
*/
#ifndef BULLET_PLAYER_H
#define BULLET_PLAYER_H
#define get_bullet_max()      5
#define get_bullet_xoffset()  48
#define get_bullet_rate()     10
#define get_bullet_speed()    7

void bullet_player_init();
void bullet_player_display(short x, short y);
void bullet_player_update(BOOL pstate, short x, short y);
void bullet_player_destroy();
#endif
