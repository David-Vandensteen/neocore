/*
  David Vandensteen
  2020
*/
#ifndef BULLET_PLAYER_H
#define BULLET_PLAYER_H
#define BULLET_MAX        20
#define BULLET_XOFFSET    48
#define BULLET_RATE       10
#define BULLET_SPEED      7

void bullet_player_init();
void bullet_player_display(short x, short y);
void bullet_player_update(BOOL pstate, short x, short y);
void bullet_player_destroy();
#endif
