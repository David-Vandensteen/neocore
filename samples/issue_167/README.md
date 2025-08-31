# Sprite Animation Sample

![](https://media.giphy.com/media/TLfbmyW3523z24WONz/giphy.gif)

## Description

Comprehensive sprite demo showcasing animated sprites, scrolling backgrounds, and player movement with animations.

## Features Demonstrated

- **Animated Sprites**: Player character with multiple animation states
- **Scrolling Background**: Continuously moving background graphics
- **Static Graphics**: Stationary planet object
- **Movement Controls**: Real-time player movement and animation state changes

## Key Functions Used

- `nc_init_display_gfx_animated_sprite()` - Create animated sprite
- `nc_init_display_gfx_scroller()` - Create scrolling background
- `nc_init_display_gfx_picture()` - Create static picture
- `nc_move_gfx_animated_sprite()` - Move animated sprite
- `nc_set_animation_gfx_animated_sprite()` - Change animation state
- `nc_update_animation_gfx_animated_sprite()` - Update animation frames

## Controls

- **Arrow Keys**: Move player character
- **UP Arrow**: Move up + change to UP animation
- **DOWN Arrow**: Move down + change to DOWN animation
- **LEFT/RIGHT Arrows**: Move horizontally
- **No Input**: Returns to IDLE animation

## What You'll See

- Scrolling space background that loops continuously
- Static planet graphic positioned on screen
- Player sprite that moves with arrow keys
- Player animation changes based on movement direction:
  - `PLAYER_SPRITE_ANIM_IDLE` - When not moving vertically
  - `PLAYER_SPRITE_ANIM_UP` - When moving up
  - `PLAYER_SPRITE_ANIM_DOWN` - When moving down

## Technical Details

- Background scrolls horizontally and resets position when it reaches the edge
- Player movement is bounded by screen limits
- Animation state automatically returns to IDLE when vertical movement stops
- All graphics use their respective palette data

## Learning Objectives

This sample teaches:
- How to create and manage animated sprites
- Implementing scrolling backgrounds
- Handling real-time player input and movement
- Managing multiple animation states
- Coordinating multiple graphics objects in a single application