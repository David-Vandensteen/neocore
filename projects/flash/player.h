/*
  David Vandensteen
  2019
*/
#include <neocore.h>
#ifndef PLAYER_H
#define PLAYER_H

#define PLAYER_MAX_X  280
#define PLAYER_MIN_X  0

#define PLAYER_MAX_Y  200
#define PLAYER_MIN_Y  0

// todo - patch neocore
typedef struct Flash Flash;
struct Flash {
  short frequency;
  short lengh;
  BOOL visible;
  BOOL enabled;
};

// todo - patch neocore
typedef struct Animated_Sprite Animated_Sprite;
struct Animated_Sprite {
  aSprite as;
  Flash flash;
};

// todo - patch neocore
typedef struct Animated_Sprite_Physic Animated_Sprite_Physic;
struct Animated_Sprite_Physic {
  Animated_Sprite animated_sprite;
  box box;
  BOOL physic_enabled;
};


void player_init();
void player_update();
void player_display();
void player_collide(box *b);
void player_collides(box *boxes[], BYTE box_max);
aSpritePhysic *player_get();

#endif