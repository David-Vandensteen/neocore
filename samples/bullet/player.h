/*
  David Vandensteen
  2020
*/
#ifndef PLAYER_H
#define PLAYER_H
#include <neocore.h>

#define get_player_speed() 2
#define get_player_min_x() 0
#define get_player_min_y() 0
#define get_player_max_x() 300
#define get_player_max_y() 220

void player_init();
void player_display(short px, short py);
void player_update();

#endif