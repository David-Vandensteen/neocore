# Test GAS (Graphics Animated Sprite) Sample

## Description

This sample tests the Graphics Animated Sprite (GAS) system functionality, validating animated sprite initialization, display, and animation sequencing. It focuses on testing the core animated sprite management features of NeoCore.

## Features Demonstrated

- **Animated Sprite Initialization**: Testing `nc_init_display_gfx_animated_sprite()`
- **Animation Sequence Management**: Handling sprite animation states
- **Frame Sequencing**: Testing frame accumulator and timing systems
- **Position Management**: Sprite positioning and movement validation
- **Animation State Control**: Testing different animation states (IDLE, etc.)

## Key Functions Used

- `nc_init_display_gfx_animated_sprite()` - Initializes and displays animated sprites
- Animation frame management functions
- Position structure manipulation
- Sprite animation state control

## What You'll See

- An animated sprite character (player) at position (100, 100)
- Animation sequence testing with IDLE state
- Frame accumulator testing with various timing values
- Visual validation of sprite animation functionality

## Learning Objectives

- Understanding the Graphics Animated Sprite (GAS) system
- Learning proper animated sprite initialization procedures
- Working with animation frame sequences and timing
- Testing sprite system stability and performance
- Validating animation state management

## Technical Details

- Tests sprite initialization at specific coordinates (100, 100)
- Uses `PLAYER_SPRITE_ANIM_IDLE` animation state
- Implements frame accumulator with value of 200
- Validates proper sprite resource loading and display
- Tests animation timing and sequence management

## System Testing

This sample is crucial for validating:
- Animated sprite system functionality
- Resource loading and management
- Animation timing accuracy
- Memory management for animated sprites
- Graphics system stability
