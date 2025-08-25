# Joypad Input Sample

## Description

Demonstrates joypad input handling and edge mode detection in NeoCore.

## Features Demonstrated

- **Joypad Input Detection**: All standard Neo Geo buttons and directions
- **Edge Mode**: Button press detection (not continuous holding)
- **Debug Information**: Real-time joypad state display

## Key Functions Used

- `nc_set_joypad_edge_mode(true)` - Enable edge detection mode
- `nc_debug_joypad(0)` - Display joypad state information
- `nc_joypad_is_up/down/left/right()` - Directional input detection
- `nc_joypad_is_a/b/c/d()` - Button input detection

## Controls

- **Arrow Keys**: UP, DOWN, LEFT, RIGHT detection
- **A/B/C/D Buttons**: Action button detection

## What You'll See

- "INTERACT WITH JOYPAD ..." prompt
- Real-time joypad debug information
- Messages for each input detected:
  - "ITS UP !", "ITS DOWN !", "ITS LEFT !", "ITS RIGHT !"
  - "ITS A !", "ITS B !", "ITS C !", "ITS D !"

## Edge Mode Explained

With edge mode enabled (`nc_set_joypad_edge_mode(true)`), inputs are detected only on the frame when the button is first pressed, not continuously while held down. This is useful for menu navigation and discrete actions.

## Learning Objectives

This sample teaches:
- How to handle joypad input in NeoCore
- Difference between edge mode and continuous input detection
- Using debug functions to monitor input state
- Basic input-driven application structure
