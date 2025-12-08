# RGB Color Mixer Sample

## Description

This sample provides an interactive RGB color mixer interface where users can adjust individual color components (Dark, Red, Green, Blue) using joypad controls. The backdrop color changes in real-time based on the selected values, demonstrating advanced palette manipulation and user interface creation.

## Features Demonstrated

- **Interactive RGB Color Mixing**: Real-time color adjustment using joypad input
- **Menu System**: Text-based user interface with cursor navigation
- **Color Value Display**: Live display of RGB component values
- **Backdrop Color Control**: Dynamic backdrop color changes based on user input
- **Joypad Edge Detection**: Responsive control input handling

## Key Functions Used

- `nc_palette_set_backdrop_rgb16()` - Sets backdrop color using RGB values
- `nc_rgb16_to_packed_color16()` - Converts RGB16 to packed color format
- `nc_joypad_set_edge_mode()` - Enables edge-triggered joypad input
- `nc_joypad_is_*()` - Joypad direction detection functions
- `nc_log_set_position()` - Positions text output
- `nc_log_info()` - Displays information text

## What You'll See

- An interactive menu showing "RGB COLOR MIXER"
- Adjustable color components (DARK, RED, GREEN, BLUE) with current values
- A cursor that can be moved up/down through the menu options
- Real-time backdrop color changes as you adjust values
- Visual feedback showing the current RGB values

## Controls

- **UP/DOWN**: Navigate through color components
- **LEFT/RIGHT**: Decrease/Increase selected color component value
- The backdrop color updates immediately to reflect changes

## Learning Objectives

- Understanding advanced palette manipulation techniques
- Creating interactive user interfaces in NeoCore
- Implementing responsive joypad controls with edge detection
- Working with color conversion functions
- Building menu-driven applications

## Technical Details

The sample uses RGB16 format with individual component ranges and provides a complete color mixing interface with real-time visual feedback.
