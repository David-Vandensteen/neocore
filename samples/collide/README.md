# Collision Detection Sample

## Description

Demonstrates collision detection between physics-enabled sprites using NeoCore's physic system.

## Features Demonstrated

- **Physics Sprites**: Sprites with collision detection capabilities
- **Collision Detection**: Real-time collision checking between objects
- **Movement Physics**: Sprite movement with physics properties
- **Visual Feedback**: Collision state indication

## Key Functions Used

- `nc_init_display_gfx_animated_sprite_physic()` - Create physics-enabled animated sprite
- `nc_init_display_gfx_picture_physic()` - Create physics-enabled static sprite
- `nc_gfx_move_animated_physic_sprite()` - Move physics sprite
- `nc_check_collision_*()` - Collision detection functions

## Controls

- **Arrow Keys**: Move the player sprite
- **Movement**: Use directional keys to move player around the screen

## What You'll See

- Player sprite (animated) that can be moved around
- Asteroid sprite (static) positioned on screen
- Collision detection feedback when sprites overlap
- Physics boundaries and collision boxes

## Technical Details

- Player sprite has defined collision dimensions (10x10 pixels)
- Asteroid sprite has collision area (32x32 pixels)
- Physics system handles collision detection automatically
- Collision state is checked and reported each frame

## Learning Objectives

This sample teaches:
- How to create physics-enabled sprites
- Implementing collision detection systems
- Understanding collision boundaries and hit boxes
- Managing physics properties in sprite systems
- Real-time collision state monitoring
