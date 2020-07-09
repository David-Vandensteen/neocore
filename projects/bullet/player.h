/*
  David Vandensteen
  2020
*/
#ifndef PLAYER_H
#define PLAYER_H
#include <DATLib.h>
#include <neocore.h>

#define PLAYER_SPRITE

#define PLAYER_SPEED  2
#define PLAYER_X_MIN  0
#define PLAYER_X_MAX  300
#define PLAYER_Y_MIN  0
#define PLAYER_Y_MAX  220

void player_init(short px, short py);
void player_display();
void player_update();
void player_position_set(short px, short py);
void player_move(short px, short py);
Box *player_box_get();
Animated_Sprite_Physic *player_get();
short player_position_get_x();
short player_position_get_y();
void player_show(BOOL visible);
void player_flash(BOOL flash, WORD freq);
BYTE player_collide_boxes(Box *boxes[], BYTE box_max);
BOOL player_collide_box(Box *box);
void player_explode();
void player_destroy();
#endif