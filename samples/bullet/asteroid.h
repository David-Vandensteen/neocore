/*
  David Vandensteen
  2020
*/
#ifndef ASTEROID_H
#define ASTEROID_H
void asteroid_init();
void asteroid_display();
void asteroid_update();
BOOL asteroid_collide(Box *b);
#endif